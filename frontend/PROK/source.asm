.386
.model flat, stdcall
option casemap :none

;     include files
;     ~~~~~~~~~~~~~
      include \masm32\include\windows.inc
      include \masm32\include\masm32rt.inc
      include \masm32\include\gdi32.inc
      include \masm32\include\user32.inc
      include \masm32\include\kernel32.inc
      include \masm32\include\Comctl32.inc
      include \masm32\include\comdlg32.inc
      include \masm32\include\shell32.inc
      include \masm32\include\oleaut32.inc
      include    \masm32\include\dialogs.inc

;     libraries
;     ~~~~~~~~~
      includelib \masm32\lib\masm32.lib
      includelib \masm32\lib\gdi32.lib
      includelib \masm32\lib\user32.lib
      includelib \masm32\lib\kernel32.lib
      includelib \masm32\lib\Comctl32.lib
      includelib \masm32\lib\comdlg32.lib
      includelib \masm32\lib\shell32.lib
      includelib \masm32\lib\oleaut32.lib

      szText MACRO Name, Text:VARARG
        LOCAL lbl
          jmp lbl
            Name db Text,0
          lbl:
        ENDM

      m2m MACRO M1, M2
        push M2
        pop  M1
      ENDM

      return MACRO arg
        mov eax, arg
        ret
      ENDM

        WinMain PROTO :DWORD,:DWORD,:DWORD,:DWORD
        WndProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
        TopXY PROTO   :DWORD,:DWORD
        ;___________________________________________________________editable part
        Paint_Proc PROTO :DWORD, hDC:DWORD
        Frame3D PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
        PushButton PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
        ListBox PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
        ListBoxProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
        EditSl PROTO  :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
        Static PROTO  :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
        dlgproc   PROTO :DWORD,:DWORD,:DWORD,:DWORD
        Butn1Proc PROTO :DWORD,:DWORD,:DWORD,:DWORD
        store PROTO :DWORD, :DWORD
        ;___________________________________________________________

    .data
        szDisplayName db "PROK",0
        CommandLine   dd 0
        hWnd          dd 0
        hInstance     dd 0
        ;___________________________________________________________
        hList1          dd 0
        hList2          dd 0
        lpLstBox1       dd 0
        hFont           dd 0
        szSelected_key  db ".",0
        szSelected_func dd ".",0
        hStat1          dd 0
        ;___________________________________________________________

    .code

start:
    invoke GetModuleHandle, NULL
    mov hInstance, eax
    invoke GetCommandLine
    mov CommandLine, eax
    invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
    invoke ExitProcess,eax

WinMain proc hInst     :DWORD, hPrevInst :DWORD, CmdLine   :DWORD, CmdShow   :DWORD

        LOCAL wc   :WNDCLASSEX
        LOCAL msg  :MSG
        LOCAL Wwd  :DWORD
        LOCAL Wht  :DWORD
        LOCAL Wtx  :DWORD
        LOCAL Wty  :DWORD

        szText szClassName,"Generic_Class"
        mov wc.cbSize, sizeof WNDCLASSEX
        mov wc.style,CS_HREDRAW or CS_VREDRAW \
                     or CS_BYTEALIGNWINDOW
        mov wc.lpfnWndProc, offset WndProc
        mov wc.cbClsExtra, NULL
        mov wc.cbWndExtra, NULL
        m2m wc.hInstance, hInst
        mov wc.hbrBackground, COLOR_BTNFACE+1
        mov wc.lpszMenuName, NULL
        mov wc.lpszClassName, offset szClassName
        invoke LoadIcon,hInst,500
        mov wc.hIcon, eax
        invoke LoadCursor,NULL,IDC_ARROW
        mov wc.hCursor, eax
        mov wc.hIconSm, 0
        invoke RegisterClassEx, ADDR wc
        ;___________________________________________________________

        mov Wwd, 1200       ;width
        mov Wht, 800        ;height
        ;___________________________________________________________


        invoke GetSystemMetrics,SM_CXSCREEN
        invoke TopXY,Wwd,eax
        mov Wtx, eax
        invoke GetSystemMetrics,SM_CYSCREEN ; get screen height in pixels
        invoke TopXY,Wht,eax
        mov Wty, eax
        invoke CreateWindowEx,WS_EX_OVERLAPPEDWINDOW, ADDR szClassName, ADDR szDisplayName, WS_OVERLAPPEDWINDOW, Wtx,Wty,Wwd,Wht, NULL, NULL, hInst,NULL
        mov   hWnd,eax  ; copy return value into handle DWORD
        invoke LoadMenu,hInst,600
        invoke SetMenu,hWnd,eax
        invoke ShowWindow,hWnd,SW_SHOWNORMAL
        invoke UpdateWindow,hWnd

    StartLoop:
      invoke GetMessage,ADDR msg,NULL,0,0
      cmp eax, 0
      je ExitLoop
      invoke TranslateMessage, ADDR msg
      invoke DispatchMessage,  ADDR msg
      jmp StartLoop
    ExitLoop:
      return msg.wParam
