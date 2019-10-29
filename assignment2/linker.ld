OUTPUT_ARCH( "riscv" )

_STACK_SIZE = DEFINED(_STACK_SIZE) ? _STACK_SIZE : 0x1000;

/*****************************************************************************
 * Define memory layout
 ****************************************************************************/
MEMORY {
  mem  : ORIGIN = 0x00000000, LENGTH = 0x00000100
  imem : ORIGIN = 0x00000100, LENGTH = 0x00010000
}

/* Specify the default entry point to the program */

ENTRY(_start)

/*****************************************************************************
 * Define the sections, and where they are mapped in memory 
 ****************************************************************************/
SECTIONS {
  .comment : {
   *(.comment);
   *(.comment.*);
  } > mem 

  .text : {
    setup.o(.text);
    *(.text);
    *(.text.*);
  } > imem

  .data : {
    . = ALIGN(4);
    __data_start = .;
    *(.data)
    *(.data.*)
    *(.gnu.linkonce.d.*)
    __data_end = .;
  } > imem

  .stack : {
    . = ALIGN(4);
    _stack_end = .;
    . += _STACK_SIZE;
    _stack = .;
    __stack = _stack;
  } > imem

}
