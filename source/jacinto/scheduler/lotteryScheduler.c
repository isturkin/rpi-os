#include <stdlib.h>
#include <stdio.h>

#include "scheduler.h"

#define TICKETS_COUNT 100

static int random_in_range(int A, int B);

// local for use only in this file
static int ticketsToPids[TICKETS_COUNT];

void addForScheduling(Process *p) {
    int ticketsCount = random_in_range(0, TICKETS_COUNT);
    printf("\nTicket number %d will get %d tickets\n", p->pid, ticketsCount);
    for (int i = 0; i < ticketsCount; i++) {
        int ticketNumber = random_in_range(0, TICKETS_COUNT);
        printf("Process will get %d ticket number\n", ticketNumber);
        ticketsToPids[ticketNumber] = p->pid;
    }
}

Process *scheduleNextProcess() {
    ProcessTable *ps = getProcessTable();
    int ticketWinner = random_in_range(0, TICKETS_COUNT);

    printf("\nTicket winner: %d", ticketWinner);
    int pidWinner = ticketsToPids[ticketWinner];
    return ps->processes[pidWinner];
}

static int random_in_range(int A, int B) {
    int random = rand();
    return A + random % (B - A + 1);
}