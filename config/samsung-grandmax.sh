#!/usr/bin/env bash
# DTB: From AP_G720AXUBS1AQE2_CL472443_QB13753684_REV00_user_low_ship_MULTI_CERT.tar.md5

OPTIONS=(-r vcc -r vsp -r vsn --backlight-gpio --dcs-no-get-brightness)
PANELS=(
	[s6d2aa0x_hd_video]="samsung,s6d2aa0x62-lpm053a250a"
)
