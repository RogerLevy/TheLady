\ ==============================================================================
\ ForestLib
\ Miscellaneous toolbelt words
\ ========================= copyright 2014 Roger Levy ==========================

\ -------------------------------------------------------------------------------------------------
\ Miscellaneous (temp)


\ -------------------------------------------------------------------------------------------------
\ FOR/NEXT

\ not really recommended for general use, it's a little slower than DO/LOOP, surprisingly...
\ the only place I use it is in game entity scripts since it's light on return stack usage
: for   1 postpone literal postpone - postpone >r here postpone noop ( thwarts optimizer ) ; immediate
: next   [+asm] 0 [esp] dec jns [-asm] postpone r>drop ; immediate

\ -------------------------------------------------------------------------------------------------
\ Callback fix

WINDOWS-INTERFACE OPEN-PACKAGE
PUBLIC
: CB: ( xt n -- <name> ) \ Define a callback passable to the target system's external libraries.
   Create
   RUNCB ,CALL DUP
   [+ASM] CELLS # RET NOP [-ASM]
   0= IF [+ASM] NOP NOP [-ASM] THEN  \ Fix bug in 3.0.6 & 7
   ( xt) , ;
END-PACKAGE


\ -------------------------------------------------------------------------------------------------
\ Memory operators

ICODE 2h@ ( addr -- x y ) \ Fetch 2 signed 16-bit words
   ebx eax mov
   0 [eax] ebx movsxw
   push(ebx)
   2 [eax] ebx movsxw
   ret end-code

ICODE h+! ( n addr -- ) \ Add signed 16-bit word to same at address
   0 [EBP] EAX MOV
   16bit: eax 0 [EBX] ADD
   4 [EBP] EBX MOV
   8 # EBP ADD
   RET   END-CODE

AKA 2@ d@ ( addr -- d ) \ Fetch double
AKA 2! d! ( d addr -- ) \ Store double
AKA 2Variable dVariable ( -- <name> ) \ Define double variable

ICODE 2! ( x y addr -- ) \ Store x,y (keep x,y order in memory)
  0 [EBP] EAX MOV
  4 [EBP] ECX MOV
  EAX 4 [EBX] MOV
  ECX 0 [EBX] MOV
  8 [EBP] EBX MOV
  12 # EBP ADD
  RET END-CODE

ICODE 2@ ( addr -- x y ) \ Fetch x,y
   4 # EBP SUB
   0 [EBX] EAX MOV
   4 [EBX] EBX MOV
   EAX 0 [EBP] MOV
   RET   END-CODE

ICODE 2+! ( x y addr -- ) \ Add-store x,y
  0 [ebp] eax mov
  4 [ebp] ecx mov
  eax 4 [ebx] add
  ecx 0 [ebx] add
  8 [ebp] ebx mov
  12 # ebp add
  ret end-code

: d+!  ( d addr ) \ Add-store double
   dup >r d@ d+ r> d! ;

CODE 3! ( x y z addr -- ) \ Store x,y,z
  0 [ebp] eax mov
  4 [ebp] ecx mov
  eax 8 [ebx] mov
  ecx 4 [ebx] mov
  8 [ebp] eax mov
  eax 0 [ebx] mov
  12 [ebp] ebx mov
  16 # ebp add
  ret end-code

code 3+! ( x y z addr -- )
  0 [ebp] eax mov
  4 [ebp] ecx mov
  eax 8 [ebx] add
  ecx 4 [ebx] add
  8 [ebp] eax mov
  eax 0 [ebx] add
  12 [ebp] ebx mov
  16 # ebp add
  ret end-code

: 3@  ( addr -- x y z ) @+ swap @+ swap @ ;

: 2h!  ( x y addr -- ) dup >r 2 + h! r> h! ;
: 4h!  ( 1 2 3 4 addr -- ) >r 2swap r@ 2h! r> 4 + 2h! ;

: c@+  ( addr -- addr+1 n ) dup c@ 1 u+ ;
: w!+ ( addr n -- addr+2 )  over w! 2 + ;
aka w!+ h!+ \ alias

\ add a cell int to a double
: m+!  dup >r d@ rot m+ r> d! ;


\ -------------------------------------------------------------------------------------------------
\ Coordinate operators

\ 2+ and 2- are obsolete Forth words.  I've redefined them to something more useful.
ICODE 2+  ( x y x y -- x y )
   0 [ebp] eax mov             \ get d2-lo
   eax 8 [ebp] add             \ add d1-lo
   4 [ebp] ebx add             \ add d1-hi
   8 # ebp add               \ and clean up stack
   ret end-code

ICODE 2-  ( x y x y -- x y )
   0 [ebp] eax mov
   ebx 4 [ebp] sub
   eax 8 [ebp] sub
   4 [ebp] ebx mov
   8 # ebp add
   ret end-code

ICODE 3+  ( x y z x y z -- x y z )
   0 [ebp] eax mov
   4 [ebp] ecx mov
   ebx 8 [ebp] add
   eax 12 [ebp] add
   ecx 16 [ebp] add
   8 [ebp] ebx mov
   12 # ebp add
   ret end-code

