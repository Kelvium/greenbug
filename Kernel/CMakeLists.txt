project(Kernel)

# includes
include(Kernel.cmake)

# options
# compiler options
list(APPEND KERNEL_COPT
        -m32
        -nostdinc
        -nostdinc++
        -nostdlib
        -ffreestanding
)
# linker options
list(APPEND KERNEL_LOPT
        -m32
        -T ${KERNEL_SOURCE_DIR}/linker.ld
        -nostdlib
)

# build
add_executable(Kernel ${KERNEL_SRC})
target_compile_options(Kernel PRIVATE ${KERNEL_COPT})
target_link_options(Kernel PRIVATE LINKER:${KERNEL_LOPT})
