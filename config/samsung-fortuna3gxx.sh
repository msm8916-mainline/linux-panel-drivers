#!/usr/bin/env bash
# DTB: From G530HXXU2BOH7_G530HODD2BOH3_G530HXXU2BOH5_HOME.tar.md5 INS-G530HXXU2BOH7-20150909215514.zip

OPTIONS=(-r vddio -r vdd --backlight-fallback-dcs --dcs-no-get-brightness)
PANELS=(
	[hx8389c_gh9607501a_qhd]="samsung,hx8389c-gh9607501a"
	[s6d78a0_gh9607501a_qhd]="samsung,s6d78a0-gh9607501a"
)
