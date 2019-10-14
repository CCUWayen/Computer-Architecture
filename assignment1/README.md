# Lab1: R32I Simulator

###### tags: `Computer Architecture`

## souce code
*   ![](https://i.imgur.com/thqCF9a.png)

*   ![](https://i.imgur.com/aIwSJiZ.png)

    ``` =
    .data
    str1: .string " reversei bit is "
    example: .4byte 0x12345678
    shift1: .4byte 0xffff0000
    shift2: .4byte 0xff00ff00
    shift3: .4byte 0xf0f0f0f0
    shift4: .4byte 0xcccccccc
    shift5: .4byte 0xaaaaaaaa

    .text
    main:
        lw a0,example
        jal bitreverse
        lw a1,example
        jal print
        li a0,10
        ecall

    bitreverse:
        lw t3,shift1
        and t1,a0,t3
        srli t1,t1,16
        srli t3,t3,16
        and t2,a0,t3
        slli t2,t2,16
        or t0,t1,t2
        lw t3,shift2
        and t1,t0,t3
        srli t1,t1,8
        srli t3,t3,8
        and t2,t0,t3
        slli t2,t2,8
        or t0,t1,t2
        lw t3,shift3
        and t1,t0,t3
        srli t1,t1,4
        srli t3,t3,4
        and t2,t0,t3
        slli t2,t2,4
        or t0,t1,t2
        lw t3,shift4
        and t1,t0,t3
        srli t1,t1,2
        srli t3,t3,2
        and t2,t0,t3
        slli t2,t2,2
        or t0,t1,t2
        lw t3,shift5
        and t1,t0,t3
        srli t1,t1,1
        srli t3,t3,1
        and t2,t0,t3
        slli t2,t2,1
        or t0,t1,t2
        mv a0,t0
        ret
    print:
        mv t0,a0
        li a0,1 
        ecall
        la a1,str1
        li a0,4
        ecall
        mv a1,t0
        li a0,1
        ecall
        ret
    ```

## **Function Description**
* The function of this code will reverse bit.
* For example 

|  | original | reverse |
| -------- | -------- | -------- |
| HEX     | 0x12345678    | 0x1E6A2C48     |
|Binary|‭0001 0010 0011 0100 0101 0110 0111 1000|0001 1110 0110 1010 0010 1100 0100 1000|
|DEC|‭305419896‬|‭510274632‬|

        
## **Pipeline**

*    Pipeline can increase the output throughput rate. But pipeline has data dependency issue and branch issue. We can use forwarding unit to solve data dependency. But branch issue is more complex than data dependency. So we have two option to solve this problem. One is always take next instruction ,but if it is wrong we will waste two cycle (one cycle if the branch instruction decides to whether branch on ID stage ). Another is add new hardware,that is, branch predict , but branch predict can't solve branch issue completely.


*    Briefly introduce pipeline stage 
        * IF
            * Fetch Instruction according to program counter and write instruction which is from instruction memory into IF/ID register.
            * If load-use happens,we must stall pipeline,because we want to delay next instruction. We must flush instruction and not write next instruction counter into program counter and we can't write flush instruction into IF/ID register in order to ensure we can get previous instruction which unexecuted.
            * If branch error happens, we just flush instruction,because the wrong instruction count go into program counter,and we will get error instruction. So we just flush instruction and let it go into IF/ID register.
        * ID
            * Decoder Instruction which come from IF/ID register.
            * If load-use happenes, we don't write the result which come from decoding instruction. Because after decoding instruction ,we find the data which we need is not prepare,we need wait one cycle. After we wait one cycle, the data which we need is forwarding to EXE stage,and this instruction will also move to EXE stage. So we can get correct data.
            * If branch error happens, we don't write the result which come frm decoding instruction. Because this instruction is error, we can't let it move to next stage.
        * EXE
            * In this stage, we just execute the instruction according to instruction opcode and func3.
            * If data dependency happens, we just forwarding data which previous instructions execute result to this stage. 
            * And in this stage we will check load-use,data dependency or branch whether happen.
        * MEM
            * This stage will store the result which executed into memory,get data from memory or go to next stage, according to instruction opcode.
            * This stage can forwarding data to EXE stage,if data dependency  exists in MEM stage and EXE stage.
        * WB
            * This stage will write the result into register file.
            * This stage can forwarding data to EXE stage,if data dependency  exists in WB stage and EXE stage.
* Introduce the bitreverse
    * **Observed instruction 13** 
        ``` =13
            jal bitreverse
            lw a1,example
            jal print
        ```
        * when execute instruction 13 ,the next instruction 13 and 14 will enter pipeline.But we don't need to execute the instruction after instruction 13. We need to execute instruction 19 after executing instruction 13. So we must stall the pipeline in order to ensure the sequence of instruction is correct.
        ![](https://i.imgur.com/DkzP6dm.png)
        ![](https://i.imgur.com/M8rRmFU.png)
        ![](https://i.imgur.com/dsAltjt.png)
        * According to above Figure,when decide whether branch on EXE stage, we must throw out two instructions.And one instruction will be replaced by nop instruction, and another instruction will never move to next stage and will be replaced by next instruction.
    * **Observed instruction 19 and 20**
        ``` =19
            lw t3,shift1
            and t1,a0,t3
            srli t1,t1,16
        ```
        * it exists load-use , so we must stall one cycle.
        ![](https://i.imgur.com/H5Sw8bQ.png)
        ![](https://i.imgur.com/4bj4EiH.png)
        * when lw instruction on EXE stage, hazard controller will find load-use between lw instruction and and instruction. So it will post signal to inform IF stage don't write next instruction counter into Program Counter,prevent current instruction on IF stage and instruction count  go into IF/ID stage and to inform ID stage flush the IF/EXE register.
        ![](https://i.imgur.com/WHMSZnb.png)
        ![](https://i.imgur.com/6aj1IWJ.png)
        ![](https://i.imgur.com/oFGjmL2.png)
        ![](https://i.imgur.com/EdVs6SD.png)

## *Problem* 
* I don't know how to print next line in Ripes and print integer in hex format 
