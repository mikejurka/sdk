// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#include "vm/globals.h"
#if defined(TARGET_OS_FUCHSIA)

#include "vm/os.h"

#include <magenta/syscalls.h>
#include <magenta/types.h>

#include "platform/assert.h"
#include "vm/zone.h"

namespace dart {

const char* OS::Name() {
  return "fuchsia";
}


intptr_t OS::ProcessId() {
  UNIMPLEMENTED();
  return 0;
}


const char* OS::GetTimeZoneName(int64_t seconds_since_epoch) {
  UNIMPLEMENTED();
  return "";
}


int OS::GetTimeZoneOffsetInSeconds(int64_t seconds_since_epoch) {
  UNIMPLEMENTED();
  return 0;
}


int OS::GetLocalTimeZoneAdjustmentInSeconds() {
  UNIMPLEMENTED();
  return 0;
}


int64_t OS::GetCurrentTimeMillis() {
  return GetCurrentTimeMicros() / 1000;
}


int64_t OS::GetCurrentTimeMicros() {
  return _magenta_current_time() / 1000;
}


int64_t OS::GetCurrentMonotonicTicks() {
  return _magenta_current_time();
}


int64_t OS::GetCurrentMonotonicFrequency() {
  return kNanosecondsPerSecond;
}


int64_t OS::GetCurrentMonotonicMicros() {
  int64_t ticks = GetCurrentMonotonicTicks();
  ASSERT(GetCurrentMonotonicFrequency() == kNanosecondsPerSecond);
  return ticks / kNanosecondsPerMicrosecond;
}


int64_t OS::GetCurrentThreadCPUMicros() {
  UNIMPLEMENTED();
  return 0;
}


void* OS::AlignedAllocate(intptr_t size, intptr_t alignment) {
  UNIMPLEMENTED();
  return NULL;
}


void OS::AlignedFree(void* ptr) {
  UNIMPLEMENTED();
}


// TODO(5411554):  May need to hoist these architecture dependent code
// into a architecture specific file e.g: os_ia32_fuchsia.cc
intptr_t OS::ActivationFrameAlignment() {
#if defined(TARGET_ARCH_IA32) || defined(TARGET_ARCH_X64) || \
    defined(TARGET_ARCH_ARM64)
  const int kMinimumAlignment = 16;
#elif defined(TARGET_ARCH_ARM) || defined(TARGET_ARCH_DBC)
  const int kMinimumAlignment = 8;
#else
#error Unsupported architecture.
#endif
  intptr_t alignment = kMinimumAlignment;
  // TODO(5411554): Allow overriding default stack alignment for
  // testing purposes.
  // Flags::DebugIsInt("stackalign", &alignment);
  ASSERT(Utils::IsPowerOfTwo(alignment));
  ASSERT(alignment >= kMinimumAlignment);
  return alignment;
}


intptr_t OS::PreferredCodeAlignment() {
#if defined(TARGET_ARCH_IA32) ||                                               \
    defined(TARGET_ARCH_X64) ||                                                \
    defined(TARGET_ARCH_ARM64) ||                                              \
    defined(TARGET_ARCH_DBC)
  const int kMinimumAlignment = 32;
#elif defined(TARGET_ARCH_ARM) || defined(TARGET_ARCH_MIPS)
  const int kMinimumAlignment = 16;
#else
#error Unsupported architecture.
#endif
  intptr_t alignment = kMinimumAlignment;
  // TODO(5411554): Allow overriding default code alignment for
  // testing purposes.
  // Flags::DebugIsInt("codealign", &alignment);
  ASSERT(Utils::IsPowerOfTwo(alignment));
  ASSERT(alignment >= kMinimumAlignment);
  ASSERT(alignment <= OS::kMaxPreferredCodeAlignment);
  return alignment;
}


bool OS::AllowStackFrameIteratorFromAnotherThread() {
  UNIMPLEMENTED();
  return false;
}


int OS::NumberOfAvailableProcessors() {
  UNIMPLEMENTED();
  return 0;
}


void OS::Sleep(int64_t millis) {
  UNIMPLEMENTED();
}


void OS::SleepMicros(int64_t micros) {
  UNIMPLEMENTED();
}


void OS::DebugBreak() {
  UNIMPLEMENTED();
}


char* OS::StrNDup(const char* s, intptr_t n) {
  UNIMPLEMENTED();
  return NULL;
}


intptr_t OS::StrNLen(const char* s, intptr_t n) {
  UNIMPLEMENTED();
  return 0;
}


void OS::Print(const char* format, ...) {
  UNIMPLEMENTED();
}


void OS::VFPrint(FILE* stream, const char* format, va_list args) {
  vfprintf(stream, format, args);
  fflush(stream);
}


int OS::SNPrint(char* str, size_t size, const char* format, ...) {
  va_list args;
  va_start(args, format);
  int retval = VSNPrint(str, size, format, args);
  va_end(args);
  return retval;
}


int OS::VSNPrint(char* str, size_t size, const char* format, va_list args) {
  int retval = vsnprintf(str, size, format, args);
  if (retval < 0) {
    FATAL1("Fatal error in OS::VSNPrint with format '%s'", format);
  }
  return retval;
}


char* OS::SCreate(Zone* zone, const char* format, ...) {
  va_list args;
  va_start(args, format);
  char* buffer = VSCreate(zone, format, args);
  va_end(args);
  return buffer;
}


char* OS::VSCreate(Zone* zone, const char* format, va_list args) {
  // Measure.
  va_list measure_args;
  va_copy(measure_args, args);
  intptr_t len = VSNPrint(NULL, 0, format, measure_args);
  va_end(measure_args);

  char* buffer;
  if (zone) {
    buffer = zone->Alloc<char>(len + 1);
  } else {
    buffer = reinterpret_cast<char*>(malloc(len + 1));
  }
  ASSERT(buffer != NULL);

  // Print.
  va_list print_args;
  va_copy(print_args, args);
  VSNPrint(buffer, len + 1, format, print_args);
  va_end(print_args);
  return buffer;
}


bool OS::StringToInt64(const char* str, int64_t* value) {
  UNIMPLEMENTED();
  return false;
}


void OS::RegisterCodeObservers() {
  UNIMPLEMENTED();
}


void OS::PrintErr(const char* format, ...) {
  va_list args;
  va_start(args, format);
  VFPrint(stderr, format, args);
  va_end(args);
}


void OS::InitOnce() {
  // TODO(5411554): For now we check that initonce is called only once,
  // Once there is more formal mechanism to call InitOnce we can move
  // this check there.
  static bool init_once_called = false;
  ASSERT(init_once_called == false);
  init_once_called = true;
}


void OS::Shutdown() {
}


void OS::Abort() {
  abort();
}


void OS::Exit(int code) {
  UNIMPLEMENTED();
}

}  // namespace dart

#endif  // defined(TARGET_OS_FUCHSIA)