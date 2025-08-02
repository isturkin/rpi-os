#ifndef H_PROCESS
#define H_PROCESS

enum ProcessState {
    NEW,
    PLANNED,
    TERMINATED
};

struct address_space {
    unsigned int *startAddress;
    int pagesNum;
};

struct process {
    int pid;
    enum ProcessState state;
    struct address_space addressSpace;
};

struct process_table {
    struct process *processes[100];
};

struct process *addProcess(int pid);
struct process_table getProcessTable();

extern struct process_table processTable;

#endif