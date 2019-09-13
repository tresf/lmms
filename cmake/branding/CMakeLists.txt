CONFIGURE_FILE("recolor_graphics.sh.in" "recolor_graphics.sh" @ONLY)
FILE(COPY svg/ DESTINATION svg/)
INSTALL_DATA_SUBDIRS("themes" "splash.png")