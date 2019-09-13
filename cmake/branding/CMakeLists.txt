CONFIGURE_FILE("recolor_graphics.sh.in" "recolor_graphics.sh" @ONLY)
FILE(COPY svg/ DESTINATION svg/)
# FIXME, this runs each time cmake is called and it's a tad slow
FIND_PACKAGE(ImageMagick COMPONENTS convert)
# Prefer commandline over PKG_CHECK_MODULES per https://apple.stackexchange.com/q/169601/147537
EXECUTE_PROCESS(COMMAND rsvg-convert --version ERROR_QUIET OUTPUT_VARIABLE RSVG_FOUND)
IF (ImageMagick_FOUND AND RSVG_FOUND)
    EXECUTE_PROCESS(COMMAND "${CMAKE_CURRENT_BINARY_DIR}/recolor_graphics.sh")
ELSE()
    MESSAGE(WARNING "Tools \"convert\" and/or \"rsvg-convert\" are missing.  Releases will use the default branding instead.")
ENDIF()
INSTALL_DATA_SUBDIRS("themes" "splash.png")