# Provide branding steps
# - Files created here are intended for install-time
# - Files used for build-time are source-only and are currently not supported
# - For packaging steps, see LinuxDeploy.cmake, MacDeployQt.cmake

cmake_policy(SET CMP0011 NEW)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules/branding")

set(linux_sizes 16 16@2 24 24@2 32 32@2 48 48@2 64 64@2 128 128@2 256)

# SVG color replacements
set(svg_green "#27ab5f;#249a56;#34d07b;opacity=\".1\" fill=\"#fff\"")
set(svg_blue "#3992cb;#2b6fc5;#62a8d4;opacity=\".1\" fill=\"#fff\"")
set(svg_purple "#5547bd;#493ba1;#7871c5;opacity=\".05\" fill=\"#fff\"")

# Recolor SVGs
include(SvgRecolor)
svg_recolor(svg_green svg_purple "${CMAKE_SOURCE_DIR}/data/scalable/lmms.svg" lmms_recolored)
svg_recolor(svg_green svg_purple "${CMAKE_SOURCE_DIR}/data/scalable/project.svg" project_recolored)
svg_recolor(svg_green svg_purple "${CMAKE_SOURCE_DIR}/data/scalable/splash.svg" splash_recolored)

set(BRANDED_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/cpack/")
file(REMOVE_RECURSE "${BRANDED_OUTPUT}")

# Platform-specific steps
if(WIN32)
	set(THEMES_DIR data/themes)
	include(IcoConvert)
	# FIXME: These must be called before WINRC
    #ico_convert("${lmms_recolored}" "${BRANDED_OUTPUT}/lmms.ico")
    #ico_convert("${lmms_recolored}" "${BRANDED_OUTPUT}/project.ico")
elseif(APPLE)
	set(THEMES_DIR Contents/share/lmms/themes)
	include(IcnsConvert)
    icns_convert("${lmms_recolored}" "${BRANDED_OUTPUT}/Contents/Resources/lmms.icns")
    icns_convert("${project_recolored}" "${BRANDED_OUTPUT}/Contents/Resources/project.icns")
else()
	set(THEMES_DIR usr/share/lmms/themes)
	# AppImage icon
	svg_convert(64 "${lmms_recolored}" "${BRANDED_OUTPUT}/lmms.png")
	# /usr/share/icons
	svg_convert("${linux_sizes}" "${lmms_recolored}" "${BRANDED_OUTPUT}/usr/share/icons/hicolor/%size%x%size%@%mult%/%name%.png")
	svg_convert("${linux_sizes}" "${project_recolored}" "${BRANDED_OUTPUT}/usr/share/icons/hicolor/%size%x%size%@%mult%/%name%.png")
endif()

# Theme files
include(SvgConvert)
svg_convert(128 "${lmms_recolored}" "${BRANDED_OUTPUT}/${THEMES_DIR}/default/icon.png")
svg_convert(32 "${lmms_recolored}" "${BRANDED_OUTPUT}/${THEMES_DIR}/default/icon_small.png")
### FIXME: add width/height support to svg_convert for gimp
svg_convert(681 "${splash_recolored}" "${BRANDED_OUTPUT}/${THEMES_DIR}/default/splash.png")

# message(FATAL_ERROR "\n\n\n==== INTENTIONALLY INTERRUPTED ====\n\n\n")