# Naor Nahman 207829185
.data
.align      8
.section    .rodata
.jumptable:
    .quad .case31
    .quad .case32or33
    .quad .case32or33
    .quad .invalidcase
    .quad .case35
    .quad .case36
    .quad .case37
format_int: .string "%d"
case31_first: .string "first pstring length: %d, "
case31_second: .string "second pstring length: %d\n"
case32or33_char: .string "%s"
case32or33_oldChar: .string "old char: %c, "
case32or33_newChar: .string "new char: %c, "
case32or33_first: .string "first string: %s, "
case32or33_second: .string "second string: %s\n"
case35_length: .string "length: %d, "
case35_str: .string "string: %s\n"
case37_str: .string "compare result: %d\n"

case31str: .string "case31\n"
case32or33str: .string "case32or33\n"
case35str: .string "case35\n"
case36str: .string "case36\n"
case37str: .string "case37\n"
invalidcasestr: .string "invalid option!\n"



.text
.globl run_func
.type run_func,@function
.extern pstrlen,replaceChar,pstrijcpy,swapCase,pstrijcp
run_func:
    # rsi=pstring1
    # rdi=pstring2
    # rdx=menu option
    #switch case :
    push    %rbx             # push %rbx callee - vaule will be save after calling funcs
    movq    %rdx, %rbx       # move the argument into a register
    subq    $31,%rbx        #sub the lowest case - to get ready to switch case table/
    cmpq    $6,%rbx         # check if the number the user entered is bigger than 37
    ja      .invalidcase    # mean that the number the user entered is bigger than 37-error
    jmp     *.jumptable(,%rbx,8) #8*rbx jump according to jumptable, %rbx is the amout  and every jump is 8 bytes
.case31:
    #print first length
    movq %rdi,%rbx      #save second pstring
    movq %rsi,%rdi      #send argument to pstrlen function
    call pstrlen
    movq %rax,%rsi      # sending the return vaule to rsi(first argument to printf)
    movq $case31_first,%rdi     #sending format of printf
    xor %rax,%rax
    call printf
    #print second length
    movq %rbx,%rdi      #sending the &pstring second to rdi first arguments to pstrlen
    call pstrlen
    movq %rax,%rsi      #return vaule to rsi - argument to printf
    movq $case31_second,%rdi    #sending the format of printf
    xor %rax,%rax
    call printf
    jmp     .end_switch       # jump to the end of the switch statement
.case32or33:
        push %rbp
        movq %rsp,%rbp
        subq $16,%rsp
        pushq %r12  #old char
        pushq %r13  # new char
        pushq %r14  # second pstring
        movq %rsi,%rbx  # first pstring
        movq %rdi,%r14  #second pstring
        #old char
        mov $case32or33_char,%rdi
        leaq -8(%rbp),%rsi  # old char
        xor %rax,%rax
        call scanf
        movzbq -8(%rbp),%r12
        #new char
        mov $case32or33_char,%rdi
        leaq -16(%rbp),%rsi  # old char
        xor %rax,%rax
        call scanf
        movzbq -16(%rbp),%r13
        # print the old and new char
        movq %r12,%rsi      #%r12 is old char argument to printf
        movq $case32or33_oldChar,%rdi    #sending the format of printf
        xor %rax,%rax
        call printf
        movq %r13,%rsi      #%r13 is new char- argument to printf
        movq $case32or33_newChar,%rdi    #sending the format of printf
        xor %rax,%rax
        call printf
        # first string replaceChar
        movq %rbx,%rdi  #first argum to replaceChar =pstring
        movq %r12,%rsi  #old char - second argum
        movq %r13,%rdx  # new char - third argum
        call replaceChar
        movq %rax ,%rbx
        #print first string
        addq $1,%rbx    #skip the legnth
        movq %rbx,%rsi      #%rbx  is the string
        movq $case32or33_first,%rdi    #sending the format of printf
        xor %rax,%rax
        call printf
        # second string replaceChar
        movq %r14,%rdi  #first argum to replaceChar =pstring
        movq %r12,%rsi  #old char - second argum
        movq %r13,%rdx  # new char - third argum
        call replaceChar
        movq %rax ,%r14
        #print second string
        addq $1,%r14    #skip the length
        movq %r14,%rsi
        movq $case32or33_second,%rdi
        xor %rax,%rax
        call printf
        #end
        pop %r14
        pop %r13
        pop %r12
        addq $16,%rsp
        movq %rbp,%rsp
        pop %rbp
    jmp     .end_switch       # jump to the end of the switch statement

