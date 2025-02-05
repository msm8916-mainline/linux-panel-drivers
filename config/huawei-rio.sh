#!/usr/bin/env bash
# DTB: 05_dtbdump_,Qualcomm_MSM_8939_HUAWEI_RIO-AL00_VB.dtb from unofficial twrp

OPTIONS=(-r vsp -r vsn --dumb-dcs)
PANELS=(
	[boe_otm1901_5p5_1080p_video]="huawei,rio-boe-otm1901"
	[cmi_nt35532_5p5_1080p_video]="huawei,rio-cmi-nt35532"
	[tianma_nt35596_5p5_1080p_video]="huawei,rio-tianma-nt35596"
)
