; TITLE Project Name
; Authors: Sufiyaan Usmani (21K-3195), Yousuf Ahmed (21K-4594), Qasim Hasan(21K-3210)
; Project Link: https://github.com/sufiyaanusmani/COAL-Project

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

includelib D:\Irvine\Kernel32.Lib
includelib D:\Irvine\User32.Lib
includelib D:\Irvine\Irvine32.lib
include     D:\Irvine\kernel32.inc
include D:\Irvine\Irvine32.inc
include D:\Irvine\Macros.inc

;include D:\Irvine\Irvine32.inc

BUFFER_SIZE = 5000

.data
    row BYTE 0
    col BYTE 0
    ascii BYTE ?
    ebxValue DWORD ?
    validFlag BYTE 0

    newLine BYTE 0ah

    ;keyA db "C:\Program Files (x86)\Dev-Cpp\devcpp.exe",0
    ;keyB db "C:\Users\Sufyan\Downloads\nircmd.exe beep 1000 500",0
    ;keyC db "C:\Windows\System32\calc.exe",0
    ;keyD db "C:\Users\Sufyan\Downloads\nircmd.exe changesysvolume -2000",0
    ;keyE db "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",0
    ;keyF db "C:\Windows\explorer.exe",0
    ;keyG db "C:\Program Files\Google\Chrome\Application\chrome.exe",0
    ;keyH db "C:\Users\Sufyan\Downloads\nircmd.exe mutesysvolume 2",0
    ;keyI db "C:\Users\Sufyan\Downloads\nircmd.exe infobox Programmable_Keyboard COAL_Project",0
    ;keyJ db "C:\Users\Sufyan\Downloads\nircmd.exe clipboard clear",0
    ;keyK db "C:\Windows\System32\osk.exe",0
    ;keyL db "C:\Windows\System32\LaunchTM.exe",0
    ;keyM db "C:\Users\Sufyan\Downloads\nircmd.exe mutesysvolume 1",0
    ;keyN db "C:\Users\Sufyan\Downloads\nircmd.exe mutesysvolume 0",0
    ;keyO db "C:\Users\Sufyan\Downloads\nircmd.exe cdrom open f:",0
    ;keyP db "C:\Program Files\PuTTY\putty.exe",0
    ;keyQ db "C:\Program Files\Microsoft Office\root\Office16\POWERPNT.EXE",0
    ;keyR db "C:\Program Files\Oracle\VirtualBox\VirtualBox.exe",0
    ;keyS db "C:\Users\Sufyan\Downloads\nircmd.exe snippingtool",0
    ;keyT db "C:\Program Files\Git\git-bash.exe",0
    ;keyU db "C:\Users\Sufyan\Downloads\nircmd.exe changesysvolume 2000",0
    ;keyV db "C:\Users\Sufyan\AppData\Local\Programs\Microsoft VS Code\Code.exe",0
    ;keyW db "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE",0  
    ;keyX db "C:\Users\Sufyan\Downloads\nircmd.exe changebrightness 10 10",0
    ;keyY db "C:\Users\Sufyan\AppData\Roaming\Zoom\bin\Zoom.exe",0
    ;keyZ db "C:\Users\Sufyan\Downloads\nircmd.exe changebrightness -10 -10",0

    keyA db 150 DUP(?)
    keyB db 150 DUP(?)
    keyC db 150 DUP(?)
    keyD db 150 DUP(?)
    keyE db 150 DUP(?)
    keyF db 150 DUP(?)
    keyG db 150 DUP(?)
    keyH db 150 DUP(?)
    keyI db 150 DUP(?)
    keyJ db 150 DUP(?)
    keyK db 150 DUP(?)
    keyL db 150 DUP(?)
    keyM db 150 DUP(?)
    keyN db 150 DUP(?)
    keyO db 150 DUP(?)
    keyP db 150 DUP(?)
    keyQ db 150 DUP(?)
    keyR db 150 DUP(?)
    keyS db 150 DUP(?)
    keyT db 150 DUP(?)
    keyU db 150 DUP(?)
    keyV db 150 DUP(?)
    keyW db 150 DUP(?)
    keyX db 150 DUP(?)
    keyY db 150 DUP(?)
    keyZ db 150 DUP(?)


    buffer BYTE ?
    bufSize DWORD ($-buffer)
    keyBufSize DWORD 0
    errMsg BYTE "Cannot open file",0dh,0ah,0
    logFileName     BYTE "log.txt",0
    keysFileName BYTE "keys.txt",0
    fileHandle   HANDLE ?			; handle to output file
    bytesWritten DWORD ?


    buffer1 BYTE BUFFER_SIZE DUP(?)
    buffSize DWORD ?
    lineToWrite BYTE ?
