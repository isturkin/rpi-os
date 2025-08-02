#include <stdio.h>
#include "process.h"


int main(int argc, char *argv[]) {
    printf("Starting OS...\n");
    printf("Processes: %d", getProcessTable().processes[0]->pid);
}