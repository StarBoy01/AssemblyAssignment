%include "io.inc"

section .data
A: dq 3.2,1.00,4.1,3.0,1.5
N: dq 5
zero: dq 0.0
const2: dq 2
median: dq 0
printmedian: dd 'median = %0.2f' ,0

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    xor edi,edi ;0
    xor eax,eax ; 0
    mov edi,[N] ; edi =5
    dec edi ; edi =4
    xor ecx,ecx ;0
    fldz
    l1: ; ecx = k
    xor esi,esi ;esi=0
    l2: ; esi = i
    fld qword[A+esi*8]  ;A[i]
    fld qword[A+esi*8+8]  ;A[i+1]
    fcomi st1
    jb swap
    
    cont:
    finit
    inc esi
    cmp esi,edi 
    jl l2
    inc ecx
    cmp ecx,edi
    jl l1
   
    jmp done_sorintg
    
    
    swap:
    fstp qword[A+esi*8]
    fstp qword[A+esi*8+8]
    jmp cont
    
    done_sorintg:
    ; after sorting the array ...
        mov edi, A ; Array pointer 
        mov eax , [N] ; array length 
        mov ebx , [const2] 
        ;xor edx,edx
        div ebx
        cmp edx,0
        je even
        jmp odd
        
        
        even:
        finit
        mov eax, [N]
        mov ebx, [const2]
        div ebx
        sub eax,1
        fld qword [edi+eax*8] ; M(n/2-1)
        mov eax, [N]
        xor edx,edx
        div ebx 
        fld qword [edi+eax*8] ;M(n/2)
        fadd
        fild qword [const2]
        fdiv
        jmp end
        
        
        odd:
        finit
        mov eax, [N]
        mov ebx, [const2]
        sub eax,1
        xor edx,edx
        div ebx
        fld qword [edi+eax*8]
        jmp end
        
        end:
        fstp qword [median]
    ;
    sub esp,8
fld qword [median]
fstp qword [esp]
push printmedian
call _printf
add esp, 12
   
    ret