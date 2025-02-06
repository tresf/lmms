# Recolor an SVG using search/replace techniques
#
# Copyright (c) 2025, Tres Finocchiaro, <tres.finocchiaro@gmail.com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
function(svg_recolor search_list replace_list source_file result)
	file(READ "${source_file}" svg_data)
	# set(var "${${var}}") will read and expand a quoted list by name
	set(search_list "${${search_list}}")
	set(replace_list "${${replace_list}}")
	list(LENGTH search_list length)
	math(EXPR length "${length}-1")
	foreach(i RANGE ${length})
		list(GET search_list ${i} search)
		list(GET replace_list ${i} replace)
		if(WANT_DEBUG_BRANDING OR DEFINED ENV{WANT_DEBUG_BRANDING})
			message(" svg_recolor ${i}: ${search} --> ${replace}")
		endif()
		string(REPLACE "${search}" "${replace}" svg_data "${svg_data}")
	endforeach()

	get_filename_component(source_file_name "${source_file}" NAME)
	if(CPACK_CURRENT_BINARY_DIR)
		# Support calling from CPACK
		set(working_directory "${CPACK_CURRENT_BINARY_DIR}")
	else()
		set(working_directory "${CMAKE_CURRENT_BINARY_DIR}")
	endif()
	set(destination_file "${working_directory}/${source_file_name}")

	file(WRITE "${destination_file}" "${svg_data}")
	message(STATUS " svg_recolor: ${source_file} --> ${destination_file}")
	set(${result} "${destination_file}" PARENT_SCOPE)
endfunction()