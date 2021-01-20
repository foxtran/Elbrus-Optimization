#include <stdint.h>

uint64_t rdtsc()
{
#if defined(__x86_64__) || defined(__amd64__)
  uint64_t low, high;
  __asm__ volatile("rdtsc" : "=a"(low), "=d"(high));
  return (high << 32) | low;
#elif defined(__powerpc64__) || defined(__ppc64__)
  int64_t tb;
  asm volatile("mfspr %0, 268" : "=r"(tb));
  return tb;
#elif defined(__aarch64__)
  int64_t virtual_timer_value;
  asm volatile("mrs %0, cntvct_el0" : "=r"(virtual_timer_value));
  return virtual_timer_value;
#elif defined(__e2k__)
  uint64_t dst;
  asm volatile("rrd %%clkr, %0" : "=r" (dst));
  return dst;
#else
#error "YOUR ARCHITECTURE IS NOT SUPPORTED!"
#error "See https://github.com/google/benchmark/blob/master/src/cycleclock.h"
#endif
}
