# GRPC global cmake file
# This currently builds C and C++ code.
# This file has been automatically generated from a template file.
# Please look at the templates directory instead.
# This file can be regenerated from the template by running
# tools/buildgen/generate_projects.sh
#
# Copyright 2015 gRPC authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.




cmake_minimum_required(VERSION 3.5.1)

set(PACKAGE_NAME          "grpc")
set(PACKAGE_VERSION       "1.32.0")
set(gRPC_CORE_VERSION     "12.0.0")
set(gRPC_CORE_SOVERSION   "12")
set(gRPC_CPP_VERSION      "1.32.0")
set(gRPC_CPP_SOVERSION    "1")
set(gRPC_CSHARP_VERSION   "2.32.0")
set(gRPC_CSHARP_SOVERSION "2")
set(PACKAGE_STRING        "${PACKAGE_NAME} ${PACKAGE_VERSION}")
set(PACKAGE_TARNAME       "${PACKAGE_NAME}-${PACKAGE_VERSION}")
set(PACKAGE_BUGREPORT     "https://github.com/grpc/grpc/issues/")
project(${PACKAGE_NAME} LANGUAGES C CXX)

set(gRPC_INSTALL_BINDIR "bin" CACHE STRING "Installation directory for executables")
set(gRPC_INSTALL_LIBDIR "lib" CACHE STRING "Installation directory for libraries")
set(gRPC_INSTALL_INCLUDEDIR "include" CACHE STRING "Installation directory for headers")
set(gRPC_INSTALL_CMAKEDIR "lib/cmake/${PACKAGE_NAME}" CACHE STRING "Installation directory for cmake config files")
set(gRPC_INSTALL_SHAREDIR "share/grpc" CACHE STRING "Installation directory for root certificates")

# Options
option(gRPC_BUILD_TESTS "Build tests" OFF)
option(gRPC_BUILD_CODEGEN "Build codegen" ON)
option(gRPC_BUILD_CSHARP_EXT "Build C# extensions" OFF)
option(gRPC_BACKWARDS_COMPATIBILITY_MODE "Build libraries that are binary compatible across a larger number of OS and libc versions" OFF)

set(gRPC_INSTALL_default ON)
if(NOT CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  # Disable gRPC_INSTALL by default if building as a submodule
  set(gRPC_INSTALL_default OFF)
endif()
set(gRPC_INSTALL ${gRPC_INSTALL_default} CACHE BOOL
    "Generate installation target")

# We can install dependencies from submodules if we're running
# CMake v3.13 or newer.
if(CMAKE_VERSION VERSION_LESS 3.13)
  set(_gRPC_INSTALL_SUPPORTED_FROM_MODULE OFF)
else()
  set(_gRPC_INSTALL_SUPPORTED_FROM_MODULE ON)
endif()

# Providers for third-party dependencies (gRPC_*_PROVIDER properties):
# "module": build the dependency using sources from git submodule (under third_party)
# "package": use cmake's find_package functionality to locate a pre-installed dependency

set(gRPC_ZLIB_PROVIDER "module" CACHE STRING "Provider of zlib library")
set_property(CACHE gRPC_ZLIB_PROVIDER PROPERTY STRINGS "module" "package")

set(gRPC_CARES_PROVIDER "module" CACHE STRING "Provider of c-ares library")
set_property(CACHE gRPC_CARES_PROVIDER PROPERTY STRINGS "module" "package")

set(gRPC_RE2_PROVIDER "module" CACHE STRING "Provider of re2 library")
set_property(CACHE gRPC_RE2_PROVIDER PROPERTY STRINGS "module" "package")

set(gRPC_PROTOBUF_PROVIDER "module" CACHE STRING "Provider of protobuf library")
set_property(CACHE gRPC_PROTOBUF_PROVIDER PROPERTY STRINGS "module" "package")

set(gRPC_PROTOBUF_PACKAGE_TYPE "" CACHE STRING "Algorithm for searching protobuf package")
set_property(CACHE gRPC_PROTOBUF_PACKAGE_TYPE PROPERTY STRINGS "CONFIG" "MODULE")

set(gRPC_ABSL_PROVIDER "module" CACHE STRING "Provider of absl library")
set_property(CACHE gRPC_ABSL_PROVIDER PROPERTY STRINGS "module" "package")

set(gRPC_ABSL_USED_TARGETS
  absl_algorithm
  absl_algorithm_container
  absl_atomic_hook
  absl_bad_optional_access
  absl_bad_variant_access
  absl_base
  absl_base_internal
  absl_bits
  absl_city
  absl_civil_time
  absl_compressed_tuple
  absl_config
  absl_container_common
  absl_container_memory
  absl_cord
  absl_core_headers
  absl_debugging_internal
  absl_demangle_internal
  absl_dynamic_annotations
  absl_endian
  absl_errno_saver
  absl_exponential_biased
  absl_fixed_array
  absl_flat_hash_set
  absl_function_ref
  absl_graphcycles_internal
  absl_hash
  absl_hash_function_defaults
  absl_hash_policy_traits
  absl_hashtable_debug_hooks
  absl_hashtablez_sampler
  absl_have_sse
  absl_inlined_vector
  absl_inlined_vector_internal
  absl_int128
  absl_kernel_timeout_internal
  absl_layout
  absl_log_severity
  absl_malloc_internal
  absl_memory
  absl_optional
  absl_raw_hash_set
  absl_raw_logging_internal
  absl_span
  absl_spinlock_wait
  absl_stacktrace
  absl_status
  absl_str_format
  absl_str_format_internal
  absl_strings
  absl_strings_internal
  absl_symbolize
  absl_synchronization
  absl_throw_delegate
  absl_time
  absl_time_zone
  absl_type_traits
  absl_utility
  absl_variant
  absl_meta
)

set(gRPC_USE_PROTO_LITE ON CACHE BOOL "Use the protobuf-lite library")

if(UNIX)
  if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(_gRPC_PLATFORM_LINUX ON)
  else()
    set(_gRPC_PLATFORM_POSIX ON)
  endif()
endif()

 # Use C99 standard
if (NOT DEFINED CMAKE_C_STANDARD)
  set(CMAKE_C_STANDARD 99)
endif()

# Add c++11 flags
if (NOT DEFINED CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 11)
else()
  if (CMAKE_CXX_STANDARD LESS 11)
    message(FATAL_ERROR "CMAKE_CXX_STANDARD is less than 11, please specify at least SET(CMAKE_CXX_STANDARD 11)")
  endif()
endif()
if (NOT DEFINED CMAKE_CXX_STANDARD_REQUIRED)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)
endif()
if (NOT DEFINED CMAKE_CXX_EXTENSIONS)
  set(CMAKE_CXX_EXTENSIONS OFF)
endif()

if (NOT DEFINED CMAKE_POSITION_INDEPENDENT_CODE)
  set(CMAKE_POSITION_INDEPENDENT_CODE TRUE)
endif()
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${_gRPC_C_CXX_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${_gRPC_C_CXX_FLAGS}")

if(gRPC_USE_PROTO_LITE)
  set(_gRPC_PROTOBUF_LIBRARY_NAME "libprotobuf-lite")
  add_definitions("-DGRPC_USE_PROTO_LITE")
else()
  set(_gRPC_PROTOBUF_LIBRARY_NAME "libprotobuf")
endif()

if(gRPC_BACKWARDS_COMPATIBILITY_MODE)
  add_definitions(-DGPR_BACKWARDS_COMPATIBILITY_MODE)
  if(_gRPC_PLATFORM_MAC)
    # some C++11 constructs not supported before OS X 10.9
    set(CMAKE_OSX_DEPLOYMENT_TARGET 10.9)
  endif()
endif()

if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC)
  set(_gRPC_CORE_NOSTDCXX_FLAGS -fno-exceptions -fno-rtti)
else()
  set(_gRPC_CORE_NOSTDCXX_FLAGS "")
endif()

include(cmake/abseil-cpp.cmake)
include(cmake/address_sorting.cmake)
include(cmake/benchmark.cmake)
include(cmake/cares.cmake)
include(cmake/gflags.cmake)
include(cmake/protobuf.cmake)
include(cmake/re2.cmake)
#include(cmake/ssl.cmake)
include(cmake/upb.cmake)
include(cmake/zlib.cmake)

# Create directory for generated .proto files
set(_gRPC_PROTO_GENS_DIR ${CMAKE_BINARY_DIR}/gens)
file(MAKE_DIRECTORY ${_gRPC_PROTO_GENS_DIR})