ICODE 3-  ( x y z x y z -- x y z )
   0 [ebp] eax mov
   4 [ebp] ecx mov
   ebx 8 [ebp] sub
   eax 12 [ebp] sub
   ecx 16 [ebp] sub
   8 [ebp] ebx mov
   12 # ebp add
   ret end-code

ICODE xswap ( x1 y1 x2 y2 -- x2 y1 x1 y2 )
   0 [ebp] ecx mov
   8 [ebp] eax mov
   ecx 8 [ebp] mov
   eax 0 [ebp] mov
   ret end-code

ICODE yswap ( x1 y1 x2 y2 -- x1 y2 x2 y1 )
   ebx ecx mov
   4 [ebp] ebx mov
   ecx 4 [ebp] mov
   ret end-code

ICODE area
   8 [ebp] eax mov
   4 [ebp] ebx add
   eax 0 [ebp] add
   ret end-code

: -area   2over 2- ;


\ -------------------------------------------------------------------------------------------------
\ Profiling

\ print time given XT takes in microseconds
: exectime   ( xt -- n ) ucounter 2>r execute  ucounter 2r> d- d>s ;
: time?  ( xt -- ) exectime . ;

\ -------------------------------------------------------------------------------------------------
\ FFI extension, included to support OpenGL extensions

[defined] lib-interface [if]
  package lib-interface
[else]
  package windows-interface
[then]

: NOPROC ( pfa -- )   CODE> >NAME BAD-PROC ;

   Variable RETURNS-DATA   Variable C/PASCAL

   : 0PARMS
     [+ASM]
       4 # EBP SUB
       EBX 0 [EBP] MOV
       EBP PUSH
       ESI PUSH
       EDI PUSH
     [-ASM] ;

   : 1PARMS
     [+ASM]
       EBP PUSH
       ESI PUSH
       EDI PUSH
       EBX PUSH
     [-ASM] ;

   : NPARMS ( n -- )
     [+ASM]
       1- CELLS ( n)
       DUP ( n) [EBP] EDX LEA
       EDX PUSH
       ESI PUSH
       EDI PUSH
       EBX PUSH
     [-ASM]
     DUP ( n) 0 DO
       I [+ASM] [EBP] PUSH  [-ASM]
     CELL +LOOP
     [+ASM]
       ( n) # EBP ADD
     [-ASM] ;

   : PROLOG ( n -- )
     DUP 0=  IF  DROP 0PARMS  EXIT THEN
     DUP 1 = IF  DROP 1PARMS  EXIT THEN
     NPARMS ;

   : EPILOG
     C/PASCAL @ IF
       [+ASM]
       C/PASCAL @ CELLS # ESP ADD
       [-ASM]
     THEN
     [+ASM]
       EDI POP
       ESI POP
       EBP POP
     [-ASM]
     RETURNS-DATA @ IF
       [+ASM] EAX EBX MOV [-ASM]
     ELSE
       [+ASM] POP(EBX) [-ASM]
     THEN  0 RETURNS-DATA !
     [+ASM]
       RET
     [-ASM] ;

   : WPCALL ( n -- )
     [+ASM]
       HERE 13 - >R
       ECX POP
       0 [ECX] ECX MOV
       PROLOG
      ECX ECX OR  0= NOT IF
       ECX CALL  EPILOG  THEN
       R> CODE> # EBX MOV
       ['] NOPROC >CODE JMP
     [-ASM] ;

PUBLIC

  : void  returns-data off ;

  : (proc:) ( n proc -- <name> )
     header
     here 13 + dup >r ,call           \ forward call to code compiled by wpcall
    ( proc ) ,                  \ compile address of proc
     0 ,                       \ ( void dll pointer )
    ( n ) wpcall                 \ compile in-line code to make the actual proc call
     r> code> ['] .proc decode, ;      \ make a way to decode it

  : proc:
    c/pascal off  (proc:)  returns-data on  -? ;

  : cproc:
    c/pascal off  (proc:)  returns-data on  -? ;

END-PACKAGE


\ -------------------------------------------------------------------------------------------------
\ Commandline extension: a nicer DIR

PACKAGE SHELL-TOOLS

: .FOUNDNAME ( addr -- )
   DUP @ FILE_ATTRIBUTE_DIRECTORY AND IF
     ZDIRNAME
   ELSE
     ZFILENAME
   THEN
  ?TYPE CR ;

PUBLIC

: DIR ( -- )
   pwd CR
   FILESPEC PAD FindFirstFile >R
   R@ INVALID_HANDLE_VALUE <>
   BEGIN ( flag) WHILE
     PAD .FOUNDNAME
     R@ PAD FindNextFile ( flag)
   REPEAT R> FindClose DROP ;

END-PACKAGE

\ ------------------------------------------------------------------------------

: ?create   >in @   absent if >in ! create exit then   drop 0 parse 2drop  r> drop ;

: processpath   bl skip -trailing   2dup [char] / [char] \ REPLACE-CHAR ;
  
: namespec  [char] | parse processpath ;
