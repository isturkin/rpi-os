.section .text
.globl main_gradient

main_gradient:
    // 1. Получаем 64-битный адрес структуры Mailbox
    ldr x0, =MailboxBuffer
    
    // 2. Добавляем номер канала 8 (Property Mailbox)
    mov x1, #8
    orr x0, x0, x1
    
    // 3. Базовый адрес Mailbox для Raspberry Pi 5
    ldr x1, =0x1000B880

wait_write:
    ldr w2, [x1, #0x18]     // Status
    tst w2, #0x80000000     // Full?
    bne wait_write
    
    str w0, [x1, #0x20]     // Write
    dsb sy                  // БАРЬЕР ПАМЯТИ: принудительно проталкиваем запись в железо

// 4. Ждем ответа от GPU
wait_read:
    ldr w2, [x1, #0x18]     // Status
    tst w2, #0x40000000     // Empty?
    bne wait_read
    
    ldr w0, [x1, #0]        // Read
    and w2, w0, #0xF        // Проверяем канал
    cmp w2, #8
    bne wait_read

    // 5. Проверяем успешность (0x80000000)
    ldr x0, =MailboxBuffer
    ldr w1, [x0, #4]        
    ldr w2, =0x80000000     
    cmp w1, w2
    bne main_gradient              

    // 6. Получаем указатель на экран
    ldr w1, [x0, #56]       
    and x1, x1, #0x3FFFFFFF // Очищаем верхние биты шины GPU
    cbz x1, main_gradient          

    // 7. Отрисовка 32-битного градиента (1024x768)
    mov x2, #0              // Y
loop_y:
    mov x3, #0              // X

loop_x:
    mov w4, #0              
    and w5, w3, #0xFF       // ИСПРАВЛЕНО: используем w3 вместо x3 (Синий цвет)
    orr w4, w4, w5
    
    and w5, w2, #0xFF       // Зеленый цвет (w2 и w5 оба 32-битные)
    lsl w5, w5, #8          
    orr w4, w4, w5

    str w4, [x1]            // Записываем 4 байта (пиксель ARGB) в память экрана
    add x1, x1, #4          // Сдвигаем указатель на следующий пиксель
    
    add w3, w3, #1          // X++ (используем 32-битный шаг для консистентности)
    cmp w3, #1024
    bne loop_x

stop:
    b stop

.section .data
.balign 16
MailboxBuffer:
// директива .word выделяет в памяти 4 байта и записывает туда значение или адрес
    .word 80           
    .word 0                 
    // ТЕГ 1: Физический размер
    .word 0x00048003        
    .word 8                 
    .word 8                 
    .word 1024              
    .word 768               
    // ТЕГ 2: Виртуальный размер
    .word 0x00048004        
    .word 8                 
    .word 8                 
    .word 1024              
    .word 768               
    // ТЕГ 3: Глубина цвета
    .word 0x00048005        
    .word 4                 
    .word 4                 
    .word 32                
    // ТЕГ 4: Выделение буфера
    .word 0x00040001        
    .word 8                 
    .word 4                 
    .word 16                
    .word 0                 
    // Конец
    .word 0                 