WinMain endp

WndProc proc hWin   :DWORD, uMsg   :DWORD, wParam :DWORD, lParam :DWORD
    ;___________________________________________________________
    LOCAL hDC  :DWORD
    LOCAL Ps   :PAINTSTRUCT
    ;___________________________________________________________


    .if uMsg == WM_COMMAND
        .if wParam == 1000
            invoke SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL
        .elseif wParam == 1900
            szText TheMsg,"Assembler, Pure & Simple"
            invoke MessageBox,hWin,ADDR TheMsg,ADDR szDisplayName,MB_OK
        ;_______________________________________________________v
        .elseif wParam == 499
            invoke  crt_printf,ADDR szSelected_key 
            invoke  crt_printf,ADDR szSelected_func 
        .elseif wParam == 500
            mov szSelected_key, "q"
        .elseif wParam == 501
            mov szSelected_key, "w"
        .elseif wParam == 502
            mov szSelected_key, "e"
        .elseif wParam == 503
            mov szSelected_key, "r"
        .elseif wParam == 504
            mov szSelected_key, "t"
        .elseif wParam == 505
            mov szSelected_key, "y"
        .elseif wParam == 506
            mov szSelected_key, "u"
        .elseif wParam == 507
            mov szSelected_key, "i"
        .elseif wParam == 508
            mov szSelected_key, "o"
        .elseif wParam == 509
            mov szSelected_key, "p"
        .elseif wParam == 510
            mov szSelected_key, "a"
        .elseif wParam == 511
            mov szSelected_key, "s"
        .elseif wParam == 512
            mov szSelected_key, "d"
        .elseif wParam == 513
            mov szSelected_key, "f"
        .elseif wParam == 514
            mov szSelected_key, "g"
        .elseif wParam == 515
            mov szSelected_key, "h"
        .elseif wParam == 516
            mov szSelected_key, "j"
        .elseif wParam == 517
            mov szSelected_key, "k"
        .elseif wParam == 518
            mov szSelected_key, "l"
        .elseif wParam == 519
            mov szSelected_key, "z"
        .elseif wParam == 520
            mov szSelected_key, "x"
        .elseif wParam == 521
            mov szSelected_key, "c"
        .elseif wParam == 522
            mov szSelected_key, "v"
        .elseif wParam == 523
            mov szSelected_key, "b"
        .elseif wParam == 524
            mov szSelected_key, "n"
        .elseif wParam == 525
            mov szSelected_key, "m"
            


        ;_______________________________________________________^



        .endif
    ;___________________________________________________________v
    .elseif uMsg == WM_PAINT
        invoke BeginPaint,hWin,ADDR Ps
          mov hDC, eax
          invoke Paint_Proc,hWin,hDC
        invoke EndPaint,hWin,ADDR Ps
        return 0
    ;___________________________________________________________^


    .elseif uMsg == WM_CREATE
    ;___________________________________________________________v


    szText font1,"Agency FB"
        invoke CreateFont,30,12,0,0,500,0,0,0, \
                          DEFAULT_CHARSET,0,0,0,\
                          DEFAULT_PITCH,ADDR font1
        mov hFont, eax
        szText adrTxt,0

        szText lbl1,"CUSTOMIZE"
        invoke Static,ADDR lbl1,hWin,50,30,400,100,20



    ;___________________________________________________________^




    ;___________________________________________________________v
       invoke ListBox,908,15,250,660,hWin,501
       mov hList2, eax
       invoke SetWindowLong,hList2,GWL_WNDPROC,ListBoxProc
       mov lpLstBox1, eax

         jmp @@@1
          Butn1 db "Volume up",0
          Butn2 db  "Volume down",0
          Butn3 db  "Mute speaker",0
          Butn4 db  "Mute mic",0
          Butn5 db  "Previous track",0
          Butn6 db  "Play/Pause media",0
          Butn7 db  "Next track",0
          Butn8 db  "Left mouse click",0
          Butn9 db  "Right mouse click",0
          Butn10 db "Double mouse click",0
          Butn11 db "Launch Calculator",0
          Butn12 db "Launch Mspaint",0
          Butn13 db "Launch Notepad",0
          Butn14 db "Launch Snipping tool",0
          Butn15 db "Launch Task manager",0
          Butn16 db "Launch File Explorer",0
          Butn17 db "Cycle Apps",0
          Butn18 db "Switch Apps",0
          Butn19 db "Close current App",0
          Butn20 db "Cut",0
          Butn21 db "Copy",0
          Butn22 db "Paste",0
          Butn23 db "Mail",0
          Butn24 db "Refresh",0
          Butn25 db "Brightness Up",0
          Butn26 db "Brightness Down",0
          Butn27 db "Show Desktop",0
          Butn28 db "Lock Computer",0
          Butn29 db "System Shutdown",0
          Butn30 db "Undo",0
          Butn31 db "Redo",0
          Butn32 db "Go Forward pages",0
          Butn33 db "Go Backward pages",0
          Butn34 db "Dpi Up",0
          Butn35 db "Dpi Down",0
          Butn36 db "Dpi Shift",0
          Butn37 db "Encrypt a New Folder",0
          Butn38 db "Open Windows Settings",0
          Butn39 db "Blue light settings",0
          

         @@@1:

       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn1
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn2
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn3
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn4
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn5
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn6
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn7
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn8
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn9
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn10

       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn11
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn12
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn13
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn14
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn15
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn16
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn17
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn18
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn19
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn20

       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn21
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn22
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn23
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn24
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn25
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn26
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn27
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn28
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn29
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn30

       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn31
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn32
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn33
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn34
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn35
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn36
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn37
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn38
       invoke SendMessage,hList2,LB_ADDSTRING,0,ADDR Butn39

    ;___________________________________________________________^








    ;___________________________________________________________v
        jmp @F
          
          Butnq db "Q",0
          Butnw db "W",0
          Butne db "E",0
          Butnr db "R",0
          Butnt db "T",0
          Butny db "Y",0
          Butnu db "U",0
          Butni db "I",0
          Butno db "O",0
          Butnp db "P",0
          Butna db "A",0
          Butns db "S",0
          Butnd db "D",0
          Butnf db "F",0
          Butng db "G",0
          Butnh db "H",0
          Butnj db "J",0
          Butnk db "K",0
          Butnl db "L",0
          Butnz db "Z",0
          Butnx db "X",0
          Butnc db "C",0
          Butnv db "V",0
          Butnb db "B",0
          Butnn db "N",0
          Butnm db "M",0
          Butnsave db "save",0




        @@:
                                            ;  x1,y1, w , h,idk
        invoke PushButton,ADDR Butnsave,hWin,908,680,250,50,499

        invoke PushButton,ADDR Butnq,hWin,050,90,76,80,500
        invoke PushButton,ADDR Butnw,hWin,130,90,76,80,501
        invoke PushButton,ADDR Butne,hWin,210,90,76,80,502
        invoke PushButton,ADDR Butnr,hWin,290,90,76,80,503
        invoke PushButton,ADDR Butnt,hWin,370,90,76,80,504
        invoke PushButton,ADDR Butny,hWin,450,90,76,80,505
        invoke PushButton,ADDR Butnu,hWin,530,90,76,80,506
        invoke PushButton,ADDR Butni,hWin,610,90,76,80,507
        invoke PushButton,ADDR Butno,hWin,690,90,76,80,508
        invoke PushButton,ADDR Butnp,hWin,770,90,76,80,509
        invoke PushButton,ADDR Butna,hWin,080,172,76,80,510
        invoke PushButton,ADDR Butns,hWin,160,172,76,80,511
        invoke PushButton,ADDR Butnd,hWin,240,172,76,80,512
        invoke PushButton,ADDR Butnf,hWin,320,172,76,80,513
        invoke PushButton,ADDR Butng,hWin,400,172,76,80,514
        invoke PushButton,ADDR Butnh,hWin,480,172,76,80,515
        invoke PushButton,ADDR Butnj,hWin,560,172,76,80,516
        invoke PushButton,ADDR Butnk,hWin,640,172,76,80,517
        invoke PushButton,ADDR Butnl,hWin,720,172,76,80,518
        invoke PushButton,ADDR Butnz,hWin,110,254,76,80,519
        invoke PushButton,ADDR Butnx,hWin,192,254,76,80,520
        invoke PushButton,ADDR Butnc,hWin,274,254,76,80,521
        invoke PushButton,ADDR Butnv,hWin,356,254,76,80,522
        invoke PushButton,ADDR Butnb,hWin,438,254,76,80,523
        invoke PushButton,ADDR Butnn,hWin,520,254,76,80,524
        invoke PushButton,ADDR Butnm,hWin,602,254,76,80,525

    ;___________________________________________________________^

    .elseif uMsg == WM_CLOSE
    
    ;invoke  crt_printf,ADDR szSelected_func
    ;szText TheText,"Please Confirm Exit"
    ;    invoke MessageBox,hWin,ADDR TheText,ADDR szDisplayName,MB_YESNO
    ;      .if eax == IDNO
    ;        return 0
    ;      .endif
    ;.elseif uMsg == WM_DESTROY
        invoke PostQuitMessage,NULL
        return 0 
    .endif
    invoke DefWindowProc,hWin,uMsg,wParam,lParam
    ret
