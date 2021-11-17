.globl sum_float

# var map:
#   %xmm0:  total
#   %rdi:   F[n] (base pointer)
#   %rsi:   n
#   %rbp:   endptr

#I'm getting seg fault, not sure why, my idea should work to be fine
sum_float:
movq %rsp,%r15

xorps	%xmm0, %xmm0
xorps %xmm1,%xmm1																	#intended for x
xorps %xmm2,%xmm2																	#intended for y

movq $1,%r11
movq $0,%r12																			# value to keep track the of length of queue

push %rdi																					#push first value to queue
leaq 16(%rsp,%r12,8),%rsp													#set %rsp to current head => I did a unit test and this formula worked for some reason


addq $4,%rdi																			#set head(F) to next value

loop:
cmpq	%rsi, %r11
jg endloop
cmpq $0,%r12																			#check if sentinel value is 0 => is queue empty? if yes jump to ifemptyx label
jle ifemptyx

movss (%rsp),%xmm3																#%xmm3 => head(Q)
movss (%rdi),%xmm4																#%xmm4 => head(F)
subss %xmm3,%xmm4																	#subtract two values and compare the answer with zero to see which one is larger

xorps %xmm6,%xmm6																	#move 0 into a xmm register to compare with floating point value
ucomiss %xmm6,%xmm4
jge qpopx																					#if head(F)>=head(Q) jump to qpopx label
addq $4,%rdi																			#else update head(F)
movq %xmm4,%xmm1																	#x => previous head(F)

ifemptyx:
movss (%rdi),%xmm1																#if queue is empty then set x to head(F)
addq $4,%rdi
jmp contloop0																			#continue loop as you would in c

qpopx:
decq %r12																					#decrement sentinel value as the queue is shorter now
leaq 8(%rsp),%rsp																	#calculate the next head of the queue
movq %xmm3,%xmm1																	#xmm3 holds head(Q), move it to xmm1 (x)
jmp contloop0																			#continue loop as you would in c

contloop0:
cmpq $0,%r12																			#check if queue is empty 
jle ifemptyy
                                                  #start process for y same as done previously so i'm not gonna comment
movss (%rbx),%xmm3																#%xmm3 => head(Q)
movss (%rdi),%xmm4																#%xmm4 => head(F)
movss (%rdi),%xmm4
subss %xmm3,%xmm4

xorps %xmm6,%xmm6
ucomiss %xmm6,%xmm4
jge qpopy
addq $4,%rdi
movq %xmm4,%xmm2
jmp contloop1

qpopy:																						#similar to qpopx 
decq %r12
leaq 8(%rsp),%rsp
movq %xmm3,%xmm2
jmp contloop1																		#continue loop as in c

ifemptyy:																					#jumped from contloop0
movss (%rdi),%xmm2
addq $4,%rdi
jmp contloop1

contloop1:
incq %r12																				#continue rest of the loop, increment sentinel value r12 because
addss %xmm1,%xmm2																#we are going to push the sum of the floats
movq %xmm2,%rax
push %rax
incq %r11          #incrementing r11
jmp loop           #jumping to the loop if meets the condition

endloop:
movss (%rsp),%xmm0															#move head(Q) to return value
movq %r15,%rsp
ret
