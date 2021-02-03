#!/usr/bin/env bash
# DTB: From HARPIA_NPIS26.48-43-2_cid50_subsidy-DEFAULT_regulatory-DEFAULT_CFC.xml.zip

OPTIONS=(-r vsp -r vsn --backlight-gpio --dcs-no-get-brightness)
PANELS=(
	[boe_499_720p_video_v1]="motorola,harpia-panel-boe"
	[tianma_499_720p_video_v2]="motorola,harpia-panel-tianma"
)
