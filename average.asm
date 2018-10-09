%include "io.inc"
section .data
Ar: dq 1.0,2.0,3.0,4.0,5.0
N: dd 5
mes : db 'AVERAGE = %0.2f',0
section .text
global CMAIN
CMAIN:
    ;write your code here
   finit
   push dword[N]
   push Ar
   call FSUM
   add esp,8
   ;
   sub esp,8
   fstp qword[esp]
   push mes
   call printf
   add esp,12
   
    ret
 FSUM:
 mov ebx,[esp+4]
 mov ecx,[esp+8]
 mov esi,0
 fld qword[ebx+esi*8]
 dec ecx
 inc esi
 A:
 fAdd qword[ebx+esi*8]  
 inc esi
 loop A
  fild dword[N]
  fdiv
 ret 