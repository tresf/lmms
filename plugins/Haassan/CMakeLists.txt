INCLUDE(BuildPlugin)

BUILD_PLUGIN(Haassan HaassanEffect.cpp HaassanControls.cpp HaassanControlsDialog.cpp ../flanger/monodelay.cpp MOCFILES HaassanControls.h EMBEDDED_RESOURCES "${CMAKE_CURRENT_SOURCE_DIR}/*.png")