.code
    main PROC
        call storeKeysToVar
        ;mov buffer, 0ah
        ;call createLog
        call clearAll
        call crlf
    L::
        mov validFlag, 0
        call getKey
        call isValid
        movzx eax, validFlag
        cmp eax, 1
        jnz L
        call openApp
    jmp L
		Invoke ExitProcess,0
    main ENDP


    clearAll PROC
        ; -------------------------------------------------------- -
        ; Name: clearAll
        ; Description: clears all registers
        ; Receives: void
        ; Returns: void
        ; -------------------------------------------------------- -
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        
        ; we can also clear esi and edi

        ret
    clearAll ENDP


    jump PROC
        ; -------------------------------------------------------- -
        ; Name: jump
        ; Description: to move to specific coordinate in console
        ; Receives: col, row
        ; Returns: void
        ; -------------------------------------------------------- -
        mov dl, col
        mov dh, row
        call gotoxy

        ret
    jump ENDP


    getKey PROC
        ; -------------------------------------------------------- -
        ; Name: getKey
        ; Description: Reads the key input by user
        ; Receives: 
        ; Returns: ebxValue, ascii
        ; -------------------------------------------------------- -
        L1:
            mov  eax, 50
            call Delay

            call ReadKey
            jz   L1
            ;mShow  al, h
            ;mShow  ah, h
            ;mShow  dx, h
            ;mShow  ebx, hnn
            mov ascii, al
            mov ebxValue, ebx

            ; cmp    dx, VK_ESCAPE
            ; jne    L1
        ret
    getKey ENDP


    isValid PROC
        ; -------------------------------------------------------- -
        ; Name: isValid
        ; Description: compares if value is in correct range
        ; Receives: ascii, ebxValue
        ; Returns: validFlag
        ; -------------------------------------------------------- -
        PUSH eax
        movzx eax, ascii
        cmp eax, 60h
        jng invalid
        movzx eax, ascii
        cmp eax, 7Bh
        jnl invalid
        mov eax, ebxValue
        cmp eax, 22h
        jnz invalid
        mov validFlag, 1

        invalid:
            POP eax
        ret
    isValid ENDP

    openApp PROC
        mov eax, 0
        A:
            mov al, ascii
            cmp al, 61h
            jnz B
            mWriteLn "A",0
            push OFFSET keyA
            call WinExec
            mov buffer, 61h
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        B:
            mov al, ascii
            cmp al, 62h
            jnz C1
            mWriteLn "B",0
            push OFFSET keyB
            call WinExec
            mov buffer, 62h
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        C1:
            mov al, ascii
            cmp al, 63h
            jnz D
            mWriteLn "C",0
            push OFFSET keyC
            call WinExec
            mov buffer, 63h
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        D:
            mov al, ascii
            cmp al, 64h
            jnz E
            mWriteLn "D",0
            push OFFSET keyD
            call WinExec
            mov buffer, 64h
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        E:
            mov al, ascii
            cmp al, 65h
            jnz F
            mWriteLn "E",0
            push OFFSET keyE
            call WinExec
            mov buffer, 65h
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        F:
            mov al, ascii
            cmp al, 66h
            jnz G
            mWriteLn "F",0
            push OFFSET keyF
            call WinExec
            mov buffer, 66h
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        G:
            mov al, ascii
            cmp al, 67h
            jnz H
            mWriteLn "G",0
            push OFFSET keyG
            call WinExec
            mov buffer, 67h
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        H:
            mov al, ascii
            cmp al, 68h
            jnz I
            mWriteLn "H",0
            push OFFSET keyH
            call WinExec
            mov buffer, 68h
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        I:
            mov al, ascii
            cmp al, 69h
            jnz J
            mWriteLn "I",0
            push OFFSET keyI
            call WinExec
            mov buffer, 69h
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        J:
            mov al, ascii
            cmp al, 6Ah
            jnz K
            mWriteLn "J",0
            push OFFSET keyJ
            call WinExec
            mov buffer, 6Ah
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        K:
            mov al, ascii
            cmp al, 6Bh
            jnz L1
            mWriteLn "K",0
            push OFFSET keyK
            call WinExec
            mov buffer, 6Bh
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        L1:
            mov al, ascii
            cmp al, 6Ch
            jnz M
            mWriteLn "L",0
            push OFFSET keyL
            call WinExec
            mov buffer, 6Ch
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        M:
            mov al, ascii
            cmp al, 6Dh
            jnz N
            mWriteLn "M",0
            push OFFSET keyM
            call WinExec
            mov buffer, 6Dh
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        N:
            mov al, ascii
            cmp al, 6Eh
            jnz O
            mWriteLn "N",0
            push OFFSET keyN
            call WinExec
            mov buffer, 6Eh
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        O:
            mov al, ascii
            cmp al, 6Fh
            jnz P
            mWriteLn "O",0
            push OFFSET keyO
            call WinExec
            mov buffer, 6Fh
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        P:
            mov al, ascii
            cmp al, 70h
            jnz Q
            mWriteLn "P",0
            push OFFSET keyP
            call WinExec
            mov buffer, 70h
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        Q:
            mov al, ascii
            cmp al, 71h
            jnz R
            mWriteLn "Q",0
            push OFFSET keyQ
            call WinExec
            mov buffer, 71h
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        R:
            mov al, ascii
            cmp al, 72h
            jnz S
            mWriteLn "R",0
            push OFFSET keyR
            call WinExec
            mov buffer, 72h
            call createLog
            mov buffer, 0ah
            call createLog
            mov edx, OFFSET keyR
            call WriteString
            jmp L
        S:
            mov al, ascii
            cmp al, 73h
            jnz T
            mWriteLn "S",0
            push OFFSET keyS
            call WinExec
            mov buffer, 73h
            call createLog
            mov buffer, 0ah
            call createLog
            mov edx, OFFSET keyS
            call WriteString
            jmp L
        T:
            mov al, ascii
            cmp al, 74h
            jnz U
            mWriteLn "T",0
            push OFFSET keyT
            call WinExec
            mov buffer, 74h
            call createLog
            mov buffer, 0ah
            call createLog
            mov edx, OFFSET keyT
            call WriteString
            jmp L
        U:
            mov al, ascii
            cmp al, 75h
            jnz V
            mWriteLn "U",0
            push OFFSET keyU
            call WinExec
            mov buffer, 75h
            call createLog
            mov buffer, 0ah
            call createLog
            mov edx, OFFSET keyU
            call WriteString
            jmp L
        V:
            mov al, ascii
            cmp al, 76h
            jnz W
            mWriteLn "V",0
            push OFFSET keyV
            call WinExec
            jmp L
        W:
            mov al, ascii
            cmp al, 77h
            jnz X
            mWriteLn "W",0
            push OFFSET keyW
            call WinExec
            mov buffer, 77h
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        X:
            mov al, ascii
            cmp al, 78h
            jnz Y
            mWriteLn "X",0
            push OFFSET keyX
            call WinExec
            mov buffer, 78h
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        Y:
            mov al, ascii
            cmp al, 79h
            jnz Z
            mWriteLn "Y",0
            push OFFSET keyY
            call WinExec
            mov buffer, 79h
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        Z:
            mov al, ascii
            cmp al, 7Ah
            mWriteLn "Z",0
            push OFFSET keyZ
            call WinExec
            mov buffer, 7Ah
            call createLog
            mov buffer, 0ah
            call createLog
            jmp L
        ex:
        
        ret
    openApp ENDP

    createLog PROC
          INVOKE CreateFile,
	      ADDR logFileName, GENERIC_WRITE, DO_NOT_SHARE, NULL,
	      OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0

	    mov fileHandle,eax			; save file handle
	    .IF eax == INVALID_HANDLE_VALUE
	      mov  edx,OFFSET errMsg		; Display error message
	      call WriteString
	      jmp  QuitNow
	    .ENDIF

	    ; Move the file pointer to the end of the file
	    INVOKE SetFilePointer,
	      fileHandle,0,0,FILE_END

	    ; Append text to the file
	    INVOKE WriteFile,
	        fileHandle, ADDR buffer, bufSize,
	        ADDR bytesWritten, 0

	    INVOKE CloseHandle, fileHandle

    QuitNow:
        ret
    createLog ENDP


    saveKeys PROC
          
          INVOKE CreateFile,
	      ADDR keysFileName, GENERIC_WRITE, DO_NOT_SHARE, NULL,
	      CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0

	    mov fileHandle,eax			; save file handle
	    .IF eax == INVALID_HANDLE_VALUE
	      mov  edx,OFFSET errMsg		; Display error message
	      call WriteString
	      jmp  QuitNow
	    .ENDIF

        mov keyBufSize, SIZEOF keyA-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyA,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

        mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyB-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyB,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyC-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyC,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyD-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyD,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyE-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyE,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyF-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyF,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyG-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyG,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyH-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyH,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyI-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyI,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyJ-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyJ,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyK-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyK,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyL-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyL,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyM-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyM,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyN-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyN,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyO-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyO,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyP-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyP,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyQ-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyQ,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyR-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyR,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyS-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyS,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyT-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyT,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyU-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyU,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyV-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyV,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyW-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyW,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyX-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyX,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyY-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyY,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

         mov keyBufSize, SIZEOF newLine
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR newLine,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag
        

        mov keyBufSize, SIZEOF keyZ-1
	    INVOKE WriteFile,		; write text to file
	        fileHandle,		; file handle
	        ADDR keyZ,		; buffer pointer
	        keyBufSize,			; number of bytes to write
	        ADDR bytesWritten,	; number of bytes written
	        0				; overlapped execution flag

	    INVOKE CloseHandle, fileHandle

    QuitNow:
        ret
    saveKeys ENDP

    storeKeysToVar PROC
       ; Open the file for input.
	   mov	edx,OFFSET keysFileName
	   call	OpenInputFile
	   mov	fileHandle,eax

       ; Check for errors.
	    cmp	eax,INVALID_HANDLE_VALUE		; error opening file?
	    jne	file_ok					; no: skip
	    mWrite <"Cannot open file",0dh,0ah>
	    jmp	quit						; and quit
    file_ok:
        ; Read the file into a buffer.
	mov	edx,OFFSET buffer1
	mov	ecx,BUFFER_SIZE
	call	ReadFromFile
	jnc	check_buffer_size			; error reading?
	mWrite "Error reading file. "		; yes: show error message
	call	WriteWindowsMsg
	jmp	close_file
	
