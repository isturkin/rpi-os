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
    PageTable pageTable;
} Process;

void run(int *entryPoint);

Process *addProcess();

ProcessTable *getProcessTable();

// virtual address = VPN(virtual page number) -> physical Page Frame + page offset
typedef struct pageTableEntry {
    int physicalPageFrame;
} PageTableEntry;

typedef struct pageTable {
    PageTableEntry pageTable[100];
} PageTable;

#define MAX_PROCESS_COUNT 10

typedef struct processTable {
    Process processes[MAX_PROCESS_COUNT];
    int processCount;
} ProcessTable;

#endif
