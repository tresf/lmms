# Initial branding cmake file
# Just used for testing currently

# TODO: Unused
set(branding_files
	# installed
	data/themes/default/splash.png
	data/themes/default/icon.png
	# apple
	cmake/apple/lmms.icns
	# windows
	cmake/nsis/lmms.ico
)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/branding/modules" ${CMAKE_MODULE_PATH})
#file(REMOVE_RECURSE "${CMAKE_BINARY_DIR}/branding")
file(REMOVE_RECURSE "${CMAKE_BINARY_DIR}/lmms.iconset")

include(SvgRecolor)
set(svg_green "#27ab5f;#249a56;#34d07b;opacity=\".1\" fill=\"#fff\"")
set(svg_blue "#3992cb;#2b6fc5;#62a8d4;opacity=\".1\" fill=\"#fff\"")
set(svg_purple "#5547bd;#493ba1;#7871c5;opacity=\".05\" fill=\"#fff\"")

svg_recolor(svg_green svg_purple "${CMAKE_SOURCE_DIR}/cmake/linux/icons/scalable/apps/lmms.svg" svg_recolored)

#include(SvgConvert)
#svg_convert("16;16@2;32;32@2;48;48@2" "${svg_recolored}" "${CMAKE_CURRENT_BINARY_DIR}/%size%x%size%@%mult%/%name%.png")

# Windows
include(IcoConvert)
ico_convert("${svg_recolored}" "${CMAKE_CURRENT_BINARY_DIR}/lmms.ico")

# Mac
include(IcnsConvert)
icns_convert("${svg_recolored}" "${CMAKE_CURRENT_BINARY_DIR}/lmms.icns")

message(FATAL_ERROR "Done")