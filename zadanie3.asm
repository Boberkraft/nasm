%include "io.inc"

extern _write

section .bss
    znaki resb 12

section .text
global CMAIN
CMAIN:
;. Napisać program w asemblerze, który wyświetli na ekranie 50 początkowych
;elementów ciągu liczb: 1, 2, 4, 7, 11, 16, 22, ... W programie wykorzystać podprogram
;wyswietl_EAX
    ;;1 2 3 4 5 6 7 8 9 10 11
    
    ;;R8–R15 are the new 64-bit registers.
    mov ecx, 0 ; do 50
    mov edx, 0 ; + 1
    mov eax, 1 
    
  zapetlaj:
    add eax, edx
    inc edx
    call wyswietl_EAX
    cmp edx, 50
    jne zapetlaj
    ret

wyswietl_EAX:
    pusha
    mov esi, 10
    mov ebx, 10
    
konwersja:
    mov edx, 0
    div ebx
    
    add dl, 0x30
    
    mov znaki[esi], dl
    dec esi
    cmp eax, 0
    jne konwersja
    
wypeln:
    or esi, esi
    jz wyswietl
    mov byte znaki[esi], 0x20
    dec esi
    jmp wypeln
    
wyswietl:
    mov byte znaki[0], 0xA
    mov byte znaki[11], 0xA
   
   push dword 12
   push dword znaki
   push dword 1
   call _write
   add esp, 12
   popa
   ret
