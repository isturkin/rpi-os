#include <stdlib.h>
#include <stdio.h>

#include "process.h"

// где в ядре Linux хранится список процессов?
// stores in static global space area
static ProcessTable processTable;

Process *addProcess() {
    if (processTable.processCount == MAX_PROCESS_COUNT) {
        return NULL;
    }

    int processPid = processTable.processCount;
    Process newProcess;

    newProcess.pid = processPid;
    newProcess.state = NEW;
    newProcess.priority = 1;

    printf("Process priority after creation: %d\n", newProcess.priority);

    processTable.processes[processPid] = newProcess;
    processTable.processCount++;    
    printf("Process priority after creation next: %d\n", processTable.processes[processPid].priority);
    return &processTable.processes[processPid];
}

ProcessTable *getProcessTable() {
    return &processTable;
}