.case35:
        push %rbp
        movq %rsp,%rbp
        subq $280,%rsp   # 24+256 because i want to save the first pstring length in the stack and scanf must be 16x
        push %r12
        push %r13
        push %r14
        push %r15
        movq %rsi,%rbx  # first pstring
        movq %rdi,%r13  #second pstring
        movq %r13,-280(%rbp)    #saving the address of the second pstring=src in -280rbp
        movzbq (%rbx),%r12  # legnth of first pstring
        movq %r12,-16(%rbp) # saving in the stack the first pstring length
        movzbq (%r13),%r15 # length of second pstring
        movq %r15,-24(%rbp) #saving the length of the second pstring in the stack
        #input first index=i
        leaq -4(%rbp),%rsi
        movq $format_int,%rdi
        xor %rax,%rax
        call scanf
        # second index=j
        leaq -8(%rbp),%rsi
        movq $format_int, %rdi
        xor %rax,%rax
        call scanf
        # call strcpy
        movq %rbx,%rdi  #first pstring
        movq %r13,%rsi  #second pstring
        movl -4(%rbp),%edx # i
        movl -8(%rbp),%ecx # j
        call pstrijcpy
        movq %rax,%r14  # save return in r14
        #print length
        movq $case35_length,%rdi
        movq -16(%rbp),%rsi  # r12 is the length of pstring 1
        xor %rax,%rax
        call printf
        # print new string
        movq $case35_str,%rdi
        addq $1,%r14    #skip length
        movq %r14,%rsi
        xor %rax,%rax
        call printf
        #print length
        movq $case35_length,%rdi
        movq -24(%rbp),%rsi  # r12 is the length of pstring 1
        xor %rax,%rax
        call printf
        # print src string
        movq $case35_str,%rdi
        movq -280(%rbp),%r13    # address to second pstrin=src is saved in -280rbp
        addq $1,%r13    #skip length
        movq %r13,%rsi
        xor %rax,%rax
        call printf
        # finish
        pop %r15
        pop %r14
        pop %r13
        pop %r12
        addq $24,%rsp
        movq %rbp,%rsp
        pop %rbp
    jmp     .end_switch       # jump to the end of the switch statement
.case36:
    push %rbp
    movq %rsp,%rbp
    push %r12
    push %r13
    push %r14
    movq %rsi,%rbx  #first pstring
    movq %rdi,%r12  #second pstring
    movzbq (%rbx),%r13  # legnth of first pstring
    movzbq (%r12),%r14  # legnth of second pstring
    #first pstring swap
    movq %rbx,%rdi
    call swapCase
    movq %rax,%rbx  #return vaule -> rbx - the new pstring after swapcase
    #print length
    movq $case35_length,%rdi    #same format as case 35
    movq %r13,%rsi  # r13 is the length of pstring 1
    xor %rax,%rax
    call printf
    # print new string
    movq $case35_str,%rdi
    addq $1,%rbx    #skip length
    movq %rbx,%rsi
    xor %rax,%rax
    call printf
    #seond pstring swap
    movq %r12,%rdi
    call swapCase
    movq %rax,%r12  #retunr vaule -> rbx - the new pstring after swapcase
    #print length
    movq $case35_length,%rdi    #same format as case 35
    movq %r14,%rsi  # r14 is the length of pstring 2
    xor %rax,%rax
    call printf
    # print new string
    movq $case35_str,%rdi   #same format as case 35
    addq $1,%r12    #skip length
    movq %r12,%rsi
    xor %rax,%rax
    call printf
    #end
    pop %r14
    pop %r13
    pop %r12
    movq %rbp,%rsp
    pop %rbp
    jmp .end_switch
.case37:
    push %rbp
    movq %rsp,%rbp
    subq $24,%rsp   # 24 because i want to save the first pstring length in the stack and scanf must be 16x
    push %r12
    push %r13
    push %r14
    push %r15
    movq %rsi,%rbx  # first pstring
    movq %rdi,%r15  #second pstring
    movzbq (%rbx),%r12  # legnth of first pstring
    movq %r12,-16(%rbp) # saving in the stack the first pstring length
    movzbq (%r15),%r13  # length of second pstring
    #input first index=i
    leaq -4(%rbp),%rsi
    movq $format_int,%rdi
    xor %rax,%rax
    call scanf
    # second index=j
    leaq -8(%rbp),%rsi
    movq $format_int, %rdi
    xor %rax,%rax
    call scanf
    # call strcmp
    movq %rbx,%rdi  #first pstring
    movq %r15,%rsi  #second pstring
    movl -4(%rbp),%edx # i
    movl -8(%rbp),%ecx # j
    call pstrijcmp
    movq %rax,%r14  # save return in r14
    #print length
    movq $case37_str,%rdi
    movq %r14,%rsi  # r14 is the return vaule from pstrijcmp
    xor %rax,%rax
    call printf
    # finish
    pop %r15
    pop %r14
    pop %r13
    pop %r12
    addq $24,%rsp
    movq %rbp,%rsp
    pop %rbp
    jmp .end_switch
.invalidcase:

        mov $invalidcasestr,%rdi
        xor %rax,%rax
        call printf

.end_switch:
    pop %rbx
    ret                      # return from the function
