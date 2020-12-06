%include "io.inc"

extern _ExitProcess@4
extern __write ; (dwa znaki podkre�lenia)
extern __read; (dwa znaki podkre�lenia)
extern _MessageBoxA@16

section .text
global CMAIN
CMAIN:
    mov ebp, esp
   
    ; wy�wietlenie tekstu informacyjnego
    ; liczba znak�w tekstu
     mov ecx,(koniec_t) - (tekst_pocz)
     push ecx
     push tekst_pocz
     push 1
     call __write
     add esp, 12
     push 80
     push  magazyn
     push 0
     call __read
     add esp, 12
     mov [liczba_znakow], eax
     mov ebx, 0
    ptl:
     mov dl , magazyn[ebx]
     
        cmp     dl, 0xE6 ;�
        jne skip1
            mov     dl, 0xC6
            jne     dalej
        skip1:
        cmp     dl, 0xEA	 ;�
                jne skip2
            mov     dl, 0xCA
            jne     dalej
        skip2:
        cmp     dl, 0xB3 ;�
                jne skip3
            mov     dl, 0xA3
            jne     dalej
        skip3:
        cmp     dl, 0xF1 ;�
                jne skip4
            mov     dl, 0xD1
            jne     dalej
        skip4:
        cmp     dl, 0xF3 ;�
                jne skip5
            mov     dl, 0xD3
            jne     dalej
        skip5:
        cmp     dl, 0x9C ;�
                jne skip6
            mov     dl, 0x8C
            jne     dalej
        skip6:
        cmp     dl, 0x9F ;�
                jne skip7
            mov     dl, 0xAF
            jne     dalej
        skip7:
        cmp     dl, 0xBF ;�
            jne skip8
            mov     dl, 0xAF
            jne     dalej
        skip8:

 
     cmp dl , 'a'
     jb dalej
     cmp dl , 'z'
     ja dalej
     sub dl , 0x20 ; zamiana na wielkie litery
    ; odes�anie znaku do pami�ci
   dalej:
     mov magazyn[ebx], dl 
     inc ebx
     mov ecx, ebx
     sub ecx, [liczba_znakow]
     jnz ptl

     push 0
     push magazyn
     push magazyn
     push 0 ; NULL
     call _MessageBoxA@16

     ret
    
section .data

tekst_pocz    db 10, 'Prosz� napisa� jaki� tekst '
              db 'i nacisnac Enter', 10
koniec_t      db 0
liczba_znakow dd 0
magazyn       dd 80 dup (?)

