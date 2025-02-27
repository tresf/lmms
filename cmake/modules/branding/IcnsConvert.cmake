# Convert an SVG to Apple icns file
#
# Copyright (c) 2025, Tres Finocchiaro, <tres.finocchiaro@gmail.com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
function(icns_convert source_file destination_file)
	include(SvgConvert)

	if(CPACK_CURRENT_BINARY_DIR)
		# Support calling from CPACK
		set(working_directory "${CPACK_CURRENT_BINARY_DIR}")
	else()
		set(working_directory "${CMAKE_CURRENT_BINARY_DIR}")
	endif()

	if(DEFINED ENV{WANT_DEBUG_BRANDING})
		set(WANT_DEBUG_BRANDING ON)
	endif()
	if(WANT_DEBUG_BRANDING)
		set(COMMAND_ECHO STDOUT)
	else()
		set(COMMAND_ECHO NONE)
	endif()

	# First, create icons at the standard resolutions
	get_filename_component(name "${source_file}" NAME_WLE)
	file(REMOVE_RECURSE "${working_directory}/${name}.iconset")
	file(REMOVE "${destination_file}")

	set(sizes 16 16@2 32 32@2 64 64@2 128 128@2 256 256@2 512 512@2)
	svg_convert("${sizes}" "${source_file}" "${working_directory}/%name%.iconset/icon_%size%x%size%@%mult%x.png")

	# Create the icns file
	get_filename_component(destination_dir "${destination_file}" DIRECTORY)
	file(MAKE_DIRECTORY "${destination_dir}")
	execute_process(COMMAND iconutil
		--convert icns
		"${working_directory}/${name}.iconset"
		--output "${destination_file}"
		WORKING_DIRECTORY "${working_directory}"
		OUTPUT_QUIET
		COMMAND_ECHO ${COMMAND_ECHO}
		COMMAND_ERROR_IS_FATAL ANY)

	message(STATUS " icns_convert: ${source_file} --> ${destination_file}")
endfunction()