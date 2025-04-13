cmake_minimum_required(VERSION 3.10)
project(GeminiChatbot)

set(CMAKE_CXX_STANDARD 17)

add_executable(GeminiChatbot main.cpp)

# Link with curl
find_package(CURL REQUIRED)
target_include_directories(GeminiChatbot PRIVATE ${CURL_INCLUDE_DIRS})
target_link_libraries(GeminiChatbot ${CURL_LIBRARIES})
