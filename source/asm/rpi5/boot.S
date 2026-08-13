.section .text
.globl _start

_start:
    // Читаем из системного регистра MPIDR_EL1 номер текущего ядра
    mrs x0, mpidr_el1
    and x0, x0, #0xFF        // В x0 останется только ID ядра (0, 1, 2 или 3)
    
    // Если это ядро 0, переходим к основной программе
    cbz x0, core0_start

core_sleep:
    // Ядра 1, 2, 3 уходят в бесконечный цикл энергосбережения
    wfe
    b core_sleep

core0_start:
    // Только ядро 0 переходит к рисованию градиента
    b main_gradient
