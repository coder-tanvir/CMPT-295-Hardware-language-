.string1:
	.string "Please enter your name: "
.string2:
	.string "Thank you %s!\n"
.string3:
	.string "Please enter your year of birth: "
.string4:
	.string "%s! is not a valid year.\n"

	.globl get_age
get_age:
	push %rbx
	push %rbp              # callee saved registers

	                       # local variables:
	leaq -8(%rsp), %rsp    #   - endptr
	leaq -24(%rsp), %rsp   #   - name_str[24]
	leaq -24(%rsp), %rsp   #   - year_of_birth[24]
	mov %rsp, %rbp

	movq $.string1, %rdi
	xorl %eax, %eax
	call printf            # printf("Please enter your name: ");

	leaq 24(%rbp), %rdi
	call gets              # gets(name_str);

	movq $.string2, %rdi
	leaq 24(%rbp), %rsi
	xorl %eax, %eax
	call printf            #printf("Thank you %s!\n")

Timeloop:
	movq $.string3, %rdi     #printf("Please enter your year of birth: ")
	xorl %eax, %eax
	call printf

	leaq (%rbp), %rdi        #gets(year_of_birth)
	call gets

	leaq (%rbp), %rdi
	leaq 56(%rbp), %rsi
	movq $0, %rdx
	leaq (%rbp), %rdi
	call strtol              #gets the decimal version of the year of birth

	cmpl $1900, %eax
	jb wrong
	cmpl $2014, %eax
	ja wrong                  #checks if the year is in the correct range

	movq $2017, %rcx
	subq %rax, %rcx
	movq %rcx, %rax          #gives your minimum age and stores it in rax
	jmp end

wrong:
	movq $.string4, %rdi
	leaq (%rbp), %rsi
	xorl %eax, %eax
	call printf              #printf("%s! is not a valid year.\n")
	jmp Timeloop             #returns to the loop if the year is outside of the range

end:
	leaq 56(%rsp), %rsp
	pop %rbp
	pop %rbx                 #sets the rsp and rbp back to the original position
	ret