# linux-panel-drivers
This repository contains the [linux-mdss-dsi-panel-driver-generator] configuration
for all the generated panel drivers used in [msm8916-mainline/linux]. Eventually,
those drivers should be upstreamed but it's not clear yet how so many panel drivers
can be upstreamed in a maintainable way.

Until then, this repository makes it easy to regenerate all panel drivers when
changes are made upstream.

## Usage
```
$ git clone --recursive https://github.com/msm8916-mainline/linux-panel-drivers.git
```

or alternatively:

```
$ git clone https://github.com/msm8916-mainline/linux-panel-drivers.git
$ cd linux-panel-drivers
$ git submodule update --init
```

Also make sure to run `git submodule update` when pulling new changes!

```
$ cd path/to/your/kernel/source
$ path/to/linux-panel-drivers/generate.sh
```

This will generate a single commit with all panel drivers. If the panel drivers
were already generated in a previous commit, it will attempt to only generate
new drivers and/or update existing ones. This works only if the panel drivers
were not modified after they were automatically generated.

### Adding new panel drivers
Copy the device tree blob (DTB) for your device into the `dtb` folder.
Then, create a new config script in the `config` folder with the options for
[linux-mdss-dsi-panel-driver-generator] and the panels to generate.

[linux-mdss-dsi-panel-driver-generator]: https://github.com/msm8916-mainline/linux-mdss-dsi-panel-driver-generator
[msm8916-mainline/linux]: https://github.com/msm8916-mainline/linux
