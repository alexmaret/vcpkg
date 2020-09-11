vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/kconfig
    REF v5.73.0
    SHA512 cf80d7c1db8d8b4372f011b9aefbed196a83721eeb8d3935a6903fea4cdfb57f07c01a8f70103ca5fb9f57b9865383dc77dd5214ec2bc53a0029090f2d005a6c
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS 
        -DBUILD_HTML_DOCS=OFF
        -DBUILD_MAN_DOCS=OFF
        -DBUILD_QTHELP_DOCS=OFF
        -DBUILD_TESTING=OFF
)

vcpkg_install_cmake()

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/${PORT})

if(VCPKG_TARGET_IS_WINDOWS OR VCPKG_TARGET_IS_UWP)
    file(RENAME ${CURRENT_PACKAGES_DIR}/bin/kconfig_compiler_kf5.exe ${CURRENT_PACKAGES_DIR}/tools/${PORT}/kconfig_compiler_kf5.exe)
    file(RENAME ${CURRENT_PACKAGES_DIR}/bin/kconf_update.exe ${CURRENT_PACKAGES_DIR}/tools/${PORT}/kconf_update.exe)
    file(REMOVE ${CURRENT_PACKAGES_DIR}/bin/kreadconfig5.exe)
    file(REMOVE ${CURRENT_PACKAGES_DIR}/bin/kwriteconfig5.exe)
    file (GLOB EXES ${CURRENT_PACKAGES_DIR}/debug/bin/*.exe)
    file(REMOVE ${EXES})
else()
    file(REMOVE ${CURRENT_PACKAGES_DIR}/bin/kreadconfig5)
    file(REMOVE ${CURRENT_PACKAGES_DIR}/bin/kwriteconfig5)
    file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/kreadconfig5)
    file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/kwriteconfig5)
endif()

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/KF5Config)

vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/${PORT})
file(APPEND ${CURRENT_PACKAGES_DIR}/tools/${PORT}/qt.conf "Data = ../../data")
vcpkg_copy_pdbs()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")	
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")	
endif()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin/data)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/bin/data)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/etc)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/etc)
file(INSTALL ${SOURCE_PATH}/COPYING.LIB DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
