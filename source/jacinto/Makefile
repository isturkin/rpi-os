build:
	gcc ./process/process.c ./scheduler/lotteryScheduler.c shell.c -o build/shell

clean:
	rm -rf build/*

rebuild:
	make clean
	make build -B

run:
	./build/shell