WndProc endp

TopXY proc wDim:DWORD, sDim:DWORD
    shr sDim, 1
    shr wDim, 1
    mov eax, wDim
    sub sDim, eax
    return sDim
TopXY endp
;________________________________________________________________v

;###################################################################################






store proc dvar:DWORD,svar:DWORD
    LOCAL vcount:DWORD
    mov vcount,0
    mov ecx,LENGTHOF svar 
    vstart:
    mov eax,svar[vcount]
    mov dvar[vcount],eax
    add vcount,4
    loop vstart

ret

store endp
























Static proc lpText:DWORD,hParent:DWORD,
                 a:DWORD,b:DWORD,wd:DWORD,ht:DWORD,ID:DWORD

; Static PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
; invoke Static,ADDR szText,hWnd,20,20,100,15,500

    LOCAL hndle:DWORD

    szText statClass,"STATIC"

    invoke CreateWindowEx,WS_EX_LEFT,
            ADDR statClass,lpText,
            WS_CHILD or WS_VISIBLE or SS_LEFT,
            a,b,wd,ht,hParent,ID,
            hInstance,NULL

    mov hndle, eax

    invoke SendMessage,hndle,WM_SETFONT,hFont, 0

    mov eax, hndle

    ret

Static endp















;###################################################################################

