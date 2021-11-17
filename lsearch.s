         #var map:
         # %rdi-int *A
          #%esi-int n
          #%rdx-int targetvalue
         # %eax-int place
          #%r9d-int temp
          #%r8-r
          #%ecx-k
	
	.globl	lsearch_2
	
lsearch_2:                                                  

	
	testl	%esi, %esi                             #  if(n<=0)
	jle	notpossible                            #   {place=-1; return place;}
	movslq	%esi, %rax                             #   place=n;
	leaq	-4(%rdi,%rax,4), %rax                  #   place=*A +(n-1)
	movl	(%rax), %r9d                           #   temp=*(place);
	movl	%edx, (%rax)                           #   A[n-1]=targetvalue
	cmpl	(%rdi), %edx                           #   if(A[1]==targetvalue)
	je	firstfound                             #   {  k=0;
	movl	$0, %ecx                               #   place=n-1;
loop:                                                  #   if(place>k){place=k; return place;}
	addl	$1, %ecx                               #}
	movslq	%ecx, %r8
	cmpl	(%rdi,%r8,4), %edx                     #  k=0;
	jne	loop                                   #  do{
                                                       #  k++;
	jmp	isitthetarget                          #  int r=k;
firstfound:                                            #  if(A[r]==targetvalue) break;}
	movl	$0, %ecx                               #  while(A[r]!=targetvalue)
isitthetarget:      
	movl	%r9d, (%rax)                           #  *place=temp
	leal	-1(%rsi), %eax                         #   place=n-1
	cmpl	%ecx, %eax                             #   if(place>k)  {place=k; return place;}
	jg	found
	cmpl	%edx, %r9d                             #   else if(targetvalue != temp)
	movl	$-1, %edx                              #   {
	cmovne	%edx, %eax                             #   n=-1
	ret                                            #   place=n;}
notpossible:                                           #   return place;
	movl	$-1, %eax
	ret
found:
	movl	%ecx, %eax
	ret
	

