.MODEL SMALL
.STACK 100h

.DATA
menu db 13,10,"1.Add Record"
     db 13,10,"2.Sort by Family Members"
     db 13,10,"3.Show Totals"
     db 13,10,"4.Exit"
     db 13,10,"Choice: $"

msgFam   db 13,10,"Total Family Members: $"
msgWater db 13,10,"Total Water: $"
msgFlour db 13,10,"Total Flour: $"
msgPulse db 13,10,"Total Pulses: $"

records db 30 dup(5 dup(0))
count   db 0

totalFam    dw 0
totalWater  dw 0
totalFlour  dw 0
totalPulses dw 0

.CODE
MAIN PROC
    mov ax,@data
    mov ds,ax

MAIN_MENU:
    lea dx,menu
    mov ah,09h
    int 21h

    mov ah,01h
    int 21h
    sub al,'0'

    cmp al,1
    je ADD_REC
    cmp al,2
    je SORT_REC
    cmp al,3
    je TOTALS
    cmp al,4
    je EXIT
    jmp MAIN_MENU

ADD_REC:
    mov ah,01h
    int 21h
    sub al,'0'
    mov bh,al

    mov cl,count
    mov si,0

CHK_DUP:
    cmp cl,0
    je STORE
    mov al,records[si]
    cmp al,bh
    je MAIN_MENU
    add si,5
    dec cl
    jmp CHK_DUP

STORE:
    mov al,count
    mov ah,0
    mov bl,5
    mul bl
    mov si,ax

    mov records[si],bh

    mov cx,4
    inc si
INP:
    mov ah,01h
    int 21h
    sub al,'0'
    mov records[si],al
    inc si
    loop INP

    inc count
    jmp MAIN_MENU

SORT_REC:
    mov cl,count
    dec cl

OUTER:
    mov si,0
    mov dl,cl

INNER:
    mov al,records[si+1]
    mov bl,records[si+6]
    cmp al,bl
    jbe NOSWAP

    mov cx,5
SWAP:
    mov al,records[si]
    xchg al,records[si+5]
    mov records[si],al
    inc si
    loop SWAP
    sub si,5

NOSWAP:
    add si,5
    dec dl
    jnz INNER
    dec cl
    jnz OUTER

    jmp MAIN_MENU

TOTALS:
    mov totalFam,0
    mov totalWater,0
    mov totalFlour,0
    mov totalPulses,0

    mov cl,count
    mov si,0

SUM:
    mov al,records[si+1]
    cbw
    add totalFam,ax

    mov al,records[si+2]
    cbw
    add totalWater,ax

    mov al,records[si+3]
    cbw
    add totalFlour,ax

    mov al,records[si+4]
    cbw
    add totalPulses,ax

    add si,5
    loop SUM

    lea dx,msgFam
    mov ah,09h
    int 21h
    mov ax,totalFam
    add al,'0'
    mov dl,al
    mov ah,02h
    int 21h

    lea dx,msgWater
    mov ah,09h
    int 21h
    mov ax,totalWater
    add al,'0'
    mov dl,al
    mov ah,02h
    int 21h

    lea dx,msgFlour
    mov ah,09h
    int 21h
    mov ax,totalFlour
    add al,'0'
    mov dl,al
    mov ah,02h
    int 21h

    lea dx,msgPulse
    mov ah,09h
    int 21h
    mov ax,totalPulses
    add al,'0'
    mov dl,al
    mov ah,02h
    int 21h

    jmp MAIN_MENU

EXIT:
    mov ah,4Ch
    int 21h

MAIN ENDP
END MAIN
