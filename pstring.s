 #Naor Nahman 207829185
    .data
    .section .rodata
    invalid_case_print: .string "invalid input!\n"
    .text
    .globl pstrlen,replaceChar,pstrijcpy,swapCase,pstrijcmp
    .type pstrlen ,@function
pstrlen:
    # the &pstring is in rdi.
    movzbq (%rdi),%rax # move only byte that represent the length and in the other bytes put 000000.
    ret
    .type replaceChar,@function
replaceChar:
    # rdi=pstring , rsi=oldchar , rdx=newchar
    #set up
    push %rbp
    movq %rsp,%rbp
    subq $16,%rsp
    push %r12 #callee save- to save the length of the string
    movzbq (%rdi),%r12  # same as pstrlen function - get the length of the pstring will be the counter of the loop
    push %r13 #callee save - the pstring
    movq %rdi,%r13
    addq $1,%r13  # now the r13 is the string without the length
    push %r14   # oldchar
    movq %rsi,%r14
    push %r15   #new char
    movq %rdx,%r15
    movq %r12,-8(%rbp)  #saving the length of pstring
    #starting loop
.loop:
    testq %r12,%r12     # check if %r12 is 0, r12 is the length of the string=the x-times we need to run the loop
    je  .end
    movzbq (%r13),%rbx #rbx is the last char
    cmp %rbx,%r14 # check if the last char of the string is the old char we need to change
    je .swapChars
    subq $1,%r12    #decrease the counter
    addq $1,%r13    # move to next char
    jmp .loop
.swapChars:
    mov %r15b,(%r13) # r15 is the new char- so take the last byte and swap it with the last byte of our string.
    subq $1,%r12    #decrease the counter
    addq $1,%r13    # move to next char
    jmp .loop
.end:
    movq -8(%rbp),%r10  # the length
    subq %r10,%r13 # we need to return the new string so we need to go down in bytes r10 times
    subq $1,%r13    # 1 more byte down because of the length of the string- now its the full pstring
    movq %r13,%rax  # return vaule
    pop %r15
    pop %r14
    pop %r13
    pop %r12
    addq $16,%rsp
    movq %rbp,%rsp
    pop %rbp
    ret

    .type pstrijcpy,@function
pstrijcpy:
    # rdi = dest , rsi = src, rdx=i,rcx=j
    push %rbp
    movq %rsp,%rbp
    subq $16,%rsp
    movq %rcx,-8(%rbp)
    push %r12   # dest
    push %r10   # src
    push %r14   # i
    push %r15   # j
    # all callee registers- wont change after a func call
    movq %rdi,%r12  # dest
    movq %rsi,%r13  # src
    movq %rdx,%r14  # i
    movq %rcx,%r15  # j
    leaq (%rdi),%rbx    # saving the address of the dest
    # check if i and j is not out of range
    movzbq (%r12),%r10  # legnth of dest
    cmp %r15,%r10   # %r10 : %r15 -> dest length : j
    jl .invalid_case
    je .invalid_case    # if equal is invalid too because the first index of the string is 0
    movzbq (%r13),%r11   # length of src
    cmp %r15,%r11
    jl .invalid_case
    je .invalid_case    # if equal is invalid too because the first index of the string is 0
    #check if i>j
    cmp %r14,%r15   # r15:r14 --- j:i
    jb .invalid_case
    #copy
    addq $1,%r12    #skip length
    addq $1,%r13    # skip length
    addq %r14,%r12  #jump to i index
    addq %r14,%r13  #jump to i index
    #loop that running from index i to j
    subq %r14,%r15 # j-i = the counter of the loop (j include so next line will be +1)
    addq $1,%r15    # read line above
.loopcpy:
    testq %r15,%r15
    je .endcpy
    movzbq (%r13),%rax  # last byte of src- mean the last char into rax
    movb   %al,(%r12)   # swap into last byte of dest
    subq $1,%r15    # conter --
    addq $1,%r13    # move next char
    addq $1,%r12    #move next char
    call .loopcpy
.invalid_case:
    movq $invalid_case_print,%rdi
    mov $0,%rax
    call printf
    jmp .endcpy
.endcpy:
    subq -8(%rbp),%r13  # r13 to his start address
    subq $2,%r13    # go back to his pstring with the length -2 because i did +1 before because j include
    movq %rbx,%rax  #rbx is the address of the dest that we saved at the start-rax return value
    pop %r15
    pop %r14
    pop %r10
    pop %r12
    addq $16,%rsp
    movq %rbp,%rsp
    pop %rbp
    ret

    .type swapCase,@function
