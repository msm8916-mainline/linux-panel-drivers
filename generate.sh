#!/usr/bin/env bash
set -eu
shopt -s extglob

PROJECT="msm8916"
REPOSITORY="msm8916-mainline/linux-panel-drivers"
KCONFIG="CONFIG_DRM_PANEL_${PROJECT^^}_GENERATED"
GENERATOR="linux-mdss-dsi-panel-driver-generator"

# Unset some variables that git sets while in rebase session
unset "${!GIT_@}"

export GIT_AUTHOR_NAME="lmdpdg"
export GIT_AUTHOR_EMAIL="<lmdpdg@localhost>"

KERNEL_DIR="$PWD"
BASE_DIR=$(dirname "$(readlink -f "$0")")
OUT_DIR="$BASE_DIR/out"
LMDPDG_DIR="$BASE_DIR/$GENERATOR"

declare -a OPTIONS
declare -A PANELS
declare -a kconfig_lines

KCONFIG_HEAD="\
menu \"MSM8916 panel drivers generated with $GENERATOR\"
	depends on GPIOLIB && OF && REGULATOR
	depends on DRM_MIPI_DSI

config ${KCONFIG#CONFIG_}
	tristate \"Select all generated ${PROJECT^^} panel drivers by default\"
"
KCONFIG_PANEL="	default ${KCONFIG#CONFIG_}\n"

echo "Generating panel drivers..."
rm -rf "$OUT_DIR"
cd "$BASE_DIR/config"
for CONFIG in *.sh; do
	echo "======== $CONFIG ========"

	DIR="$OUT_DIR/${CONFIG%.*}"
	DTB="$BASE_DIR/dtb/${CONFIG%%.*}.dtb"
	source "$BASE_DIR/config/$CONFIG"

	mkdir -p "$DIR"
	cd "$DIR"

	"$LMDPDG_DIR/lmdpdg.py" "${OPTIONS[@]}" "$DTB"

	for panel in "${!PANELS[@]}"; do
		compatible="${PANELS[$panel]}"
		panel_id="${compatible/-panel-/-}"
		vendor="${panel_id%%,*}"
		name="${panel_id##*,}"
		name="${name//-/ }"
		name="${vendor^} ${name^^}"
		kconfig="CONFIG_DRM_PANEL_${panel_id//[,-]/_}"
		kconfig="${kconfig^^}"
		driver="panel-${panel_id/,/-}"
		kconfig_lines+=("config ${kconfig#CONFIG_}\n	tristate \"$name\"\n$KCONFIG_PANEL")
		echo "obj-\$($kconfig) += $driver.o" >> "$OUT_DIR/Makefile"
		cp "$panel"/panel-!(simple-*).c "$OUT_DIR/$driver.c"
		sed -Ei "s/\.compatible = \".+\"/.compatible = \"$compatible\"/g" "$OUT_DIR/$driver.c"
	done
done
new_panel_drivers=("$OUT_DIR"/panel-*.c)
sort -o "$OUT_DIR/Makefile" "$OUT_DIR/Makefile"

echo "$KCONFIG_HEAD" > "$OUT_DIR/Kconfig"
echo -e "$(IFS=$'\n'; sort <<< "${kconfig_lines[*]}")" >> "$OUT_DIR/Kconfig"
echo "endmenu" >> "$OUT_DIR/Kconfig"

echo "Checking kernel source tree (run script from root directory of kernel tree)..."
cd "$KERNEL_DIR/drivers/gpu/drm/panel"

if output=$(git status --porcelain -- .) && [ -n "$output" ]; then
	echo "Working directory (drivers/gpu/drm/panel) is not clean. Sad. :("
	echo "$output"
	exit 1
fi

squash=""
if [ -d "$PROJECT-generated" ]; then
	squash="squash! "
	echo "Note: Panel drivers already generated, only updating unmodified ones!"

	all_panel_drivers=("${new_panel_drivers[@]}")
	new_panel_drivers=()
	for driver_path in "${all_panel_drivers[@]}"; do
		driver="${driver_path##*/}"
		if [ ! -f "$PROJECT-generated/$driver" ]; then
			echo "Creating $driver"
			new_panel_drivers+=("$driver_path")
			continue
		fi

		if git log --remove-empty --format="%an" -- "$PROJECT-generated/$driver" \
			| grep -qv "$GIT_AUTHOR_NAME";
		then
			echo "Skipping $driver: modified in another commit"
			continue
		fi

		#echo "Updating $driver"
		new_panel_drivers+=("$driver_path")
	done
else
	echo "obj-y += $PROJECT-generated/" >> Makefile
	sed -i "/^endmenu/i source \"drivers/gpu/drm/panel/$PROJECT-generated/Kconfig\"" Kconfig
	mkdir "$PROJECT-generated"
fi

commit_message="$squash${PROJECT^^}: drm/panel: Generate using $GENERATOR

X-Code-Generator: $REPOSITORY@$(git -C "$BASE_DIR" describe --always --dirty=' (dirty)')
Signed-off-by: $GIT_AUTHOR_NAME $GIT_AUTHOR_EMAIL"

cp "$OUT_DIR"/{Kconfig,Makefile} "$PROJECT-generated/"
cp "${new_panel_drivers[@]}" "$PROJECT-generated/"
git add "$PROJECT-generated"
git commit -qm "$commit_message" -- .
git --no-pager show --stat