ListBox proc a:DWORD,b:DWORD,wd:DWORD,ht:DWORD,hParent:DWORD,ID:DWORD

    szText lstBox,"LISTBOX"

    invoke CreateWindowEx,WS_EX_CLIENTEDGE,ADDR lstBox,0,
              WS_VSCROLL or WS_VISIBLE or \
              WS_BORDER or WS_CHILD or \
              LBS_HASSTRINGS or LBS_NOINTEGRALHEIGHT or \
              LBS_DISABLENOSCROLL,
              a,b,wd,ht,hParent,ID,hInstance,NULL
    ret

ListBox endp


ListBoxProc proc hCtl   :DWORD,
                 uMsg   :DWORD,
                 wParam :DWORD,
                 lParam :DWORD
    LOCAL IndexItem  :DWORD
    LOCAL Buffer[32] :BYTE

    .if uMsg ==WM_LBUTTONUP
      jmp DoIt
    .elseif uMsg == WM_CHAR
      .if wParam == 13
        jmp DoIt
      .endif
    .endif
    jmp EndDo

    DoIt:
        invoke SendMessage,hCtl,LB_GETCURSEL,0,0
        mov IndexItem, eax
        invoke SendMessage,hCtl,LB_GETTEXT,IndexItem,ADDR Buffer

        mov eax, hList1
      
          szText CurSel2,"Functions"
          invoke MessageBox,hWnd,ADDR Buffer,ADDR CurSel2,MB_OK

          ;MOVE Buffer value in szSelected_func
          ;mov esi, offset Buffer

          ;invoke store, szSelected_func, ADDR Buffer


    EndDo:

    invoke CallWindowProc,lpLstBox1,hCtl,uMsg,wParam,lParam

    ret

