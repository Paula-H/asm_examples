bits 32

global _maxim

segment data public data use32

segment code public code use32

; int maxim(int numar, int maximal)

_maxim:
    ; creare cadru de stiva pentru programul apelat
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]        ; eax <- numar

    mov ebx, [ebp + 12]        ; ebx <- maximal

    cmp eax, ebx;
    jb nu_e_maxim

    mov eax,1
    ;ne cream propriul FLAG care ne spune daca numar este mai mare decat maximal

    jmp final

    nu_e_maxim:

    mov eax,0

    final:; flagului in eax

    mov esp, ebp
    pop ebp

    ret
