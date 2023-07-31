# Naor Nahman 207829185
.align      16
.section .rodata
format_int:   .string     "%d"
format_string:  .string     "%s"


.text
.globl run_main
.extern run_func
.type run_main, @function
run_main:
    push %rbp
    movq %rsp, %rbp
    sub $256, %rsp # 256 byths for pstring
    pushq %rbx      # callee save first pstring
    pushq %r12      # callee save second pstring
    # first length for first pstring
    movq $format_int,%rdi
    leaq -264(%rbp),%rsi #
    xor %rax,%rax # 0 -> rax
    call scanf
    # first pstring
    leaq -256(%rbp),%rbx # first pstring in -256(%rpb)
    addq $1,%rbx         # saving the first byte for the length
    movq $format_string, %rdi # first parameter scanf
    movq %rbx, %rsi           # second parameter to scanf
    xor %rax, %rax
    call scanf
    mov -264(%rbp),%eax # putting the length of pstring 1 in rax
    mov %al,-256(%rbp) # taking the last byte of rax (the length) and putting it in -256(%rsp)
    #pstring start -256
     # second length for first pstring
     sub $256,%rsp
     movq $format_int,%rdi
     leaq -272(%rbp),%rsi # -272(%rbp) is the r12 reg that i pushed before(right after rbx)
     xor %rax,%rax # 0 -> rax
     call scanf
     # first pstring
     leaq -528(%rbp),%r12 # second pstring in -528(%rpb)-because last rsp was -272 from rbp and i sub -256 so 256+272=528
     addq $1,%r12         # saving the first byte for the length
     movq $format_string, %rdi # first parameter scanf
     movq %r12, %rsi           # second parameter to scanf
     xor %rax, %rax
     call scanf
     mov -272(%rbp),%eax # putting the length of pstring 2 in rax
     mov %al,-528(%rbp) # taking the last byte of rax (the length) and putting it in -528(%rsp)
     # input the menu option
     movq $format_int,%rdi    # first parameter to scanf
     leaq -264(%rbp),%rsi        #second parameter to scanf,using address that i dont need anymore
     xor %rax,%rax
     call scanf
     #call to run_func
     leaq -528(%rbp),%rdi   #first argument-first pstring
     leaq -256(%rbp),%rsi   #second argument-second pstring
     mov -264(%rbp),%rdx    #third argument-the menu option
     xor %rax,%rax
     call run_func
    #return from run_func
    addq $256,%rsp
    popq %r12
    popq %rbx
    addq $256,%rsp
    movq %rbp, %rsp
    popq %rbp
    xorq %rax, %rax
    ret
