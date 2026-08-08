ASSEMBLER = arm-none-eabi-as
LINKER = arm-none-eabi-ld

BUILD_FOLDER = build

assemble:
	echo "$(ASSEMBLER)"
	$(ASSEMBLER) ./main.s -o $(BUILD_FOLDER)/main.o

link:
	$(LINKER) $(BUILD_FOLDER)/main.o -o $(BUILD_FOLDER)/program.elf

build: assemble link