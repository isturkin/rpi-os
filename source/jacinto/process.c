#include <stdlib.h>
#include "process.h"

struct process *addProcess(int pid) {
    struct process *newProcess = malloc(sizeof(struct process));
    processTable.processes[0] = newProcess;
    return newProcess;
}

struct process_table getProcessTable() {
    return processTable;
}