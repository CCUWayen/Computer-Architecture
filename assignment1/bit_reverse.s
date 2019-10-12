.data
example: .4byte 0x12345678
shift1: .4byte 0xffff0000
shift2: .4byte 0x0000ffff
shift3: .4byte 0xff00ff00
shift4: .4byte 0x00ff00ff
shift5: .4byte 0xf0f0f0f0
shift6: .4byte 0x0f0f0f0f
shift7: .4byte 0xcccccccc
shift8: .4byte 0x33333333
shift9: .4byte 0xaaaaaaaa
shift10: .4byte 0x55555555

.text
main:
    lw a0,example
    jal bitreverse

bitreverse:
    lw t0,shift1
    and t0,t0,a0
    srli t0,t0,16
    lw t1,shift2
    and t1,t1,a0
    slli t1,t1,16
    or t0,t0,t1
    lw t1,shift3
    and t1,t1,t0
    srli t1,t1,8
    lw t2,shift4
    and t2,t2,t0
    slli t2,t2,8
    or t0,t1,t2
    lw t1,shift5
    and t1,t1,t0
    srli t1,t1,4
    lw t2,shift6
    and t2,t2,t0
    slli,t2,t2,4
    or t0,t1,t2
    lw t1,shift7
    and t1,t1,t0
    srli t1,t1,2
    lw t2,shift8
    and t2,t2,t0
    slli t2,t2,2
    or t0,t1,t2
    lw t1,shift9
    and t1,t1,t0
    srli t1,t1,1
    lw t2,shift10
    and t2,t2,t0
    slli t2,t2,1
    or t0,t1,t2
    mv a0,t0
    ret
