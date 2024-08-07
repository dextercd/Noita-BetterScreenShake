cmake_minimum_required(VERSION 3.24)

project(BetterScreenShake
    VERSION 0.1.0
    DESCRIPTION "Improve Noita's screenshake"
    HOMEPAGE_URL "https://github.com/dextercd/Noita-BetterScreenShake"
    LANGUAGES CXX
)

install(DIRECTORY BetterScreenShake
    DESTINATION .
    COMPONENT BetterScreenShake
)

# Packaging

set(CPACK_VERBATIM_VARIABLES TRUE)
set(CPACK_GENERATOR ZIP)
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY FALSE)
set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")
include(CPack)
