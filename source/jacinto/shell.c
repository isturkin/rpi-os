#include <stdlib.h>
#include <stdio.h>
#include <time.h>

#include "process/process.h"
#include "scheduler/scheduler.h"


int main(int argc, char *argv[]) {
    printf("Starting OS...\n");
    srand(time(NULL)); // initialize "seed" in pseudo-number generator

    Process *newProcess = addProcess();
    printf("New process: %d\n", newProcess->pid);
    printf("New process priority: %d\n", newProcess->priority);
    addForScheduling(newProcess);

    Process *newProcess2 = addProcess();
    printf("New process: %d\n", newProcess2->pid);
    printf("New process priority: %d\n", newProcess2->priority);
    addForScheduling(newProcess2);

    Process *p = scheduleNextProcess();
    printf("\nProcess winner: %d", p->pid);

    printf("\nProcess count: %d", (*getProcessTable()).processCount);
    printf("\nProcess count: %d", (*getProcessTable()).processes[0].pid);
    printf("\nProcess count: %d", (*getProcessTable()).processes[1].pid);
}