CONFIGURE_FILE("recolor_graphics.sh.in" "recolor_graphics.sh" @ONLY)
FILE(COPY svg/ DESTINATION svg/)
# FIXME, this runs each time cmake is called and it's a tad slow
EXECUTE_PROCESS(COMMAND "${CMAKE_CURRENT_BINARY_DIR}/recolor_graphics.sh")
INSTALL_DATA_SUBDIRS("themes" "splash.png")