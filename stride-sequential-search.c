#include "threads/thread.h"
#include <stdio.h>

#define N 3
#define RUNNING_TIME 100  // ticks (약 1초)

int count_stride[N];
static bool running = true;

static void
thread_func_perf(void *aux) {
  int id = *(int *)aux;
    // 이 줄 추가: 현재 실행 중인 스레드에 ID 기록
  thread_current()->perf_id = id;

  while (running) {

    thread_yield();
  }
}

void test_stride_sequential_search(void) {
  set_scheduler(SCHED_STRIDE_SEQ);

  for (int i = 0; i < N; i++)
    count[i] = 0;

  static int id[N] = {0,1,2};
  thread_create_stride("thread0", PRI_DEFAULT, 10, thread_func_perf, &id[0]);
  thread_create_stride("thread1", PRI_DEFAULT, 20, thread_func_perf, &id[1]);
  thread_create_stride("thread2", PRI_DEFAULT, 40, thread_func_perf, &id[2]);

  timer_sleep(RUNNING_TIME);
  running = false;

  printf("Stride Performance Result:\n");
  for (int i = 0; i < N; i++)
    printf("thread%d (tickets=%d) ran %d times\n",
           i, (i == 0 ? 100 : (i == 1 ? 10 : 1)), count[i]);
}