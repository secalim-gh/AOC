BITS 64

section .text
  global _start

%define SYS_READ  0
%define SYS_WRITE 1 
%define SYS_OPEN  2
%define SYS_CLOSE 3
%define SYS_EXIT  60

%define STDOUT    1
%define O_RDONLY  0

o_file:
  mov rax, SYS_OPEN
  mov rsi, O_RDONLY
  mov rdx, 0
  syscall
  ret

readchar:
  mov rax, SYS_READ
  mov rdx, 1
  syscall
  ret

readline:
  xor r12, r12
.Lreadloop:
  mov rax, SYS_READ
  lea rsi, [rbp-16+r12]
  mov rdx, 1
  syscall

  test rax, rax
  jle .Lreadend

  mov al, byte [rbp-16+r12]
  
  inc r12
  cmp al, 0x0A
  jne .Lreadloop
  
.Lreadend:  
  mov rdx, r12
  mov rax, r12
  lea rsi, [rbp-16]
  ret

print:
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  syscall
  ret

print_n:
  xor rbx, rbx          
  xor rcx, rcx          
  xor rdx, rdx          

  mov rcx, 10           
.Lconvert: 
  xor rdx, rdx          
  div rcx               
  
  add dl, 48            
  mov [rbp-16+rbx], dl
  inc rbx               
  
  cmp rax, 0            
  jne .Lconvert

.Lendconversion:
  mov dl, 0x0A
  mov [rbp-16+rbx], dl 
  inc rbx
  mov rdx, rbx          
  lea rsi, [rbp-16]     
  call print
  ret

parse: ; len in rdx from readline
  push rax            
  xor rcx, rcx        
  xor rax, rax        
  
  mov bl, byte [rbp-16] 
  cmp bl, 0x52          
  mov rbx, -1           
  jne .Lparsenum        
  mov rbx, 1            
.Lparsenum:
  mov cl, byte [rbp-15] 
  sub cl, 48            
  movzx rcx, cl         

  cmp rdx, 3            
  jle .Lapply_sign      

  imul rcx, 10          
  mov al, byte [rbp-14] 
  sub al, 48            
  movzx rax, al         
  add rcx, rax          
  
  cmp rdx, 4            
  jle .Lapply_sign      

  imul rcx, 10          
  mov al, byte [rbp-13] 
  sub al, 48            
  movzx rax, al         
  add rcx, rax
  
.Lapply_sign:
  imul rcx, rbx         
  
  pop rax              
  ret

clicks:
  mov rax, rcx
  cmp rcx, 0
  jge .Lpos
  neg rax
  cmp rax, r13
  jle .Lquit
  sub rax, r13
  cmp r13, 0
  je .Lcontinue
  inc r14
.Lcontinue:
  xor rdx, rdx
  mov rbx, 100
  idiv rbx                     ; rax = rax / 100, rdx = remainder
  add r14, rax
  jmp .Lquit
.Lpos:
  add rax, r13
  cmp rax, 100
  jle .Lquit
  mov rax, rcx
  sub rax, 100
  add rax, r13
  inc r14
  xor rdx, rdx
  mov rbx, 100
  idiv rbx                     ; rax = rax / 100, rdx = remainder
  add r14, rax
.Lquit:
  cmp rdx, 0
  jne .Lquitt
  dec r14
.Lquitt:
  ret

_start:
  mov rbp, rsp
  sub rsp, 16           

  mov rdi, filename
  call o_file
  mov [rbp-8], rax      ; Save fd
  
  mov rdi, [rbp-8]      ; fd in rdi
  lea rsi, [rbp-16]     ; Buffer address in rsi

  mov r13, 50 ; Starts at 50 
  mov r14, 0  ; number of 0 occurrences
while:
  call readline
  mov r15, rax           
  test r15, r15
  jle .Lread_done        

  call parse             

  push rdx
  call clicks
  add r13, rcx
  add r13, 1000           ; n += 1000

  ; modulo calc ; n %= 100;
  mov rax, r13
  xor rdx, rdx
  mov rcx, 100
  div rcx
  mov r13, rdx
  pop rdx

  cmp r13, 0
  jne .Lskip
  inc r14
.Lskip:
  mov rdi, [rbp-8]       ; fd in rdi
  jmp while

.Lread_done:
  mov rax, r14
  call print_n

  mov rax, SYS_EXIT
  xor rdi, rdi
  syscall

section .data
  filename: db "input.txt",0
  fnamelen:  equ $-filename