ListBoxProc endp









;###################################################################################













Paint_Proc proc hWin:DWORD, hDC:DWORD

    LOCAL btn_hi   :DWORD
    LOCAL btn_lo   :DWORD
    LOCAL Rct      :RECT

    invoke GetSysColor,COLOR_BTNHIGHLIGHT
    mov btn_hi, eax

    invoke GetSysColor,COLOR_BTNSHADOW
    mov btn_lo, eax
    ;        right                    x1,y1, x2 ,y2 ,thickness 
    invoke Frame3D,hDC,btn_lo,btn_hi,900,08,1160,740,1
    invoke Frame3D,hDC,btn_hi,btn_lo,903,11,1163,743,2

    ;        left                   x1,y1, x2 ,y2 ,thickness                                 
    invoke Frame3D,hDC,btn_lo,btn_hi,27,17,878,475,10
    invoke Frame3D,hDC,btn_hi,btn_lo,30,20,875,472,3

    ; ----------------------------------------------------------
    ; The following code draws the border around the client area
    ; ----------------------------------------------------------
    invoke GetClientRect,hWin,ADDR Rct

    add Rct.left,   1
    add Rct.top,    1
    sub Rct.right,  1
    sub Rct.bottom, 1

    invoke Frame3D,hDC,btn_lo,btn_hi,
                   Rct.left,Rct.top,
                   Rct.right,Rct.bottom,2

    add Rct.left,   4
    add Rct.top,    4
    sub Rct.right,  4
    sub Rct.bottom, 4

    invoke Frame3D,hDC,btn_hi,btn_lo,
                   Rct.left,
                   Rct.top,Rct.right,Rct.bottom,2

    return 0

Paint_Proc endp










PushButton proc lpText:DWORD,hParent:DWORD,
                a:DWORD,b:DWORD,wd:DWORD,ht:DWORD,ID:DWORD

    szText btnClass,"BUTTON"

    invoke CreateWindowEx,0,
            ADDR btnClass,lpText,
            WS_CHILD or WS_VISIBLE,
            a,b,wd,ht,hParent,ID,
            hInstance,NULL




    ret

PushButton endp








Frame3D proc hDC:DWORD,btn_hi:DWORD,btn_lo:DWORD,
             tx:DWORD, ty:DWORD, lx:DWORD, ly:DWORD,bdrWid:DWORD

    LOCAL hPen     :DWORD
    LOCAL hPen2    :DWORD
    LOCAL hpenOld  :DWORD

    invoke CreatePen,0,1,btn_hi
    mov hPen, eax
  
    invoke SelectObject,hDC,hPen
    mov hpenOld, eax

    push tx
    push ty
    push lx
    push ly
    push bdrWid


       lpOne:

        invoke MoveToEx,hDC,tx,ty,NULL
        invoke LineTo,hDC,lx,ty

        invoke MoveToEx,hDC,tx,ty,NULL
        invoke LineTo,hDC,tx,ly

        dec tx
        dec ty
        inc lx
        inc ly

        dec bdrWid
        cmp bdrWid, 0
        je lp1Out
        jmp lpOne
      lp1Out:

    invoke CreatePen,0,1,btn_lo
    mov hPen2, eax
    invoke SelectObject,hDC,hPen2
    mov hPen, eax
    invoke DeleteObject,hPen

    pop bdrWid
    pop ly
    pop lx
    pop ty
    pop tx

       lpTwo:

        invoke MoveToEx,hDC,tx,ly,NULL
        invoke LineTo,hDC,lx,ly

        invoke MoveToEx,hDC,lx,ty,NULL
        inc ly        
        invoke LineTo,hDC,lx,ly
        dec ly

        dec tx
        dec ty
        inc lx
        inc ly

        dec bdrWid
        cmp bdrWid, 0
        je lp2Out
        jmp lpTwo
      lp2Out:

    invoke SelectObject,hDC,hpenOld
    invoke DeleteObject,hPen2

    ret

Frame3D endp





;###################################################################################
        
;________________________________________________________________

end start