check_buffer_size:
	cmp	eax,BUFFER_SIZE			; buffer large enough?
	jb	buf_size_ok				; yes
	mWrite <"Error: Buffer too small for the file",0dh,0ah>
	jmp	quit						; and quit
	
buf_size_ok:	
	mov	buffer1[eax],0		; insert null terminator
	mWrite "File size: "
	mov buffSize, eax
	call	WriteDec			; display file size
	call	Crlf

; Display the buffer.
	mWrite <"Buffer:",0dh,0ah,0dh,0ah>
	mov	edx,OFFSET buffer1	; display the buffer
	call	WriteString
	call	Crlf

close_file:
	mov	eax,fileHandle
	call	CloseFile

    mov ecx, buffSize
    mov edi, OFFSET buffer1
	mov esi, 0
    L1:
		cmp BYTE PTR [edi], 0ah
		je L11
		mov al, [edi]
		mov keyA[esi], al
		inc esi
        inc edi
		jmp L1
	L11: 
		mov keyA[esi], 0

    inc edi
    mov esi, 0
    L2:
		cmp BYTE PTR [edi], 0ah
		je L22
		mov al, [edi]
		mov keyB[esi], al
		inc esi
        inc edi
		jmp L2
	L22: 
		mov keyB[esi], 0
    

    inc edi
    mov esi, 0
    L3:
		cmp BYTE PTR [edi], 0ah
		je L33
		mov al, [edi]
		mov keyC[esi], al
		inc esi
        inc edi
		jmp L3
	L33: 
		mov keyC[esi], 0

    inc edi
    mov esi, 0
    L4:
		cmp BYTE PTR [edi], 0ah
		je L44
		mov al, [edi]
		mov keyD[esi], al
		inc esi
        inc edi
		jmp L4
	L44: 
		mov keyD[esi], 0

    inc edi
    mov esi, 0
    L5:
		cmp BYTE PTR [edi], 0ah
		je L55
		mov al, [edi]
		mov keyE[esi], al
		inc esi
        inc edi
		jmp L5
	L55: 
		mov keyE[esi], 0

    inc edi
    mov esi, 0
    L6a:
		cmp BYTE PTR [edi], 0ah
		je L66a
		mov al, [edi]
		mov keyF[esi], al
		inc esi
        inc edi
		jmp L6a
	L66a: 
		mov keyF[esi], 0

    inc edi
    mov esi, 0
    L7:
		cmp BYTE PTR [edi], 0ah
		je L77
		mov al, [edi]
		mov keyG[esi], al
		inc esi
        inc edi
		jmp L7
	L77: 
		mov keyG[esi], 0


    inc edi
    mov esi, 0
    L8:
		cmp BYTE PTR [edi], 0ah
		je L88
		mov al, [edi]
		mov keyH[esi], al
		inc esi
        inc edi
		jmp L8
	L88: 
		mov keyH[esi], 0

    inc edi
    mov esi, 0
    L9:
		cmp BYTE PTR [edi], 0ah
		je L99
		mov al, [edi]
		mov keyI[esi], al
		inc esi
        inc edi
		jmp L9
	L99: 
		mov keyI[esi], 0

    inc edi
    mov esi, 0
    L10:
		cmp BYTE PTR [edi], 0ah
		je L101
		mov al, [edi]
		mov keyJ[esi], al
		inc esi
        inc edi
		jmp L10
	L101: 
		mov keyJ[esi], 0


    inc edi
    mov esi, 0
    L11a:
		cmp BYTE PTR [edi], 0ah
		je L111a
		mov al, [edi]
		mov keyK[esi], al
		inc esi
        inc edi
		jmp L11a
	L111a: 
		mov keyK[esi], 0


    inc edi
    mov esi, 0
    L12a:
		cmp BYTE PTR [edi], 0ah
		je L112a
		mov al, [edi]
		mov keyL[esi], al
		inc esi
        inc edi
		jmp L12a
	L112a: 
		mov keyL[esi], 0


    inc edi
    mov esi, 0
    L13a:
		cmp BYTE PTR [edi], 0ah
		je L113a
		mov al, [edi]
		mov keyM[esi], al
		inc esi
        inc edi
		jmp L13a
	L113a: 
		mov keyM[esi], 0


    inc edi
    mov esi, 0
    L14a:
		cmp BYTE PTR [edi], 0ah
		je L114a
		mov al, [edi]
		mov keyN[esi], al
		inc esi
        inc edi
		jmp L14a
	L114a: 
		mov keyN[esi], 0


    inc edi
    mov esi, 0
    L15a:
		cmp BYTE PTR [edi], 0ah
		je L115a
		mov al, [edi]
		mov keyO[esi], al
		inc esi
        inc edi
		jmp L15a
	L115a: 
		mov keyO[esi], 0

    inc edi
    mov esi, 0
    L16a:
		cmp BYTE PTR [edi], 0ah
		je L116a
		mov al, [edi]
		mov keyP[esi], al
		inc esi
        inc edi
		jmp L16a
	L116a: 
		mov keyP[esi], 0


    inc edi
    mov esi, 0
    L17a:
		cmp BYTE PTR [edi], 0ah
		je L117a
		mov al, [edi]
		mov keyQ[esi], al
		inc esi
        inc edi
		jmp L17a
	L117a: 
		mov keyQ[esi], 0


    inc edi
    mov esi, 0
    L18a:
		cmp BYTE PTR [edi], 0ah
		je L118a
		mov al, [edi]
		mov keyR[esi], al
		inc esi
        inc edi
		jmp L18a
	L118a: 
		mov keyR[esi], 0


    
    inc edi
    mov esi, 0
    L19a:
		cmp BYTE PTR [edi], 0ah
		je L119a
		mov al, [edi]
		mov keyS[esi], al
		inc esi
        inc edi
		jmp L19a
	L119a: 
		mov keyS[esi], 0


    inc edi
    mov esi, 0
    L20a:
		cmp BYTE PTR [edi], 0ah
		je L200a
		mov al, [edi]
		mov keyT[esi], al
		inc esi
        inc edi
		jmp L20a
	L200a: 
		mov keyT[esi], 0


    inc edi
    mov esi, 0
    L21a:
		cmp BYTE PTR [edi], 0ah
		je L210a
		mov al, [edi]
		mov keyU[esi], al
		inc esi
        inc edi
		jmp L21a
	L210a: 
		mov keyU[esi], 0


    inc edi
    mov esi, 0
    L22a:
		cmp BYTE PTR [edi], 0ah
		je L220a
		mov al, [edi]
		mov keyV[esi], al
		inc esi
        inc edi
		jmp L22a
	L220a: 
		mov keyV[esi], 0


    inc edi
    mov esi, 0
    L23a:
		cmp BYTE PTR [edi], 0ah
		je L230a
		mov al, [edi]
		mov keyW[esi], al
		inc esi
        inc edi
		jmp L23a
	L230a: 
		mov keyW[esi], 0

    inc edi
    mov esi, 0
    L24a:
		cmp BYTE PTR [edi], 0ah
		je L240a
		mov al, [edi]
		mov keyX[esi], al
		inc esi
        inc edi
		jmp L24a
	L240a: 
		mov keyX[esi], 0

    inc edi
    mov esi, 0
    L25a:
		cmp BYTE PTR [edi], 0ah
		je L250a
		mov al, [edi]
		mov keyY[esi], al
		inc esi
        inc edi
		jmp L25a
	L250a: 
		mov keyY[esi], 0


    inc edi
    mov esi, 0
    L26a:
		cmp BYTE PTR [edi], 0ah
		je L260a
		mov al, [edi]
		mov keyZ[esi], al
		inc esi
        inc edi
		jmp L26a
	L260a: 
		mov keyZ[esi], 0

    quit:
       ret
    storeKeysToVar ENDP
END main