%include "io.inc"

extern _ExitProcess@4
extern __write ; (dwa znaki podkreślenia)
extern __read; (dwa znaki podkreślenia)
extern _MessageBoxA@16

section .text
global CMAIN
CMAIN:
    mov ebp, esp
   
    ; wyświetlenie tekstu informacyjnego
    ; liczba znaków tekstu
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
     
        cmp     dl, 0xE6 ;ć
        jne skip1
            mov     dl, 0xC6
            jne     dalej
        skip1:
        cmp     dl, 0xEA	 ;ę
                jne skip2
            mov     dl, 0xCA
            jne     dalej
        skip2:
        cmp     dl, 0xB3 ;ł
                jne skip3
            mov     dl, 0xA3
            jne     dalej
        skip3:
        cmp     dl, 0xF1 ;ń
                jne skip4
            mov     dl, 0xD1
            jne     dalej
        skip4:
        cmp     dl, 0xF3 ;ó
                jne skip5
            mov     dl, 0xD3
            jne     dalej
        skip5:
        cmp     dl, 0x9C ;ś
                jne skip6
            mov     dl, 0x8C
            jne     dalej
        skip6:
        cmp     dl, 0x9F ;ź
                jne skip7
            mov     dl, 0xAF
            jne     dalej
        skip7:
        cmp     dl, 0xBF ;ż
            jne skip8
            mov     dl, 0xAF
            jne     dalej
        skip8:

 
     cmp dl , 'a'
     jb dalej
     cmp dl , 'z'
     ja dalej
     sub dl , 0x20 ; zamiana na wielkie litery
    ; odesłanie znaku do pamięci
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

tekst_pocz    db 10, 'Proszę napisać jakiś tekst '
              db 'i nacisnac Enter', 10
koniec_t      db 0
liczba_znakow dd 0
magazyn       dd 80 dup (?)

