#!/usr/bin/env bash
# DTB: Extracted from stock boot image

# --dcs-no-get-brightness: actual_brightness is 0-10 levels off
OPTIONS=(-r vsp -r vsn --dcs-no-get-brightness)
PANELS=(
	[tianma_nt35521_5p5_720p_video]="huawei,tianma-nt35521"
)
