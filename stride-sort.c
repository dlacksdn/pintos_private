#include "threads/thread.h"
#include "devices/timer.h"
#include <stdio.h>
#include <inttypes.h>    /* PRId64 매크로를 위해 */

#define N 5
#define RUNNING_TIME 5000  // ticks (약 1초)

int count_stride_sort[N];
static volatile bool running = true;

static volatile void
thread_func_perf(void *aux) {
  int id = *(int *)aux;
    // 이 줄 추가: 현재 실행 중인 스레드에 ID 기록
  thread_current()->perf_id = id;

  while (running) {
    
  }

  thread_exit();
}

void test_stride_sort (void) {
  int64_t start = timer_ticks();
  set_scheduler(SCHED_STRIDE_SORT);

  int ticket_num[N] = {10, 20, 40, 50, 100};
  int id[N];

  for (int i = 0; i < N; i++)
    id[i] = i;
  
  
  for (int i = 0; i < N; i++) {
    char name[16];

    snprintf (name, sizeof name, "thread %d", i);
    thread_create_stride(name, PRI_DEFAULT, ticket_num[i], thread_func_perf, &id[i]);
  }

  timer_sleep(RUNNING_TIME);
  running = false;

  /* 1) 종료 시간 기록 */
  int64_t end = timer_ticks();
  int64_t elapsed = end - start;

  /* 2) 밀리초(ms)로 환산: elapsed * 1000 / TIMER_FREQ */
  int64_t elapsed_ms = elapsed * 1000 / TIMER_FREQ;

  /* 3) 결과 출력 (정수만 사용) */
  printf("=== Test elapsed: %" PRId64 " ticks (~%" PRId64 " ms) ===\n",
         elapsed, elapsed_ms);

  printf("Stride Performance Result:\n");
  for (int i = 0; i < N; i++)
    printf("thread %d (tickets = %d) ran %d times\n",
           i, ticket_num[i], count_stride_sort[i]);
}


