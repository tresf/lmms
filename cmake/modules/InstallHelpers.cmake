#
# install all files matching certain wildcards below ${LMMS_DATA_DIR}/<subdir>
#
# example:
#
#   INSTALL_DATA_SUBDIRS("samples" "*.ogg;*.wav;*.flac")
#
# Copyright (c) 2008 Tobias Doerffel
#


# helper-macro
MACRO(LIST_CONTAINS var value)
	SET(${var})
		FOREACH(value2 ${ARGN})
			IF (${value} STREQUAL ${value2})
				SET(${var} TRUE)
			ENDIF()
	ENDFOREACH()
ENDMACRO()


MACRO(INSTALL_DATA_SUBDIRS _subdir _wildcards)
	FOREACH(_wildcard ${_wildcards})
		# Handle absolute _wildcard paths
		SET(IS_ABSOLUTE False)
		STRING(FIND "${_wildcard}" "${CMAKE_CURRENT_BINARY_DIR}" IS_BINARY_DIR)
		STRING(FIND "${_wildcard}" "${CMAKE_CURRENT_SOURCE_DIR}" IS_SOURCE_DIR)
		IF(IS_BINARY_DIR GREATER -1 OR IS_SOURCE_DIR GREATER -1)
			SET(IS_ABSOLUTE True)
		ENDIF()

		FILE(GLOB_RECURSE files ${_wildcard})
		LIST(SORT files)
		SET(SUBDIRS)
		FOREACH(_file ${files})
			GET_FILENAME_COMPONENT(_dir "${_file}" PATH)
			STRING(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" _dir "${_dir}")
			STRING(REPLACE "${CMAKE_CURRENT_BINARY_DIR}/" "" _dir "${_dir}")
			LIST_CONTAINS(contains _dir ${SUBDIRS})
			IF(NOT contains)
				LIST(APPEND SUBDIRS "${_dir}")
			ENDIF()
		ENDFOREACH()

		FOREACH(_dir ${SUBDIRS})
			IF(IS_ABSOLUTE)
				FILE(GLOB files "${_wildcard}")
			ELSE()
				FILE(GLOB files "${_dir}/${_wildcard}")
			ENDIF()

			LIST(SORT files)
			FOREACH(_file ${files})
				INSTALL(FILES "${_file}" DESTINATION "${LMMS_DATA_DIR}/${_subdir}/${_dir}/")
			ENDFOREACH()
		ENDFOREACH()
	ENDFOREACH()
ENDMACRO()