#  protobuf_generate_grpc_cpp
#  --------------------------
#
#   Add custom commands to process ``.proto`` files to C++ using protoc and
#   GRPC plugin::
#
#     protobuf_generate_grpc_cpp [<ARGN>...]
#
#   ``ARGN``
#     ``.proto`` files
#
function(protobuf_generate_grpc_cpp)
  if(NOT ARGN)
    message(SEND_ERROR "Error: PROTOBUF_GENERATE_GRPC_CPP() called without any proto files")
    return()
  endif()

  set(_protobuf_include_path -I . -I ${_gRPC_PROTOBUF_WELLKNOWN_INCLUDE_DIR})
  foreach(FIL ${ARGN})
    get_filename_component(ABS_FIL ${FIL} ABSOLUTE)
    get_filename_component(FIL_WE ${FIL} NAME_WE)
    file(RELATIVE_PATH REL_FIL ${CMAKE_CURRENT_SOURCE_DIR} ${ABS_FIL})
    get_filename_component(REL_DIR ${REL_FIL} DIRECTORY)
    set(RELFIL_WE "${REL_DIR}/${FIL_WE}")

    #if cross-compiling, find host plugin
    if(CMAKE_CROSSCOMPILING)
      find_program(_gRPC_CPP_PLUGIN grpc_cpp_plugin)
    else()
      set(_gRPC_CPP_PLUGIN $<TARGET_FILE:grpc_cpp_plugin>)
    endif()

    add_custom_command(
      OUTPUT "${_gRPC_PROTO_GENS_DIR}/${RELFIL_WE}.grpc.pb.cc"
             "${_gRPC_PROTO_GENS_DIR}/${RELFIL_WE}.grpc.pb.h"
             "${_gRPC_PROTO_GENS_DIR}/${RELFIL_WE}_mock.grpc.pb.h"
             "${_gRPC_PROTO_GENS_DIR}/${RELFIL_WE}.pb.cc"
             "${_gRPC_PROTO_GENS_DIR}/${RELFIL_WE}.pb.h"
      COMMAND ${_gRPC_PROTOBUF_PROTOC_EXECUTABLE}
      ARGS --grpc_out=generate_mock_code=true:${_gRPC_PROTO_GENS_DIR}
           --cpp_out=${_gRPC_PROTO_GENS_DIR}
           --plugin=protoc-gen-grpc=${_gRPC_CPP_PLUGIN}
           ${_protobuf_include_path}
           ${REL_FIL}
      DEPENDS ${ABS_FIL} ${_gRPC_PROTOBUF_PROTOC} grpc_cpp_plugin
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      COMMENT "Running gRPC C++ protocol buffer compiler on ${FIL}"
      VERBATIM)
  endforeach()
endfunction()

# These options allow users to enable or disable the building of the various
# protoc plugins. For example, running CMake with
# -DgRPC_BUILD_GRPC_CSHARP_PLUGIN=OFF will disable building the C# plugin.
set(_gRPC_PLUGIN_LIST)
option(gRPC_BUILD_GRPC_CPP_PLUGIN "Build grpc_cpp_plugin" ON)
if (gRPC_BUILD_GRPC_CPP_PLUGIN)
  list(APPEND _gRPC_PLUGIN_LIST grpc_cpp_plugin)
endif ()

add_custom_target(plugins
  DEPENDS ${_gRPC_PLUGIN_LIST}
)

add_custom_target(tools_c
  DEPENDS
  check_epollexclusive
)

add_custom_target(tools_cxx
  DEPENDS
  gen_hpack_tables
  gen_legal_metadata_characters
  gen_percent_encoding_tables
)

add_custom_target(tools
  DEPENDS tools_c tools_cxx)

protobuf_generate_grpc_cpp(
  src/proto/grpc/channelz/channelz.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/core/stats.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/health/v1/health.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/lb/v1/load_balancer.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/reflection/v1alpha/reflection.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/status/status.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/benchmark_service.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/control.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/duplicate/echo_duplicate.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/echo.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/echo_messages.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/empty.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/messages.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/payloads.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/report_qps_scenario_service.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/simple_messages.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/stats.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/test.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/worker_service.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/ads_for_test.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/cds_for_test.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/eds_for_test.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/lds_rds_for_test.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/lrs_for_test.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/orca_load_report_for_test.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/v3/address.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/v3/ads.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/v3/base.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/v3/cluster.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/v3/config_source.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/v3/discovery.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/v3/endpoint.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/v3/http_connection_manager.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/v3/listener.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/v3/load_report.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/v3/lrs.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/v3/percent.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/v3/range.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/v3/regex.proto
)
protobuf_generate_grpc_cpp(
  src/proto/grpc/testing/xds/v3/route.proto
)
protobuf_generate_grpc_cpp(
  test/core/tsi/alts/fake_handshaker/handshaker.proto
)
protobuf_generate_grpc_cpp(
  test/core/tsi/alts/fake_handshaker/transport_security_common.proto
)

add_library(address_sorting
  third_party/address_sorting/address_sorting.c
  third_party/address_sorting/address_sorting_posix.c
  third_party/address_sorting/address_sorting_windows.c
)

set_target_properties(address_sorting PROPERTIES
  VERSION ${gRPC_CORE_VERSION}
  SOVERSION ${gRPC_CORE_SOVERSION}
)

