BINS= setup test

CROSS_COMPILE = riscv-none-embed-
link=linker.ld

ifeq (${OP},1)
RV32I_CFLAGS = -march=rv32i -mabi=ilp32 -O3 -nostdlib
else
RV32I_CFLAGS = -march=rv32i -mabi=ilp32 -nostdlib
endif

start:$(BINS)
	./emu-rv32i test

test: test.c setup.o
	$(CROSS_COMPILE)gcc -w  $^ $(RV32I_CFLAGS) -T$(link) -o $@ 

setup: setup.s
	$(CROSS_COMPILE)gcc $(RV32I_CFLAGS) -c $<

S:test.c
	$(CROSS_COMPILE)gcc -w $(RV32I_CFLAGS) $^ -S

.PHONY: clean

clean:
	rm setup.o test
	

