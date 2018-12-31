;	Program: exit
;	
;	Executes the exit system call.
;	
;	No input.
;
;	Output: only the exit status, retreivable with $? in the shell.
;

	segment .text
	global  main ; On macOS this is just start
main:
	mov eax, 60 ; 60 is the exit syscall number
		    ; 0x20000001 for OSX
	mov edi, 0  ; The status value to return (modified to 0).
	syscall     ; Execute the system call.
	end

