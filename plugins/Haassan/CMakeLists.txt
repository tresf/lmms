INCLUDE(BuildPlugin)

BUILD_PLUGIN(haassan HaassanEffect.cpp HaassanControls.cpp HaassanControlsDialog.cpp ../Flanger/MonoDelay.cpp MOCFILES HaassanControls.h EMBEDDED_RESOURCES "${CMAKE_CURRENT_SOURCE_DIR}/*.png")
