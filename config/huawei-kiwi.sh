#!/usr/bin/env bash
# DTB: 30_dtbdump_,Qualcomm_MSM_8939_HUAWEI_KIW-L21.dtb from twrp-3.4.0-0-kiwi.img
# https://eu.dl.twrp.me/kiwi/twrp-3.4.0-0-kiwi.img.html

OPTIONS=(-r vsp -r vsn --dumb-dcs)
PANELS=(
	[auo_otm1901a_5p5_1080pxa_video]="huawei,kiwi-auo-otm1901a"
	[cmi_nt35532_5p5_1080pxa_video]="huawei,kiwi-cmi-nt35532"
	[tianma_nt35596_5p5_1080pxa_video]="huawei,kiwi-tianma-nt35596"
)
