
.globl sqrt

sqrt:
  movl $0,%eax
  movl $15,%edx     #  %edx set to 15 as a loop counter
  movl $256,%esi    # set %esi to 256 for xor operation
  movl $0,%ecx      # a scratch register working as a temporary variable for manipulation without changing the value


loop:
  cmpl $0,%edx     # The condition for ending the loop
  jle endline

  decl %edx         #decrementing the counter of the loop

  shr $1,%esi      #shift to the right by one to  change specific bit 
  XORl %esi,%eax   #change the kth bit to 1

  movl %eax,%ecx   #use scratch variable to test multipication without changing the result

  imul %ecx,%ecx  #Square it  and compare with ">x"
  cmpl %edi,%ecx
  jg great       #jump to great than if condition is true

  jmp loop
great:
  XORl %esi,%eax   #switch back the bit from 1 to 0 
  jmp loop

endline:
  ret              #returning the value