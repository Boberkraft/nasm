%include "io.inc"

extern __write
extern _ExitProcess@4

section .text
global CMAIN
CMAIN:
    mov ebp, esp
   
    mov ecx, 94
    push ecx 
    push dword tekst
    push dword 1
    call __write
    add esp, 12 
    push dword 0
    call _ExitProcess@4
    ret
    
section .data
tekst db 10, 'Nazywam sie Andrzej Bisewski' , 10
      db 'M', 0xF3,'j pierwszy 32-bitowy program '
      db 'asemblerowy dzia', 0xB3, 'a ju', 0xBF, ' poprawnie!', 10