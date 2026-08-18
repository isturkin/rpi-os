.section .text
.globl _start
_start:
    // 1. Получаем адрес структуры
    ldr r0, =FrameBufferInfo

    orr r0, #0xC0000000 // добавляем "шинное смещение", чтобы GPU обратился по корректному адресу
    
    // 2. Добавляем номер канала (1 для Framebuffer)
    // Адрес должен быть выровнен по 16 байт, поэтому последние 4 бита свободны
    add r0, #1 
    
    // 3. Отправляем в Mailbox (Write)
    ldr r1, =0x3F00B880 // Базовый адрес для Mailbox в Raspberry PI 2 Model B
    baseMailboxAddress .req r1
wait_write:
    ldr r2, [baseMailboxAddress, #0x18]       // Читаем Status
    tst r2, #0x80000000       // Проверяем флаг Full
    bne wait_write
    str r0, [baseMailboxAddress, #0x20]       // Пишем во Write-регистр

    // 4. Ждем ответа (Read)
wait_read:
    ldr r2, [baseMailboxAddress, #0x18]       // Читаем Status
    tst r2, #0x40000000       // Проверяем флаг Empty, если бит выставлен, то Z=0
    bne wait_read // Если Z=1, то возвращаемся в wait_read
    ldr r0, [baseMailboxAddress, #0]          // Читаем ответ

    // 5. Рисуем градиент
    ldr r0, =FrameBufferInfo // получаем
    .unreq baseMailboxAddress
    ldr r1, [r0, #32] // Сначала получаем ЧИСТЫЙ адрес памяти экрана от GPU
    teq r1, #0                // Проверяем, не ноль ли (ошибка)
    beq _start

    // Для Raspberry Pi 2 (архитектура ARMv7, включен кэш) 
    // нужно отключить кэширование для указателя экрана дисплея, чтобы изменения сразу отображались.
    // Используем шинный алиас 0x40000000 (или 0xC0000000 в зависимости от настройки MMU)
    // orr r1, #0x40000000
    bic r1, r1, #0xC0000000

    bl SetGraphicsAddress
	
	lastRandom .req r7
	lastX .req r8
	lastY .req r9
	colour .req r10
	x .req r5
	y .req r6
	mov lastRandom,#0
	mov lastX,#0
	mov r9,#0
	mov r10,#0
render$:
	mov r0,lastRandom
	bl Random
	mov x,r0
	bl Random
	mov y,r0
	mov lastRandom,r0

	mov r0,colour
	add colour,#1
	lsl colour,#16
	lsr colour,#16
	bl SetForeColour
		
	mov r0,lastX
	mov r1,lastY
	lsr r2,x,#22
	lsr r3,y,#22

	cmp r3,#768
	bhs render$
	
	mov lastX,r2
	mov lastY,r3
	 
	bl DrawLine

	b render$

	.unreq x
	.unreq y
	.unreq lastRandom
	.unreq lastX
	.unreq lastY
	.unreq colour

.section .data
.balign 16 // выравниваем по 16 байтам
FrameBufferInfo:
    .int 1024  // 0: Ширина физическая
    .int 768   // 4: Высота физическая
    .int 1024  // 8: Ширина виртуальная
    .int 768   // 12: Высота виртуальная
    .int 0      // 16: GPU заполнит: Pitch (байт в строке)
    .int 16     // 20: Глубина цвета (16 бит - High Color)
    .int 0      // 24: X смещение
    .int 0      // 28: Y смещение
    .int 0      // 32: GPU заполнит: Указатель на начало памяти экрана
    .int 0      // 36: GPU заполнит: Размер памяти экрана