target_include_directories(address_sorting
  PUBLIC $<INSTALL_INTERFACE:${gRPC_INSTALL_INCLUDEDIR}> $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(address_sorting
  ${_gRPC_BASELIB_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
)



if(gRPC_INSTALL)
  install(TARGETS address_sorting EXPORT gRPCTargets
    RUNTIME DESTINATION ${gRPC_INSTALL_BINDIR}
    LIBRARY DESTINATION ${gRPC_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${gRPC_INSTALL_LIBDIR}
  )
endif()

add_library(gpr
  src/core/lib/gpr/alloc.cc
  src/core/lib/gpr/atm.cc
  src/core/lib/gpr/cpu_iphone.cc
  src/core/lib/gpr/cpu_linux.cc
  src/core/lib/gpr/cpu_posix.cc
  src/core/lib/gpr/cpu_windows.cc
  src/core/lib/gpr/env_linux.cc
  src/core/lib/gpr/env_posix.cc
  src/core/lib/gpr/env_windows.cc
  src/core/lib/gpr/log.cc
  src/core/lib/gpr/log_android.cc
  src/core/lib/gpr/log_linux.cc
  src/core/lib/gpr/log_posix.cc
  src/core/lib/gpr/log_windows.cc
  src/core/lib/gpr/murmur_hash.cc
  src/core/lib/gpr/string.cc
  src/core/lib/gpr/string_posix.cc
  src/core/lib/gpr/string_util_windows.cc
  src/core/lib/gpr/string_windows.cc
  src/core/lib/gpr/sync.cc
  src/core/lib/gpr/sync_abseil.cc
  src/core/lib/gpr/sync_posix.cc
  src/core/lib/gpr/sync_windows.cc
  src/core/lib/gpr/time.cc
  src/core/lib/gpr/time_posix.cc
  src/core/lib/gpr/time_precise.cc
  src/core/lib/gpr/time_windows.cc
  src/core/lib/gpr/tls_pthread.cc
  src/core/lib/gpr/tmpfile_msys.cc
  src/core/lib/gpr/tmpfile_posix.cc
  src/core/lib/gpr/tmpfile_windows.cc
  src/core/lib/gpr/wrap_memcpy.cc
  src/core/lib/gprpp/arena.cc
  src/core/lib/gprpp/fork.cc
  src/core/lib/gprpp/global_config_env.cc
  src/core/lib/gprpp/host_port.cc
  src/core/lib/gprpp/mpscq.cc
  src/core/lib/gprpp/thd_posix.cc
  src/core/lib/gprpp/thd_windows.cc
  src/core/lib/profiling/basic_timers.cc
  src/core/lib/profiling/stap_timers.cc
)

set_target_properties(gpr PROPERTIES
  VERSION ${gRPC_CORE_VERSION}
  SOVERSION ${gRPC_CORE_SOVERSION}
)

target_include_directories(gpr
  PUBLIC $<INSTALL_INTERFACE:${gRPC_INSTALL_INCLUDEDIR}> $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(gpr
  ${_gRPC_ALLTARGETS_LIBRARIES}
  absl::time
  absl::synchronization
  absl::strings
  absl::str_format
  absl::memory
  absl::base
)

foreach(_hdr
  include/grpc/impl/codegen/atm.h
  include/grpc/impl/codegen/atm_gcc_atomic.h
  include/grpc/impl/codegen/atm_gcc_sync.h
  include/grpc/impl/codegen/atm_windows.h
  include/grpc/impl/codegen/byte_buffer.h
  include/grpc/impl/codegen/byte_buffer_reader.h
  include/grpc/impl/codegen/compression_types.h
  include/grpc/impl/codegen/connectivity_state.h
  include/grpc/impl/codegen/fork.h
  include/grpc/impl/codegen/gpr_slice.h
  include/grpc/impl/codegen/gpr_types.h
  include/grpc/impl/codegen/grpc_types.h
  include/grpc/impl/codegen/log.h
  include/grpc/impl/codegen/port_platform.h
  include/grpc/impl/codegen/propagation_bits.h
  include/grpc/impl/codegen/slice.h
  include/grpc/impl/codegen/status.h
  include/grpc/impl/codegen/sync.h
  include/grpc/impl/codegen/sync_abseil.h
  include/grpc/impl/codegen/sync_custom.h
  include/grpc/impl/codegen/sync_generic.h
  include/grpc/impl/codegen/sync_posix.h
  include/grpc/impl/codegen/sync_windows.h
  include/grpc/support/alloc.h
  include/grpc/support/atm.h
  include/grpc/support/atm_gcc_atomic.h
  include/grpc/support/atm_gcc_sync.h
  include/grpc/support/atm_windows.h
  include/grpc/support/cpu.h
  include/grpc/support/log.h
  include/grpc/support/log_windows.h
  include/grpc/support/port_platform.h
  include/grpc/support/string_util.h
  include/grpc/support/sync.h
  include/grpc/support/sync_abseil.h
  include/grpc/support/sync_custom.h
  include/grpc/support/sync_generic.h
  include/grpc/support/sync_posix.h
  include/grpc/support/sync_windows.h
  include/grpc/support/thd_id.h
  include/grpc/support/time.h
)
  string(REPLACE "include/" "" _path ${_hdr})
  get_filename_component(_path ${_path} PATH)
  install(FILES ${_hdr}
    DESTINATION "${gRPC_INSTALL_INCLUDEDIR}/${_path}"
  )
endforeach()


if(gRPC_INSTALL)
  install(TARGETS gpr EXPORT gRPCTargets
    RUNTIME DESTINATION ${gRPC_INSTALL_BINDIR}
    LIBRARY DESTINATION ${gRPC_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${gRPC_INSTALL_LIBDIR}
  )
endif()

if(gRPC_BUILD_CSHARP_EXT)

add_library(grpc_csharp_ext SHARED
  src/csharp/ext/grpc_csharp_ext.c
)

set_target_properties(grpc_csharp_ext PROPERTIES
  VERSION ${gRPC_CORE_VERSION}
  SOVERSION ${gRPC_CORE_SOVERSION}
)

target_include_directories(grpc_csharp_ext
  PUBLIC $<INSTALL_INTERFACE:${gRPC_INSTALL_INCLUDEDIR}> $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(grpc_csharp_ext
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc
  gpr
  address_sorting
  upb
)


endif()



add_library(grpc_unsecure
  src/core/ext/filters/census/grpc_context.cc
  src/core/ext/filters/client_channel/backend_metric.cc
  src/core/ext/filters/client_channel/backup_poller.cc
  src/core/ext/filters/client_channel/channel_connectivity.cc
  src/core/ext/filters/client_channel/client_channel.cc
  src/core/ext/filters/client_channel/client_channel_channelz.cc
  src/core/ext/filters/client_channel/client_channel_factory.cc
  src/core/ext/filters/client_channel/client_channel_plugin.cc
  src/core/ext/filters/client_channel/config_selector.cc
  src/core/ext/filters/client_channel/global_subchannel_pool.cc
  src/core/ext/filters/client_channel/health/health_check_client.cc
  src/core/ext/filters/client_channel/http_connect_handshaker.cc
  src/core/ext/filters/client_channel/http_proxy.cc
  src/core/ext/filters/client_channel/lb_policy.cc
  src/core/ext/filters/client_channel/lb_policy/address_filtering.cc
  src/core/ext/filters/client_channel/lb_policy/child_policy_handler.cc
  src/core/ext/filters/client_channel/lb_policy/grpclb/client_load_reporting_filter.cc
  src/core/ext/filters/client_channel/lb_policy/grpclb/grpclb.cc
  src/core/ext/filters/client_channel/lb_policy/grpclb/grpclb_balancer_addresses.cc
  src/core/ext/filters/client_channel/lb_policy/grpclb/grpclb_channel.cc
  src/core/ext/filters/client_channel/lb_policy/grpclb/grpclb_client_stats.cc
  src/core/ext/filters/client_channel/lb_policy/grpclb/load_balancer_api.cc
  src/core/ext/filters/client_channel/lb_policy/pick_first/pick_first.cc
  src/core/ext/filters/client_channel/lb_policy/priority/priority.cc
  src/core/ext/filters/client_channel/lb_policy/round_robin/round_robin.cc
  src/core/ext/filters/client_channel/lb_policy/weighted_target/weighted_target.cc
  src/core/ext/filters/client_channel/lb_policy/xds/cds.cc
  src/core/ext/filters/client_channel/lb_policy/xds/eds.cc
  src/core/ext/filters/client_channel/lb_policy/xds/lrs.cc
  src/core/ext/filters/client_channel/lb_policy/xds/xds_routing.cc
  src/core/ext/filters/client_channel/lb_policy_registry.cc
  src/core/ext/filters/client_channel/local_subchannel_pool.cc
  src/core/ext/filters/client_channel/proxy_mapper_registry.cc
  src/core/ext/filters/client_channel/resolver.cc
  src/core/ext/filters/client_channel/resolver/dns/c_ares/dns_resolver_ares.cc
  src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_ev_driver.cc
  src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_ev_driver_libuv.cc
  src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_ev_driver_posix.cc
  src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_ev_driver_windows.cc
  src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_wrapper.cc
  src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_wrapper_fallback.cc
  src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_wrapper_libuv.cc
  src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_wrapper_posix.cc
  src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_wrapper_windows.cc
  src/core/ext/filters/client_channel/resolver/dns/dns_resolver_selection.cc
  src/core/ext/filters/client_channel/resolver/dns/native/dns_resolver.cc
  src/core/ext/filters/client_channel/resolver/fake/fake_resolver.cc
  src/core/ext/filters/client_channel/resolver/sockaddr/sockaddr_resolver.cc
  src/core/ext/filters/client_channel/resolver/xds/xds_resolver.cc
  src/core/ext/filters/client_channel/resolver_registry.cc
  src/core/ext/filters/client_channel/resolver_result_parsing.cc
  src/core/ext/filters/client_channel/resolving_lb_policy.cc
  src/core/ext/filters/client_channel/retry_throttle.cc
  src/core/ext/filters/client_channel/server_address.cc
  src/core/ext/filters/client_channel/service_config.cc
  src/core/ext/filters/client_channel/service_config_channel_arg_filter.cc
  src/core/ext/filters/client_channel/service_config_parser.cc
  src/core/ext/filters/client_channel/subchannel.cc
  src/core/ext/filters/client_channel/subchannel_pool_interface.cc
  src/core/ext/filters/client_idle/client_idle_filter.cc
  src/core/ext/filters/deadline/deadline_filter.cc
  src/core/ext/filters/http/client/http_client_filter.cc
  src/core/ext/filters/http/client_authority_filter.cc
  src/core/ext/filters/http/http_filters_plugin.cc
  src/core/ext/filters/http/message_compress/message_compress_filter.cc
  src/core/ext/filters/http/message_compress/message_decompress_filter.cc
  src/core/ext/filters/http/server/http_server_filter.cc
  src/core/ext/filters/max_age/max_age_filter.cc
  src/core/ext/filters/message_size/message_size_filter.cc
  src/core/ext/filters/workarounds/workaround_cronet_compression_filter.cc
  src/core/ext/filters/workarounds/workaround_utils.cc
  src/core/ext/transport/chttp2/alpn/alpn.cc
  src/core/ext/transport/chttp2/client/authority.cc
  src/core/ext/transport/chttp2/client/chttp2_connector.cc
  src/core/ext/transport/chttp2/client/insecure/channel_create.cc
  src/core/ext/transport/chttp2/client/insecure/channel_create_posix.cc
  src/core/ext/transport/chttp2/server/chttp2_server.cc
  src/core/ext/transport/chttp2/server/insecure/server_chttp2.cc
  src/core/ext/transport/chttp2/server/insecure/server_chttp2_posix.cc
  src/core/ext/transport/chttp2/transport/bin_decoder.cc
  src/core/ext/transport/chttp2/transport/bin_encoder.cc
  src/core/ext/transport/chttp2/transport/chttp2_plugin.cc
  src/core/ext/transport/chttp2/transport/chttp2_transport.cc
  src/core/ext/transport/chttp2/transport/context_list.cc
  src/core/ext/transport/chttp2/transport/flow_control.cc
  src/core/ext/transport/chttp2/transport/frame_data.cc
  src/core/ext/transport/chttp2/transport/frame_goaway.cc
  src/core/ext/transport/chttp2/transport/frame_ping.cc
  src/core/ext/transport/chttp2/transport/frame_rst_stream.cc
  src/core/ext/transport/chttp2/transport/frame_settings.cc
  src/core/ext/transport/chttp2/transport/frame_window_update.cc
  src/core/ext/transport/chttp2/transport/hpack_encoder.cc
  src/core/ext/transport/chttp2/transport/hpack_parser.cc
  src/core/ext/transport/chttp2/transport/hpack_table.cc
  src/core/ext/transport/chttp2/transport/http2_settings.cc
  src/core/ext/transport/chttp2/transport/huffsyms.cc
  src/core/ext/transport/chttp2/transport/incoming_metadata.cc
  src/core/ext/transport/chttp2/transport/parsing.cc
  src/core/ext/transport/chttp2/transport/stream_lists.cc
  src/core/ext/transport/chttp2/transport/stream_map.cc
  src/core/ext/transport/chttp2/transport/varint.cc
  src/core/ext/transport/chttp2/transport/writing.cc
  src/core/ext/transport/inproc/inproc_plugin.cc
  src/core/ext/transport/inproc/inproc_transport.cc
  src/core/ext/upb-generated/envoy/annotations/deprecation.upb.c
  src/core/ext/upb-generated/envoy/annotations/resource.upb.c
  src/core/ext/upb-generated/envoy/config/accesslog/v3/accesslog.upb.c
  src/core/ext/upb-generated/envoy/config/cluster/v3/circuit_breaker.upb.c
  src/core/ext/upb-generated/envoy/config/cluster/v3/cluster.upb.c
  src/core/ext/upb-generated/envoy/config/cluster/v3/filter.upb.c
  src/core/ext/upb-generated/envoy/config/cluster/v3/outlier_detection.upb.c
  src/core/ext/upb-generated/envoy/config/core/v3/address.upb.c
  src/core/ext/upb-generated/envoy/config/core/v3/backoff.upb.c
  src/core/ext/upb-generated/envoy/config/core/v3/base.upb.c
  src/core/ext/upb-generated/envoy/config/core/v3/config_source.upb.c
  src/core/ext/upb-generated/envoy/config/core/v3/event_service_config.upb.c
  src/core/ext/upb-generated/envoy/config/core/v3/grpc_service.upb.c
  src/core/ext/upb-generated/envoy/config/core/v3/health_check.upb.c
  src/core/ext/upb-generated/envoy/config/core/v3/http_uri.upb.c
  src/core/ext/upb-generated/envoy/config/core/v3/protocol.upb.c
  src/core/ext/upb-generated/envoy/config/core/v3/proxy_protocol.upb.c
  src/core/ext/upb-generated/envoy/config/core/v3/socket_option.upb.c
  src/core/ext/upb-generated/envoy/config/endpoint/v3/endpoint.upb.c
  src/core/ext/upb-generated/envoy/config/endpoint/v3/endpoint_components.upb.c
  src/core/ext/upb-generated/envoy/config/endpoint/v3/load_report.upb.c
  src/core/ext/upb-generated/envoy/config/listener/v3/api_listener.upb.c
  src/core/ext/upb-generated/envoy/config/listener/v3/listener.upb.c
  src/core/ext/upb-generated/envoy/config/listener/v3/listener_components.upb.c
  src/core/ext/upb-generated/envoy/config/listener/v3/udp_listener_config.upb.c
  src/core/ext/upb-generated/envoy/config/rbac/v3/rbac.upb.c
  src/core/ext/upb-generated/envoy/config/route/v3/route.upb.c
  src/core/ext/upb-generated/envoy/config/route/v3/route_components.upb.c
  src/core/ext/upb-generated/envoy/config/route/v3/scoped_route.upb.c
  src/core/ext/upb-generated/envoy/config/trace/v3/http_tracer.upb.c
  src/core/ext/upb-generated/envoy/extensions/filters/network/http_connection_manager/v3/http_connection_manager.upb.c
  src/core/ext/upb-generated/envoy/extensions/transport_sockets/tls/v3/cert.upb.c
  src/core/ext/upb-generated/envoy/extensions/transport_sockets/tls/v3/common.upb.c
  src/core/ext/upb-generated/envoy/extensions/transport_sockets/tls/v3/secret.upb.c
  src/core/ext/upb-generated/envoy/extensions/transport_sockets/tls/v3/tls.upb.c
  src/core/ext/upb-generated/envoy/service/cluster/v3/cds.upb.c
  src/core/ext/upb-generated/envoy/service/discovery/v3/ads.upb.c
  src/core/ext/upb-generated/envoy/service/discovery/v3/discovery.upb.c
  src/core/ext/upb-generated/envoy/service/endpoint/v3/eds.upb.c
  src/core/ext/upb-generated/envoy/service/listener/v3/lds.upb.c
  src/core/ext/upb-generated/envoy/service/load_stats/v3/lrs.upb.c
  src/core/ext/upb-generated/envoy/service/route/v3/rds.upb.c
  src/core/ext/upb-generated/envoy/service/route/v3/srds.upb.c
  src/core/ext/upb-generated/envoy/type/matcher/v3/metadata.upb.c
  src/core/ext/upb-generated/envoy/type/matcher/v3/number.upb.c
  src/core/ext/upb-generated/envoy/type/matcher/v3/path.upb.c
  src/core/ext/upb-generated/envoy/type/matcher/v3/regex.upb.c
  src/core/ext/upb-generated/envoy/type/matcher/v3/string.upb.c
  src/core/ext/upb-generated/envoy/type/matcher/v3/value.upb.c
  src/core/ext/upb-generated/envoy/type/metadata/v3/metadata.upb.c
  src/core/ext/upb-generated/envoy/type/tracing/v3/custom_tag.upb.c
  src/core/ext/upb-generated/envoy/type/v3/http.upb.c
  src/core/ext/upb-generated/envoy/type/v3/percent.upb.c
  src/core/ext/upb-generated/envoy/type/v3/range.upb.c
  src/core/ext/upb-generated/envoy/type/v3/semantic_version.upb.c
  src/core/ext/upb-generated/gogoproto/gogo.upb.c
  src/core/ext/upb-generated/google/api/annotations.upb.c
  src/core/ext/upb-generated/google/api/expr/v1alpha1/syntax.upb.c
  src/core/ext/upb-generated/google/api/http.upb.c
  src/core/ext/upb-generated/google/protobuf/any.upb.c
  src/core/ext/upb-generated/google/protobuf/descriptor.upb.c
  src/core/ext/upb-generated/google/protobuf/duration.upb.c
  src/core/ext/upb-generated/google/protobuf/empty.upb.c
  src/core/ext/upb-generated/google/protobuf/struct.upb.c
  src/core/ext/upb-generated/google/protobuf/timestamp.upb.c
  src/core/ext/upb-generated/google/protobuf/wrappers.upb.c
  src/core/ext/upb-generated/google/rpc/status.upb.c
  src/core/ext/upb-generated/src/proto/grpc/health/v1/health.upb.c
  src/core/ext/upb-generated/src/proto/grpc/lb/v1/load_balancer.upb.c
  src/core/ext/upb-generated/udpa/annotations/migrate.upb.c
  src/core/ext/upb-generated/udpa/annotations/sensitive.upb.c
  src/core/ext/upb-generated/udpa/annotations/status.upb.c
  src/core/ext/upb-generated/udpa/annotations/versioning.upb.c
  src/core/ext/upb-generated/udpa/data/orca/v1/orca_load_report.upb.c
  src/core/ext/upb-generated/validate/validate.upb.c
  src/core/ext/xds/xds_api.cc
  src/core/ext/xds/xds_bootstrap.cc
  src/core/ext/xds/xds_channel.cc
  src/core/ext/xds/xds_client.cc
  src/core/ext/xds/xds_client_stats.cc
  src/core/lib/avl/avl.cc
  src/core/lib/backoff/backoff.cc
  src/core/lib/channel/channel_args.cc
  src/core/lib/channel/channel_stack.cc
  src/core/lib/channel/channel_stack_builder.cc
  src/core/lib/channel/channel_trace.cc
  src/core/lib/channel/channelz.cc
  src/core/lib/channel/channelz_registry.cc
  src/core/lib/channel/connected_channel.cc
  src/core/lib/channel/handshaker.cc
  src/core/lib/channel/handshaker_registry.cc
  src/core/lib/channel/status_util.cc
  src/core/lib/compression/compression.cc
  src/core/lib/compression/compression_args.cc
  src/core/lib/compression/compression_internal.cc
  src/core/lib/compression/message_compress.cc
  src/core/lib/compression/stream_compression.cc
  src/core/lib/compression/stream_compression_gzip.cc
  src/core/lib/compression/stream_compression_identity.cc
  src/core/lib/debug/stats.cc
  src/core/lib/debug/stats_data.cc
  src/core/lib/debug/trace.cc
  src/core/lib/http/format_request.cc
  src/core/lib/http/httpcli.cc
  src/core/lib/http/parser.cc
  src/core/lib/iomgr/buffer_list.cc
  src/core/lib/iomgr/call_combiner.cc
  src/core/lib/iomgr/cfstream_handle.cc
  src/core/lib/iomgr/combiner.cc
  src/core/lib/iomgr/dualstack_socket_posix.cc
  src/core/lib/iomgr/endpoint.cc
  src/core/lib/iomgr/endpoint_cfstream.cc
  src/core/lib/iomgr/endpoint_pair_posix.cc
  src/core/lib/iomgr/endpoint_pair_uv.cc
  src/core/lib/iomgr/endpoint_pair_windows.cc
  src/core/lib/iomgr/error.cc
  src/core/lib/iomgr/error_cfstream.cc
  src/core/lib/iomgr/ev_apple.cc
  src/core/lib/iomgr/ev_epoll1_linux.cc
  src/core/lib/iomgr/ev_epollex_linux.cc
  src/core/lib/iomgr/ev_poll_posix.cc
  src/core/lib/iomgr/ev_posix.cc
  src/core/lib/iomgr/ev_windows.cc
  src/core/lib/iomgr/exec_ctx.cc
  src/core/lib/iomgr/executor.cc
  src/core/lib/iomgr/executor/mpmcqueue.cc
  src/core/lib/iomgr/executor/threadpool.cc
  src/core/lib/iomgr/fork_posix.cc
  src/core/lib/iomgr/fork_windows.cc
  src/core/lib/iomgr/gethostname_fallback.cc
  src/core/lib/iomgr/gethostname_host_name_max.cc
  src/core/lib/iomgr/gethostname_sysconf.cc
  src/core/lib/iomgr/grpc_if_nametoindex_posix.cc
  src/core/lib/iomgr/grpc_if_nametoindex_unsupported.cc
  src/core/lib/iomgr/internal_errqueue.cc
  src/core/lib/iomgr/iocp_windows.cc
  src/core/lib/iomgr/iomgr.cc
  src/core/lib/iomgr/iomgr_custom.cc
  src/core/lib/iomgr/iomgr_internal.cc
  src/core/lib/iomgr/iomgr_posix.cc
  src/core/lib/iomgr/iomgr_posix_cfstream.cc
  src/core/lib/iomgr/iomgr_uv.cc
  src/core/lib/iomgr/iomgr_windows.cc
  src/core/lib/iomgr/is_epollexclusive_available.cc
  src/core/lib/iomgr/load_file.cc
  src/core/lib/iomgr/lockfree_event.cc
  src/core/lib/iomgr/parse_address.cc
  src/core/lib/iomgr/poller/eventmanager_libuv.cc
  src/core/lib/iomgr/polling_entity.cc
  src/core/lib/iomgr/pollset.cc
  src/core/lib/iomgr/pollset_custom.cc
  src/core/lib/iomgr/pollset_set.cc
  src/core/lib/iomgr/pollset_set_custom.cc
  src/core/lib/iomgr/pollset_set_windows.cc
  src/core/lib/iomgr/pollset_uv.cc
  src/core/lib/iomgr/pollset_windows.cc
  src/core/lib/iomgr/resolve_address.cc
  src/core/lib/iomgr/resolve_address_custom.cc
  src/core/lib/iomgr/resolve_address_posix.cc
  src/core/lib/iomgr/resolve_address_windows.cc
  src/core/lib/iomgr/resource_quota.cc
  src/core/lib/iomgr/sockaddr_utils.cc
  src/core/lib/iomgr/socket_factory_posix.cc
  src/core/lib/iomgr/socket_mutator.cc
  src/core/lib/iomgr/socket_utils_common_posix.cc
  src/core/lib/iomgr/socket_utils_linux.cc
  src/core/lib/iomgr/socket_utils_posix.cc
  src/core/lib/iomgr/socket_utils_uv.cc
  src/core/lib/iomgr/socket_utils_windows.cc
  src/core/lib/iomgr/socket_windows.cc
  src/core/lib/iomgr/tcp_client.cc
  src/core/lib/iomgr/tcp_client_cfstream.cc
  src/core/lib/iomgr/tcp_client_custom.cc
  src/core/lib/iomgr/tcp_client_posix.cc
  src/core/lib/iomgr/tcp_client_windows.cc
  src/core/lib/iomgr/tcp_custom.cc
  src/core/lib/iomgr/tcp_posix.cc
  src/core/lib/iomgr/tcp_server.cc
  src/core/lib/iomgr/tcp_server_custom.cc
  src/core/lib/iomgr/tcp_server_posix.cc
  src/core/lib/iomgr/tcp_server_utils_posix_common.cc
  src/core/lib/iomgr/tcp_server_utils_posix_ifaddrs.cc
  src/core/lib/iomgr/tcp_server_utils_posix_noifaddrs.cc
  src/core/lib/iomgr/tcp_server_windows.cc
  src/core/lib/iomgr/tcp_uv.cc
  src/core/lib/iomgr/tcp_windows.cc
  src/core/lib/iomgr/time_averaged_stats.cc
  src/core/lib/iomgr/timer.cc
  src/core/lib/iomgr/timer_custom.cc
  src/core/lib/iomgr/timer_generic.cc
  src/core/lib/iomgr/timer_heap.cc
  src/core/lib/iomgr/timer_manager.cc
  src/core/lib/iomgr/timer_uv.cc
  src/core/lib/iomgr/udp_server.cc
  src/core/lib/iomgr/unix_sockets_posix.cc
  src/core/lib/iomgr/unix_sockets_posix_noop.cc
  src/core/lib/iomgr/wakeup_fd_eventfd.cc
  src/core/lib/iomgr/wakeup_fd_nospecial.cc
  src/core/lib/iomgr/wakeup_fd_pipe.cc
  src/core/lib/iomgr/wakeup_fd_posix.cc
  src/core/lib/iomgr/work_serializer.cc
  src/core/lib/json/json_reader.cc
  src/core/lib/json/json_writer.cc
  src/core/lib/slice/b64.cc
  src/core/lib/slice/percent_encoding.cc
  src/core/lib/slice/slice.cc
  src/core/lib/slice/slice_buffer.cc
  src/core/lib/slice/slice_intern.cc
  src/core/lib/slice/slice_string_helpers.cc
  src/core/lib/surface/api_trace.cc
  src/core/lib/surface/byte_buffer.cc
  src/core/lib/surface/byte_buffer_reader.cc
  src/core/lib/surface/call.cc
  src/core/lib/surface/call_details.cc
  src/core/lib/surface/call_log_batch.cc
  src/core/lib/surface/channel.cc
  src/core/lib/surface/channel_init.cc
  src/core/lib/surface/channel_ping.cc
  src/core/lib/surface/channel_stack_type.cc
  src/core/lib/surface/completion_queue.cc
  src/core/lib/surface/completion_queue_factory.cc
  src/core/lib/surface/event_string.cc
  src/core/lib/surface/init.cc
  src/core/lib/surface/init_unsecure.cc
  src/core/lib/surface/lame_client.cc
  src/core/lib/surface/metadata_array.cc
  src/core/lib/surface/server.cc
  src/core/lib/surface/validate_metadata.cc
  src/core/lib/surface/version.cc
  src/core/lib/transport/authority_override.cc
  src/core/lib/transport/bdp_estimator.cc
  src/core/lib/transport/byte_stream.cc
  src/core/lib/transport/connectivity_state.cc
  src/core/lib/transport/error_utils.cc
  src/core/lib/transport/metadata.cc
  src/core/lib/transport/metadata_batch.cc
  src/core/lib/transport/pid_controller.cc
  src/core/lib/transport/static_metadata.cc
  src/core/lib/transport/status_conversion.cc
  src/core/lib/transport/status_metadata.cc
  src/core/lib/transport/timeout_encoding.cc
  src/core/lib/transport/transport.cc
  src/core/lib/transport/transport_op_string.cc
  src/core/lib/uri/uri_parser.cc
  src/core/plugin_registry/grpc_unsecure_plugin_registry.cc
)

set_target_properties(grpc_unsecure PROPERTIES
  VERSION ${gRPC_CORE_VERSION}
  SOVERSION ${gRPC_CORE_SOVERSION}
)

target_include_directories(grpc_unsecure
  PUBLIC $<INSTALL_INTERFACE:${gRPC_INSTALL_INCLUDEDIR}> $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(grpc_unsecure
  ${_gRPC_BASELIB_LIBRARIES}
  ${_gRPC_ZLIB_LIBRARIES}
  ${_gRPC_CARES_LIBRARIES}
  ${_gRPC_ADDRESS_SORTING_LIBRARIES}
  ${_gRPC_RE2_LIBRARIES}
  ${_gRPC_UPB_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr
  address_sorting
  upb
  absl::optional
  absl::strings
  absl::status
  absl::inlined_vector
)
if(_gRPC_PLATFORM_MAC)
  target_link_libraries(grpc_unsecure "-framework CoreFoundation")
endif()

foreach(_hdr
  include/grpc/byte_buffer.h
  include/grpc/byte_buffer_reader.h
  include/grpc/census.h
  include/grpc/compression.h
  include/grpc/fork.h
  include/grpc/grpc.h
  include/grpc/grpc_posix.h
  include/grpc/grpc_security_constants.h
  include/grpc/load_reporting.h
  include/grpc/slice.h
  include/grpc/slice_buffer.h
  include/grpc/status.h
  include/grpc/support/workaround_list.h
)
  string(REPLACE "include/" "" _path ${_hdr})
  get_filename_component(_path ${_path} PATH)
  install(FILES ${_hdr}
    DESTINATION "${gRPC_INSTALL_INCLUDEDIR}/${_path}"
  )
endforeach()


if(gRPC_INSTALL)
  install(TARGETS grpc_unsecure EXPORT gRPCTargets
    RUNTIME DESTINATION ${gRPC_INSTALL_BINDIR}
    LIBRARY DESTINATION ${gRPC_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${gRPC_INSTALL_LIBDIR}
  )
endif()



if(gRPC_BUILD_CODEGEN)
add_library(grpc++_error_details
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/status/status.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/status/status.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/status/status.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/status/status.grpc.pb.h
  src/cpp/util/error_details.cc
)

set_target_properties(grpc++_error_details PROPERTIES
  VERSION ${gRPC_CPP_VERSION}
  SOVERSION ${gRPC_CPP_SOVERSION}
)

target_include_directories(grpc++_error_details
  PUBLIC $<INSTALL_INTERFACE:${gRPC_INSTALL_INCLUDEDIR}> $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
    ${_gRPC_PROTO_GENS_DIR}
)
target_link_libraries(grpc++_error_details
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_unsecure
  grpc_unsecure
  gpr
  address_sorting
  upb
)

foreach(_hdr
  include/grpc++/support/error_details.h
  include/grpcpp/support/error_details.h
)
  string(REPLACE "include/" "" _path ${_hdr})
  get_filename_component(_path ${_path} PATH)
  install(FILES ${_hdr}
    DESTINATION "${gRPC_INSTALL_INCLUDEDIR}/${_path}"
  )
endforeach()
endif()

if(gRPC_BUILD_CODEGEN)

if(gRPC_INSTALL)
  install(TARGETS grpc++_error_details EXPORT gRPCTargets
    RUNTIME DESTINATION ${gRPC_INSTALL_BINDIR}
    LIBRARY DESTINATION ${gRPC_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${gRPC_INSTALL_LIBDIR}
  )
endif()

endif()

if(gRPC_BUILD_CODEGEN)
add_library(grpc++_reflection
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1alpha/reflection.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1alpha/reflection.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1alpha/reflection.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1alpha/reflection.grpc.pb.h
  src/cpp/ext/proto_server_reflection.cc
  src/cpp/ext/proto_server_reflection_plugin.cc
)

set_target_properties(grpc++_reflection PROPERTIES
  VERSION ${gRPC_CPP_VERSION}
  SOVERSION ${gRPC_CPP_SOVERSION}
)

target_include_directories(grpc++_reflection
  PUBLIC $<INSTALL_INTERFACE:${gRPC_INSTALL_INCLUDEDIR}> $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
    ${_gRPC_PROTO_GENS_DIR}
)
target_link_libraries(grpc++_reflection
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_unsecure
  grpc_unsecure
  gpr
  address_sorting
  upb
)

foreach(_hdr
  include/grpc++/ext/proto_server_reflection_plugin.h
  include/grpcpp/ext/proto_server_reflection_plugin.h
)
  string(REPLACE "include/" "" _path ${_hdr})
  get_filename_component(_path ${_path} PATH)
  install(FILES ${_hdr}
    DESTINATION "${gRPC_INSTALL_INCLUDEDIR}/${_path}"
  )
endforeach()
endif()

if(gRPC_BUILD_CODEGEN)

if(gRPC_INSTALL)
  install(TARGETS grpc++_reflection EXPORT gRPCTargets
    RUNTIME DESTINATION ${gRPC_INSTALL_BINDIR}
    LIBRARY DESTINATION ${gRPC_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${gRPC_INSTALL_LIBDIR}
  )
endif()

endif()


add_library(grpc++_unsecure
  src/cpp/client/channel_cc.cc
  src/cpp/client/client_callback.cc
  src/cpp/client/client_context.cc
  src/cpp/client/client_interceptor.cc
  src/cpp/client/create_channel.cc
  src/cpp/client/create_channel_internal.cc
  src/cpp/client/create_channel_posix.cc
  src/cpp/client/credentials_cc.cc
  src/cpp/client/insecure_credentials.cc
  src/cpp/codegen/codegen_init.cc
  src/cpp/common/alarm.cc
  src/cpp/common/channel_arguments.cc
  src/cpp/common/channel_filter.cc
  src/cpp/common/completion_queue_cc.cc
  src/cpp/common/core_codegen.cc
  src/cpp/common/insecure_create_auth_context.cc
  src/cpp/common/resource_quota_cc.cc
  src/cpp/common/rpc_method.cc
  src/cpp/common/validate_service_config.cc
  src/cpp/common/version_cc.cc
  src/cpp/server/async_generic_service.cc
  src/cpp/server/channel_argument_option.cc
  src/cpp/server/create_default_thread_pool.cc
  src/cpp/server/dynamic_thread_pool.cc
  src/cpp/server/external_connection_acceptor_impl.cc
  src/cpp/server/health/default_health_check_service.cc
  src/cpp/server/health/health_check_service.cc
  src/cpp/server/health/health_check_service_server_builder_option.cc
  src/cpp/server/insecure_server_credentials.cc
  src/cpp/server/server_builder.cc
  src/cpp/server/server_callback.cc
  src/cpp/server/server_cc.cc
  src/cpp/server/server_context.cc
  src/cpp/server/server_credentials.cc
  src/cpp/server/server_posix.cc
  src/cpp/thread_manager/thread_manager.cc
  src/cpp/util/byte_buffer_cc.cc
  src/cpp/util/status.cc
  src/cpp/util/string_ref.cc
  src/cpp/util/time_cc.cc
)

set_target_properties(grpc++_unsecure PROPERTIES
  VERSION ${gRPC_CPP_VERSION}
  SOVERSION ${gRPC_CPP_SOVERSION}
)

target_include_directories(grpc++_unsecure
  PUBLIC $<INSTALL_INTERFACE:${gRPC_INSTALL_INCLUDEDIR}> $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
    ${_gRPC_PROTO_GENS_DIR}
)
target_link_libraries(grpc++_unsecure
  ${_gRPC_BASELIB_LIBRARIES}
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_unsecure
  gpr
  address_sorting
  upb
)

foreach(_hdr
  include/grpc++/alarm.h
  include/grpc++/channel.h
  include/grpc++/client_context.h
  include/grpc++/completion_queue.h
  include/grpc++/create_channel.h
  include/grpc++/create_channel_posix.h
  include/grpc++/ext/health_check_service_server_builder_option.h
  include/grpc++/generic/async_generic_service.h
  include/grpc++/generic/generic_stub.h
  include/grpc++/grpc++.h
  include/grpc++/health_check_service_interface.h
  include/grpc++/impl/call.h
  include/grpc++/impl/channel_argument_option.h
  include/grpc++/impl/client_unary_call.h
  include/grpc++/impl/codegen/async_stream.h
  include/grpc++/impl/codegen/async_unary_call.h
  include/grpc++/impl/codegen/byte_buffer.h
  include/grpc++/impl/codegen/call.h
  include/grpc++/impl/codegen/call_hook.h
  include/grpc++/impl/codegen/channel_interface.h
  include/grpc++/impl/codegen/client_context.h
  include/grpc++/impl/codegen/client_unary_call.h
  include/grpc++/impl/codegen/completion_queue.h
  include/grpc++/impl/codegen/completion_queue_tag.h
  include/grpc++/impl/codegen/config.h
  include/grpc++/impl/codegen/config_protobuf.h
  include/grpc++/impl/codegen/core_codegen.h
  include/grpc++/impl/codegen/core_codegen_interface.h
  include/grpc++/impl/codegen/create_auth_context.h
  include/grpc++/impl/codegen/grpc_library.h
  include/grpc++/impl/codegen/metadata_map.h
  include/grpc++/impl/codegen/method_handler_impl.h
  include/grpc++/impl/codegen/proto_utils.h
  include/grpc++/impl/codegen/rpc_method.h
  include/grpc++/impl/codegen/rpc_service_method.h
  include/grpc++/impl/codegen/security/auth_context.h
  include/grpc++/impl/codegen/serialization_traits.h
  include/grpc++/impl/codegen/server_context.h
  include/grpc++/impl/codegen/server_interface.h
  include/grpc++/impl/codegen/service_type.h
  include/grpc++/impl/codegen/slice.h
  include/grpc++/impl/codegen/status.h
  include/grpc++/impl/codegen/status_code_enum.h
  include/grpc++/impl/codegen/string_ref.h
  include/grpc++/impl/codegen/stub_options.h
  include/grpc++/impl/codegen/sync_stream.h
  include/grpc++/impl/codegen/time.h
  include/grpc++/impl/grpc_library.h
  include/grpc++/impl/method_handler_impl.h
  include/grpc++/impl/rpc_method.h
  include/grpc++/impl/rpc_service_method.h
  include/grpc++/impl/serialization_traits.h
  include/grpc++/impl/server_builder_option.h
  include/grpc++/impl/server_builder_plugin.h
  include/grpc++/impl/server_initializer.h
  include/grpc++/impl/service_type.h
  include/grpc++/resource_quota.h
  include/grpc++/security/auth_context.h
  include/grpc++/security/auth_metadata_processor.h
  include/grpc++/security/credentials.h
  include/grpc++/security/server_credentials.h
  include/grpc++/server.h
  include/grpc++/server_builder.h
  include/grpc++/server_context.h
  include/grpc++/server_posix.h
  include/grpc++/support/async_stream.h
  include/grpc++/support/async_unary_call.h
  include/grpc++/support/byte_buffer.h
  include/grpc++/support/channel_arguments.h
  include/grpc++/support/config.h
  include/grpc++/support/slice.h
  include/grpc++/support/status.h
  include/grpc++/support/status_code_enum.h
  include/grpc++/support/string_ref.h
  include/grpc++/support/stub_options.h
  include/grpc++/support/sync_stream.h
  include/grpc++/support/time.h
  include/grpcpp/alarm.h
  include/grpcpp/alarm_impl.h
  include/grpcpp/channel.h
  include/grpcpp/client_context.h
  include/grpcpp/completion_queue.h
  include/grpcpp/create_channel.h
  include/grpcpp/create_channel_posix.h
  include/grpcpp/ext/health_check_service_server_builder_option.h
  include/grpcpp/generic/async_generic_service.h
  include/grpcpp/generic/generic_stub.h
  include/grpcpp/grpcpp.h
  include/grpcpp/health_check_service_interface.h
  include/grpcpp/impl/call.h
  include/grpcpp/impl/channel_argument_option.h
  include/grpcpp/impl/client_unary_call.h
  include/grpcpp/impl/codegen/async_generic_service.h
  include/grpcpp/impl/codegen/async_stream.h
  include/grpcpp/impl/codegen/async_stream_impl.h
  include/grpcpp/impl/codegen/async_unary_call.h
  include/grpcpp/impl/codegen/async_unary_call_impl.h
  include/grpcpp/impl/codegen/byte_buffer.h
  include/grpcpp/impl/codegen/call.h
  include/grpcpp/impl/codegen/call_hook.h
  include/grpcpp/impl/codegen/call_op_set.h
  include/grpcpp/impl/codegen/call_op_set_interface.h
  include/grpcpp/impl/codegen/callback_common.h
  include/grpcpp/impl/codegen/channel_interface.h
  include/grpcpp/impl/codegen/client_callback.h
  include/grpcpp/impl/codegen/client_callback_impl.h
  include/grpcpp/impl/codegen/client_context.h
  include/grpcpp/impl/codegen/client_interceptor.h
  include/grpcpp/impl/codegen/client_unary_call.h
  include/grpcpp/impl/codegen/completion_queue.h
  include/grpcpp/impl/codegen/completion_queue_tag.h
  include/grpcpp/impl/codegen/config.h
  include/grpcpp/impl/codegen/config_protobuf.h
  include/grpcpp/impl/codegen/core_codegen.h
  include/grpcpp/impl/codegen/core_codegen_interface.h
  include/grpcpp/impl/codegen/create_auth_context.h
  include/grpcpp/impl/codegen/delegating_channel.h
  include/grpcpp/impl/codegen/grpc_library.h
  include/grpcpp/impl/codegen/intercepted_channel.h
  include/grpcpp/impl/codegen/interceptor.h
  include/grpcpp/impl/codegen/interceptor_common.h
  include/grpcpp/impl/codegen/message_allocator.h
  include/grpcpp/impl/codegen/metadata_map.h
  include/grpcpp/impl/codegen/method_handler.h
  include/grpcpp/impl/codegen/method_handler_impl.h
  include/grpcpp/impl/codegen/proto_buffer_reader.h
  include/grpcpp/impl/codegen/proto_buffer_writer.h
  include/grpcpp/impl/codegen/proto_utils.h
  include/grpcpp/impl/codegen/rpc_method.h
  include/grpcpp/impl/codegen/rpc_service_method.h
  include/grpcpp/impl/codegen/security/auth_context.h
  include/grpcpp/impl/codegen/serialization_traits.h
  include/grpcpp/impl/codegen/server_callback.h
  include/grpcpp/impl/codegen/server_callback_handlers.h
  include/grpcpp/impl/codegen/server_callback_impl.h
  include/grpcpp/impl/codegen/server_context.h
  include/grpcpp/impl/codegen/server_context_impl.h
  include/grpcpp/impl/codegen/server_interceptor.h
  include/grpcpp/impl/codegen/server_interface.h
  include/grpcpp/impl/codegen/service_type.h
  include/grpcpp/impl/codegen/slice.h
  include/grpcpp/impl/codegen/status.h
  include/grpcpp/impl/codegen/status_code_enum.h
  include/grpcpp/impl/codegen/string_ref.h
  include/grpcpp/impl/codegen/stub_options.h
  include/grpcpp/impl/codegen/sync.h
  include/grpcpp/impl/codegen/sync_stream.h
  include/grpcpp/impl/codegen/sync_stream_impl.h
  include/grpcpp/impl/codegen/time.h
  include/grpcpp/impl/grpc_library.h
  include/grpcpp/impl/method_handler_impl.h
  include/grpcpp/impl/rpc_method.h
  include/grpcpp/impl/rpc_service_method.h
  include/grpcpp/impl/serialization_traits.h
  include/grpcpp/impl/server_builder_option.h
  include/grpcpp/impl/server_builder_option_impl.h
  include/grpcpp/impl/server_builder_plugin.h
  include/grpcpp/impl/server_initializer.h
  include/grpcpp/impl/server_initializer_impl.h
  include/grpcpp/impl/service_type.h
  include/grpcpp/resource_quota.h
  include/grpcpp/security/auth_context.h
  include/grpcpp/security/auth_metadata_processor.h
  include/grpcpp/security/credentials.h
  include/grpcpp/security/server_credentials.h
  include/grpcpp/security/tls_credentials_options.h
  include/grpcpp/server.h
  include/grpcpp/server_builder.h
  include/grpcpp/server_context.h
  include/grpcpp/server_impl.h
  include/grpcpp/server_posix.h
  include/grpcpp/support/async_stream.h
  include/grpcpp/support/async_stream_impl.h
  include/grpcpp/support/async_unary_call.h
  include/grpcpp/support/async_unary_call_impl.h
  include/grpcpp/support/byte_buffer.h
  include/grpcpp/support/channel_arguments.h
  include/grpcpp/support/client_callback.h
  include/grpcpp/support/client_callback_impl.h
  include/grpcpp/support/client_interceptor.h
  include/grpcpp/support/config.h
  include/grpcpp/support/interceptor.h
  include/grpcpp/support/message_allocator.h
  include/grpcpp/support/method_handler.h
  include/grpcpp/support/proto_buffer_reader.h
  include/grpcpp/support/proto_buffer_writer.h
  include/grpcpp/support/server_callback.h
  include/grpcpp/support/server_callback_impl.h
  include/grpcpp/support/server_interceptor.h
  include/grpcpp/support/slice.h
  include/grpcpp/support/status.h
  include/grpcpp/support/status_code_enum.h
  include/grpcpp/support/string_ref.h
  include/grpcpp/support/stub_options.h
  include/grpcpp/support/sync_stream.h
  include/grpcpp/support/sync_stream_impl.h
  include/grpcpp/support/time.h
  include/grpcpp/support/validate_service_config.h
)
  string(REPLACE "include/" "" _path ${_hdr})
  get_filename_component(_path ${_path} PATH)
  install(FILES ${_hdr}
    DESTINATION "${gRPC_INSTALL_INCLUDEDIR}/${_path}"
  )
endforeach()


if(gRPC_INSTALL)
  install(TARGETS grpc++_unsecure EXPORT gRPCTargets
    RUNTIME DESTINATION ${gRPC_INSTALL_BINDIR}
    LIBRARY DESTINATION ${gRPC_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${gRPC_INSTALL_LIBDIR}
  )
endif()


add_library(grpc_plugin_support
  src/compiler/cpp_generator.cc
  src/compiler/csharp_generator.cc
  src/compiler/node_generator.cc
  src/compiler/objective_c_generator.cc
  src/compiler/php_generator.cc
  src/compiler/python_generator.cc
  src/compiler/ruby_generator.cc
)

set_target_properties(grpc_plugin_support PROPERTIES
  VERSION ${gRPC_CPP_VERSION}
  SOVERSION ${gRPC_CPP_SOVERSION}
)

target_include_directories(grpc_plugin_support
  PUBLIC $<INSTALL_INTERFACE:${gRPC_INSTALL_INCLUDEDIR}> $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
    ${_gRPC_PROTO_GENS_DIR}
)
target_link_libraries(grpc_plugin_support
  ${_gRPC_PROTOBUF_PROTOC_LIBRARIES}
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
)

foreach(_hdr
  include/grpc++/impl/codegen/config_protobuf.h
  include/grpcpp/impl/codegen/config_protobuf.h
)
  string(REPLACE "include/" "" _path ${_hdr})
  get_filename_component(_path ${_path} PATH)
  install(FILES ${_hdr}
    DESTINATION "${gRPC_INSTALL_INCLUDEDIR}/${_path}"
  )
endforeach()


if(gRPC_INSTALL)
  install(TARGETS grpc_plugin_support EXPORT gRPCTargets
    RUNTIME DESTINATION ${gRPC_INSTALL_BINDIR}
    LIBRARY DESTINATION ${gRPC_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${gRPC_INSTALL_LIBDIR}
  )
endif()


# grpcpp_channelz doesn't build with protobuf-lite
# See https://github.com/grpc/grpc/issues/19473
if(gRPC_BUILD_CODEGEN AND NOT gRPC_USE_PROTO_LITE)
add_library(grpcpp_channelz
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/channelz/channelz.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/channelz/channelz.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/channelz/channelz.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/channelz/channelz.grpc.pb.h
  src/cpp/server/channelz/channelz_service.cc
  src/cpp/server/channelz/channelz_service_plugin.cc
)

set_target_properties(grpcpp_channelz PROPERTIES
  VERSION ${gRPC_CPP_VERSION}
  SOVERSION ${gRPC_CPP_SOVERSION}
)


target_include_directories(grpcpp_channelz
  PUBLIC $<INSTALL_INTERFACE:${gRPC_INSTALL_INCLUDEDIR}> $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
    ${_gRPC_PROTO_GENS_DIR}
)
target_link_libraries(grpcpp_channelz
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_unsecure
  grpc_unsecure
  gpr
  address_sorting
  upb
)

foreach(_hdr
  include/grpcpp/ext/channelz_service_plugin.h
  include/grpcpp/ext/channelz_service_plugin_impl.h
)
  string(REPLACE "include/" "" _path ${_hdr})
  get_filename_component(_path ${_path} PATH)
  install(FILES ${_hdr}
    DESTINATION "${gRPC_INSTALL_INCLUDEDIR}/${_path}"
  )
endforeach()
endif()

if(gRPC_BUILD_CODEGEN)

if(gRPC_INSTALL AND NOT gRPC_USE_PROTO_LITE)
  install(TARGETS grpcpp_channelz EXPORT gRPCTargets
    RUNTIME DESTINATION ${gRPC_INSTALL_BINDIR}
    LIBRARY DESTINATION ${gRPC_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${gRPC_INSTALL_LIBDIR}
  )
endif()

endif()

add_library(upb
  third_party/upb/upb/decode.c
  third_party/upb/upb/encode.c
  third_party/upb/upb/msg.c
  third_party/upb/upb/port.c
  third_party/upb/upb/table.c
  third_party/upb/upb/upb.c
)

set_target_properties(upb PROPERTIES
  VERSION ${gRPC_CORE_VERSION}
  SOVERSION ${gRPC_CORE_SOVERSION}
)

target_include_directories(upb
  PUBLIC $<INSTALL_INTERFACE:${gRPC_INSTALL_INCLUDEDIR}> $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(upb
  ${_gRPC_ALLTARGETS_LIBRARIES}
)



if(gRPC_INSTALL)
  install(TARGETS upb EXPORT gRPCTargets
    RUNTIME DESTINATION ${gRPC_INSTALL_BINDIR}
    LIBRARY DESTINATION ${gRPC_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${gRPC_INSTALL_LIBDIR}
  )
endif()

#if(brett)

add_executable(check_epollexclusive
  test/build/check_epollexclusive.c
)

target_include_directories(check_epollexclusive
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)

target_link_libraries(check_epollexclusive
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_unsecure  #brett
  gpr
)

add_executable(gen_hpack_tables
  tools/codegen/core/gen_hpack_tables.cc
)

target_include_directories(gen_hpack_tables
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
    ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(gen_hpack_tables
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_unsecure  #Brett
  gpr
)



add_executable(gen_legal_metadata_characters
  tools/codegen/core/gen_legal_metadata_characters.cc
)

target_include_directories(gen_legal_metadata_characters
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
    ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(gen_legal_metadata_characters
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
)



add_executable(gen_percent_encoding_tables
  tools/codegen/core/gen_percent_encoding_tables.cc
)

target_include_directories(gen_percent_encoding_tables
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
    ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(gen_percent_encoding_tables
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
)


if(gRPC_BUILD_CODEGEN AND gRPC_BUILD_GRPC_CPP_PLUGIN)

add_executable(grpc_cpp_plugin
  src/compiler/cpp_plugin.cc
)

target_include_directories(grpc_cpp_plugin
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
    ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(grpc_cpp_plugin
  ${_gRPC_PROTOBUF_PROTOC_LIBRARIES}
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_plugin_support
)



if(gRPC_INSTALL)
  install(TARGETS grpc_cpp_plugin EXPORT gRPCTargets
    RUNTIME DESTINATION ${gRPC_INSTALL_BINDIR}
    LIBRARY DESTINATION ${gRPC_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${gRPC_INSTALL_LIBDIR}
  )
endif()
endif()


if(gRPC_INSTALL)
  install(EXPORT gRPCTargets
    DESTINATION ${gRPC_INSTALL_CMAKEDIR}
    NAMESPACE gRPC::
  )
endif()

include(CMakePackageConfigHelpers)

configure_file(cmake/gRPCConfig.cmake.in
  gRPCConfig.cmake @ONLY)
write_basic_package_version_file(${CMAKE_CURRENT_BINARY_DIR}/gRPCConfigVersion.cmake
  VERSION ${gRPC_CPP_VERSION}
  COMPATIBILITY AnyNewerVersion)
install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/gRPCConfig.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/gRPCConfigVersion.cmake
  DESTINATION ${gRPC_INSTALL_CMAKEDIR}
)
install(FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules/Findc-ares.cmake
  DESTINATION ${gRPC_INSTALL_CMAKEDIR}/modules
)

install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/etc/roots.pem
  DESTINATION ${gRPC_INSTALL_SHAREDIR})

# Function to generate pkg-config files.
function(generate_pkgconfig name description version requires
                            libs libs_private output_filename)
  set(PC_NAME "${name}")
  set(PC_DESCRIPTION "${description}")
  set(PC_VERSION "${version}")
  set(PC_REQUIRES "${requires}")
  set(PC_LIB "${libs}")
  set(PC_LIBS_PRIVATE "${libs_private}")
  set(output_filepath "${grpc_BINARY_DIR}/libs/opt/pkgconfig/${output_filename}")
  configure_file(
    "${grpc_SOURCE_DIR}/cmake/pkg-config-template.pc.in"
    "${output_filepath}"
    @ONLY)
  install(FILES "${output_filepath}"
    DESTINATION "lib/pkgconfig/")
endfunction()

# gpr .pc file
generate_pkgconfig(
  "gpr"
  "gRPC platform support library"
  "${gRPC_CORE_VERSION}"
  ""
  "-lgpr -labsl_str_format_internal -labsl_synchronization -labsl_graphcycles_internal -labsl_symbolize -labsl_demangle_internal -labsl_stacktrace -labsl_debugging_internal -labsl_malloc_internal -labsl_time -labsl_time_zone -labsl_civil_time -labsl_strings -labsl_strings_internal -labsl_throw_delegate -labsl_int128 -labsl_base -labsl_spinlock_wait -labsl_raw_logging_internal -labsl_log_severity -labsl_dynamic_annotations"
  ""
  "gpr.pc")


# grpc_unsecure .pc file
generate_pkgconfig(
  "gRPC unsecure"
  "high performance general RPC framework without SSL"
  "${gRPC_CORE_VERSION}"
  "gpr"
  "-lgrpc_unsecure -labsl_status -labsl_cord -labsl_bad_optional_access -labsl_str_format_internal -labsl_synchronization -labsl_graphcycles_internal -labsl_symbolize -labsl_demangle_internal -labsl_stacktrace -labsl_debugging_internal -labsl_malloc_internal -labsl_time -labsl_time_zone -labsl_civil_time -labsl_strings -labsl_strings_internal -labsl_throw_delegate -labsl_int128 -labsl_base -labsl_spinlock_wait -labsl_raw_logging_internal -labsl_log_severity -labsl_dynamic_annotations"
  ""
  "grpc_unsecure.pc")

# grpc++_unsecure .pc file
generate_pkgconfig(
  "gRPC++ unsecure"
  "C++ wrapper for gRPC without SSL"
  "${gRPC_CPP_VERSION}"
  "grpc_unsecure"
  "-lgrpc++_unsecure -labsl_status -labsl_cord -labsl_bad_optional_access -labsl_str_format_internal -labsl_synchronization -labsl_graphcycles_internal -labsl_symbolize -labsl_demangle_internal -labsl_stacktrace -labsl_debugging_internal -labsl_malloc_internal -labsl_time -labsl_time_zone -labsl_civil_time -labsl_strings -labsl_strings_internal -labsl_throw_delegate -labsl_int128 -labsl_base -labsl_spinlock_wait -labsl_raw_logging_internal -labsl_log_severity -labsl_dynamic_annotations"
  ""
  "grpc++_unsecure.pc")
