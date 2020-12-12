%include "io.inc"

extern __write
extern __read
extern __scanf 

section .data
dziesiec dd 10
magazyn  dd '1111111111'
przecinek  dd ','
dekoder  db '0123456789ABCDEF'
formatin db "%i/%i", 0

section .bss
    znaki    resb 12
    obszar   resb 12
    integer1 resb 4
    integer2 resb 4
    
section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging

    push integer1 ; to na dole
    push integer2 ; to u gory
    push formatin
    call _scanf

    add esp, 12

    mov EDX, 0
    mov dword EAX, [integer2]
    div dword [integer1]

    ; EAX iloraz 
    call wyswietl_EAX
    
    pusha
    push dword 1
    push dword przecinek
    push dword 1
    call __write
    add esp, 12
    popa
    
    mov dword eax, edx
    mul dword [dziesiec]
    mov edx, 0
    div dword [integer1]
    
    ; EAX iloraz 
    call wyswietl_EAX
    
    
    mov dword eax, edx
    mul dword [dziesiec]
    mov edx, 0
    div dword [integer1]
    
    ; EAX iloraz 
    call wyswietl_EAX
    ret
    
    mov eax, 0
    mov ebx, magazyn
  pobieraj_znaki:
    mov cl, [ebx]
    inc ebx
    cmp cl, 10
    je byl_enter
    sub cl, 0x30
    movzx ecx, cl
    
    mul dword [dziesiec]
    add eax, ecx
    jmp pobieraj_znaki
    
  byl_enter:
    ;;call wyswietl_EAX
    call wyswietl_EAX_hex
    
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

   
   push dword 12
   push dword znaki
   push dword 1
   call __write
   add esp, 12
   popa
   ret
   
wyswietl_EAX_hex:
    pusha
    
    ; rezerwacja 12 bajtów na stosie (poprzez zmniejszenie
    ; rejestru ESP) przeznaczonych na tymczasowe przechowanie
    ; cyfr szesnastkowych wyœwietlanej liczby
    sub esp, 12
    mov edi, esp
    mov ecx, 8 ; liczba obiegów pêtli konwersji
    mov esi, 1 ; indeks pocz¹tkowy u¿ywany przy zapisie cyfr
  ptl3hex:
    ; przesuniêcie cykliczne (obrót) rejestru EAX o 4 bity w lewo
    ; w szczególnoœci, w pierwszym obiegu pêtli bity nr 31 - 28
    ; rejestru EAX zostan¹ przesuniête na pozycje 3 - 0
    rol eax, 4
    ; wyodrêbnienie 4 najm³odszych bitów i odczytanie z tablicy
    ; 'dekoder' odpowiadaj¹cej im cyfry w zapisie szesnastkowym
    mov ebx, eax
    and ebx, 0xF
    mov dl, dekoder[ebx]
    mov edi[esi], dl
    inc esi
    loop ptl3hex
    
    mov eax, 1
  wypeln1:
    cmp eax, 8
    je wyswietl1
    cmp byte edi[eax], '0'
    jne wyswietl1
    mov byte edi[eax], ' ' ; kod spacji
    inc eax ; zmniejszenie indeksu
    jmp wypeln1
  wyswietl1:
    
    mov byte [edi + 0], 10
    mov byte [edi + 9], 10


    push 10 ; 8 cyfr + 2 znaki nowego wiersza
    push edi ; adres obszaru roboczego
    push 1
    call __write
    ; usuniêcie ze stosu 24 bajtów, w tym 12 bajtów zapisanych
    ; przez 3 rozkazy push przed rozkazem call
    ; i 12 bajtów zarezerwowanych na pocz¹tku podprogramu
    add esp, 24
   
    popa
    ret

