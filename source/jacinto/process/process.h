#ifndef H_PROCESS
#define H_PROCESS

enum ProcessState {
    NEW,
    READY_TO_EXECUTION,
    TERMINATED
};

typedef struct process {
    int pid;
    enum ProcessState state;
    int priority;
} Process;

#define MAX_PROCESS_COUNT 10

typedef struct processTable {
    Process *processes[MAX_PROCESS_COUNT];
    int processCount;
} ProcessTable;

Process *addProcess();

ProcessTable *getProcessTable();

#endif
