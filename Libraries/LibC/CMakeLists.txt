project(LibC)

# includes
include(LibC.cmake)

# build
add_library(LibC STATIC ${LIBC_SRC})
target_include_directories(LibC PUBLIC ${CMAKE_SOURCE_DIR}/Libraries/LibC)
target_link_options(LibC PRIVATE LINKER:-melf_i386)
target_compile_options(LibC PRIVATE -m32)
set_target_properties(LibC PROPERTIES LINKER_LANGUAGE CXX)