swapCase:
    #rdi= pstring
    push %rbp
    movq %rsp,%rbp
    push %r12
    push %r13
    movq %rdi,%r12  # saving the address of the pstring
    movq %r12,%rbx  #saving the pstring in rbx
    movzbq (%r12),%r13  #the length of the pstring
    addq $1,%rbx    # skip the length
.loopSwapCase:
    testq %r13,%r13
    je .endloopSwapCase
    # check if last char is a-z -lower case
    movzbq (%rbx),%rax  # rax is the last char of the string
    cmpq $96,%rax   # char : 96 , 'a'=97 in asci
    jg  .checklowerz    #jump if char>96
    #means that char <= 96 in ascii
    # check if Bigger case
    cmpq $64,%rax # char : 64
    jg .checklowerZ #jump if char>64
    subq $1,%r13    # counter --
    addq $1,%rbx    # check next char
    jmp .loopSwapCase
.checklowerZ:
    cmpq $91,%rax   # 90 in asci is Z so check if lower than 91- if yes it is a Bigger Case, char : 91
    jl .swapBiggerLower #jump if char<91 (and we know char>64 so char is Bigger case)
    subq $1,%r13
    addq $1,%rbx
    jmp .loopSwapCase
.swapBiggerLower:
    addq $32,%rax   # bigger case to lower case
    movb %al,(%rbx)
    subq $1,%r13
    addq $1,%rbx
    jmp .loopSwapCase
.checklowerz:
    #check if char is lower than after we check is bigger or equals to a
    cmpq $123,%rax  # check if lower than 'z'=122 in asci , char : 123
    jl .swapLowerBigger #jump if char<123
    subq $1,%r13
    addq $1,%rbx
    jmp .loopSwapCase
    #swap from lower case to bigger case
.swapLowerBigger:
    subq $32,%rax   # lower case to bigger case'
    movb %al,(%rbx) #move currect char in bigger case to last byte of rbx-the string
    subq $1,%r13  # counter --
    addq $1,%rbx    # moving to the next char
    jmp .loopSwapCase
.endloopSwapCase:
    movq %r12,%rax  #rbx is the address of the pstring that we saved at the start ,rax return value
    pop %r13
    pop %r12
    movq %rbp,%rsp
    pop %rbp
    ret
    .type pstrijcmp,@function
pstrijcmp:
 # rdi = pstr 1 , rsi = pstr2, rdx=i,rcx=j
    push %rbp
    movq %rsp,%rbp
    push %r12   # pstr1
    push %r13   # pstr2
    push %r14   # i
    push %r15   # j
    # all callee registers- wont change after a func call
    movq %rdi,%r12  # pst1
    movq %rsi,%r13  # pst2
    movq %rdx,%r14  # i
    movq %rcx,%r15  # j
    # check if i and j is not out of range
    movzbq (%r12),%r10  # legnth of dest
    cmp %r15,%r10   # %r10 : %r15 -> dest length : j
    jl .invalid_casecmp
    je .invalid_casecmp  # if equal is invalid too because the first index of the string is 0
    movzbq (%r13),%r11   # length of src
    cmp %r15,%r11
    jl .invalid_casecmp
    je .invalid_casecmp    # if equal is invalid too because the first index of the string is 0
    cmp %r14,%r15   # r15:r14 --- j:i
    jb .invalid_casecmp
    #copy
    addq $1,%r12    #skip length
    addq $1,%r13    # skip length
    addq %r14,%r12  #jump to i index
    addq %r14,%r13  #jump to i index
    #loop that running from index i to j
    subq %r14,%r15 # j-i = the counter of the loop (j include so next line will be +1)
    addq $1,%r15    # read line above
.loopcmp:
    testq %r15,%r15
    je .equalReturn0
    movzbq (%r12),%rax  # last byte of pst1- mean the last char into rax
    movzbq (%r13),%rcx  #last byte of pst2 - the last char into rcx
    cmpq %rax,%rcx  # cmp rcx:rax
    jg .pstr2bigger
    jl .pstr1bigger
    subq $1,%r15    # conter --
    addq $1,%r13    # move next char
    addq $1,%r12    #move next char
    call .loopcmp
.equalReturn0:
    xor %rax,%rax
    jmp .endcmp
.pstr1bigger:
    movq $1,%rax
    jmp .endcmp
.pstr2bigger:
    movq $-1,%rax
    jmp .endcmp
.invalid_casecmp:
    movq $invalid_case_print,%rdi
    xor %rax,%rax
    call printf
    movq $-2,%rax
    jmp .endcmp

.endcmp:
    pop %r15
    pop %r14
    pop %r13
    pop %r12
    movq %rbp,%rsp
    pop %rbp
    ret










