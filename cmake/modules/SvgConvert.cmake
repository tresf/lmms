# Convert an SVG to png at the sizes specified by size_list
#
# Copyright (c) 2025, Tres Finocchiaro, <tres.finocchiaro@gmail.com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
function(svg_convert size_list source_file output_pattern)
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

	foreach(size ${size_list})
		if(NOT EXISTS "${source_file}")
			message(FATAL_ERROR "SVG file does not exist: ${source_file}")
		endif()
		#find_best_tool()
		rsvg_convert("${source_file}" ${size} "${working_directory}" "${output_pattern}" ${COMMAND_ECHO} png_rendered)
		#inkscape_convert("${source_file}" ${size} "${working_directory}" "${output_pattern}" ${COMMAND_ECHO} png_rendered)
		message(STATUS " svg_convert: ${source_file} --> ${png_rendered}")
	endforeach()
endfunction()

# Inkscape is pretty slow, but it works
function(inkscape_convert source_file size working_directory pattern command_echo result)
	patternize_file("${source_file}" ${size} "${pattern}" scaled_size png_out)

	# Inkscape prefers units as 90-dpi
	execute_process(COMMAND inkscape "${source_file}"
		--batch-process
		--export-dpi=72
		--export-type=png
		--export-width=${scaled_size}
		"--export-filename=${png_out}"
		WORKING_DIRECTORY "${working_directory}"
		OUTPUT_QUIET
		ERROR_QUIET
		COMMAND_ECHO ${command_echo}
		COMMAND_ERROR_IS_FATAL ANY
		ERROR_VARIABLE inkscape_output)

		# Inkscpae doesn't properly return error codes, parse output instead
		if("${inkscape_output}" MATCHES "(Failed|failed|error)")
			message(FATAL_ERROR "${inkscape_output}")
		endif()

		set(${result} "${png_out}" PARENT_SCOPE)
endfunction()

# RSVG is much faster than inkscape
function(rsvg_convert source_file size working_directory pattern command_echo result)
	patternize_file("${source_file}" ${size} "${pattern}" scaled_size png_out)

	execute_process(COMMAND rsvg-convert
		"${source_file}"
		-w "${scaled_size}"
		-o "${png_out}"
		WORKING_DIRECTORY "${working_directory}"
		COMMAND_ECHO ${command_echo}
		COMMAND_ERROR_IS_FATAL ANY)

		set(${result} "${png_out}" PARENT_SCOPE)
endfunction()

# FIXME:
# 1. rsvg_convert is fastest
# 2. inkscape is slow but works well
# 3. gimp?
function(find_best_tool)
	if(ImageMagick_FOUND AND RSVG_FOUND)
		# good
	else()
		find_package(ImageMagick COMPONENTS convert)
		# Prefer EXECUTE_PROCESS over PKG_CHECK_MODULES per https://apple.stackexchange.com/q/169601/147537
		execute_process(COMMAND rsvg-convert --version ERROR_QUIET OUTPUT_VARIABLE RSVG_FOUND)
	endif()
endfunction()

# Patternize a filename so we can write it to well-known locations
#
# Example:
#   patternize_file(background.svg 64@2 "%name%@%mult%x.png" size file)
#
#   source_file:
#     background.svg, lmms.svg, etc
#
#   size:
#     32, 64, 64@2, etc
#
#   pattern:
# 	  background@2x.png = %name%@%mult%x.png
# 	  icons/16x16@2/apps/lmms.png = icons/%size%x%size%@%mult%.png
#
#   result_size, result_file: output variables
#
# There is no handling for escaping %'s
function(patternize_file source_file size pattern result_size result_file)
	# Calculate 'multiplier' 'unscaled_size' 'scaled_size' from provided size (e.g. '128' or '128@2')
	if(size MATCHES "@")
		string(REPLACE "@" ";" parts "${size}")
		list(GET parts 0 unscaled_size)
		list(GET parts 1 multiplier)
		math(EXPR scaled_size "${unscaled_size}*${multiplier}")
	else()
		set(unscaled_size "${size}")
		set(multiplier 1)
		set(scaled_size "${size}")
	endif()

	# Handle %mult%
	if(multiplier EQUAL 1)
		# Assume no one wants "@1" or "@2x" in a filename
		string(REPLACE "@%mult%x." "." result_file_name "${pattern}")
		string(REPLACE "@%mult%" "" result_file_name "${result_file_name}")
	else()
		# Special handling for apple's "@2x" notation
		string(REPLACE "@%mult%x." "@${multiplier}x." result_file_name "${pattern}")
		string(REPLACE "%mult%" "${multiplier}" result_file_name "${pattern}")
	endif()

	# Handle %size%
	string(REPLACE "%size%" "${unscaled_size}" result_file_name "${result_file_name}")

	# Handle %name%
	get_filename_component(name "${source_file}" NAME_WLE)
	string(REPLACE "%name%" "${name}" result_file_name "${result_file_name}")

	# Ensure parent directory exists
	get_filename_component(parent_dir "${result_file_name}" DIRECTORY)
	if(NOT EXISTS "${parent_dir}")
		file(MAKE_DIRECTORY "${parent_dir}")
	endif()

	set(${result_size} "${scaled_size}" PARENT_SCOPE)
	set(${result_file} "${result_file_name}" PARENT_SCOPE)
endfunction()