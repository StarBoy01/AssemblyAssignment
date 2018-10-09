%include "io.inc"
section .data
MatA: dq 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0
MatL: dq 1.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,1.0
MatU: dq 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0
section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    mov eax,0;;;k
    mov ebx,0;;;i;;;eax>=ebx
l4: push eax
    push ebx
l0: mov edx,eax
    imul edx,3
    add edx,ebx
    call MatU1
    inc ebx;;;;;
    cmp ebx,3
    jl l0
    pop eax
    pop ebx
    push eax
    push ebx
    ;inc eax;;;;;
l3:
    mov edx,eax;;
    imul edx,3
    add edx,ebx
    call MatL1 
    inc eax
    cmp eax,3
    jl l3
    ;;;;;
    pop ebx
    pop eax
    inc eax;;;c
    inc ebx
    cmp eax,3;;;
    jl l4
    
    ret;;;;
MatU1:
    push esi
    push ecx
    mov edi,0
    fld qword[MatA+8*edx]
    mov ecx,eax
    mov esi,ebx
l1: 
    push eax
    push ebx
    cmp eax,0
    je e1
    cmp ebx,0
    je e1
    push esi
    mov esi,ecx
    mov ebx,edi
    imul ecx,3;;;
    add ecx,ebx
    fld qword[MatL+8*ecx]
    mov ecx,esi
    pop esi
    pop ebx
    push ebx
    pop eax
    mov ecx,eax;;q
    push eax
    mov eax,edi
    push edi
    mov edi,esi
    imul eax,3
    add esi,eax    
    fmul qword[MatU+8*esi]
    fsub
    mov esi,edi
    pop edi
    pop ebx
    mov esi,ebx
    pop eax
    sub eax,1
    sub ebx,1
    cmp eax,0
    inc edi
    jge l1
e1:    
    fstp qword[MatU+8*edx]
    pop eax
    pop ebx
    mov ebx,esi
    mov eax,ecx
    pop ecx
    pop esi
    ret 
MatL1:
    push esi
    push ecx
    mov edi,0
    fld qword[MatA+8*edx]
    mov ecx,eax
    mov esi,ebx
l2:
    push eax
    push ebx
    cmp eax,ebx
    je e3 
    cmp eax,0
    je e2
    cmp ebx,0
    je e2
    mov ebx,edi
    push esi
    mov esi,ecx
    imul ecx,3
    add ecx,ebx
    fld qword[MatL+8*ecx];;;;U
    pop ebx
    push ebx
    pop eax 
    mov ecx,esi
    pop esi
    push eax
    mov eax,edi;;;
    imul eax,3
    mov edi,esi
    push edi
    add esi,eax    
    fmul qword[MatU+8*esi]
    fsub
    pop ebx
    mov esi,edi
    pop edi
    pop eax
    sub eax,1
    sub ebx,1
    cmp eax,0
    inc edi
    jge l2
e2: ;;push ebx   
    mov ebx,esi
    mov edi,ebx
    imul edi,3
    add edi,ebx
    fdiv qword[MatU+8*edi]
    fstp qword[MatL+8*edx]
e3: 
    pop eax
    pop ebx 
    
    mov ebx,esi
    mov eax,ecx
    pop ecx
    pop esi
    ret 