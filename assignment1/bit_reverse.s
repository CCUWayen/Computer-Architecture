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
