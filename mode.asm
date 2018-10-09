%include "io.inc"
section .data
A: dd  1.0,2.0,2.0,1.0,2.0,3.1,4.1,5.0,6.2,8.0
N:dd 10
mode:dq 0.0
freq: dd 0
ffreq:dd 0
msg:db 'the mode is %.1f repeated %i times',10,0
section .text
global CMAIN
CMAIN:   
    push dword[N]
    push A
    call fmode
    add esp,8  
    push dword[ffreq]  
    finit
    sub esp,8
    fld qword[mode]
    fstp qword[esp]
    push msg
    call _printf
    add esp,16 
ret
   
fmode:
   push ebp
   mov ebp,esp   
   finit 
   xor ecx,ecx
   xor eax,eax
   mov eax,[ebp+8]
   mov edx,[freq]
   mov ebx,[ebp+12]
   dec ebx
   xor edi,edi
l1:
   finit
   fld dword[eax+ecx*4]
   xor edi,edi
   mov esi,ecx
l2:
   fld dword[eax+esi*4]
   fcomip 
   je l3   
l5:
   inc esi
   cmp esi,ebx
   jle l2   
   inc ecx
   cmp ecx,ebx
   jle l1 
   mov esp,ebp
   pop ebp
ret   
l3:
   inc edi
   cmp edi,edx
   jg l4
   jmp l5   
l4:
   mov edx,edi
   mov [ffreq],edx
   fst qword[mode]
   jmp l5   