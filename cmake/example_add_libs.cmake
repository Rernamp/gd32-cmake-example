add_subdirectory(${PROJECT_SOURCE_DIR}/Firmware Firmware)
add_subdirectory(${PROJECT_SOURCE_DIR}/Utilities Utilities)

target_include_directories(${EXEC_NAME}_CMSIS PRIVATE .)
target_include_directories(${EXEC_NAME}_standard_peripherals PRIVATE .)
target_include_directories(${EXEC_NAME}_gd32f450z_eval PRIVATE .)

target_link_libraries(${EXEC_NAME} ${EXEC_NAME}_CMSIS ${EXEC_NAME}_standard_peripherals ${EXEC_NAME}_gd32f450z_eval)

gcc_add_linker_script(${EXEC_NAME} PUBLIC ${PATH_TO_LD})
gcc_generate_bin_file(${EXEC_NAME})