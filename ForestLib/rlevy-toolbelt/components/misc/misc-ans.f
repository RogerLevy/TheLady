\ IN-PROGRESS
\  [ ] for/next
\  [ ] callback fix
\  [x] memops
\  [x] coordops
\  [ ] ffi extension

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

: 2h@  @ hilo ;
: h+!  dup h@ rot + swap h! ;

AKA 2@ d@ ( addr -- d ) \ Fetch double
AKA 2! d! ( d addr -- ) \ Store double
AKA 2Variable dVariable ( -- <name> ) \ Define double variable

: 2!  dup >r cell+ ! r> ! ;
: 2@  dup @ swap cell+ @ ;
: 2+!  dup >r 2@ 2+ r> 2! ;
: d+!  dup >r d@ d+ r> d! ;
: 3!   dup >r 2 cells + ! r@ cell+ ! r> ! ;
: 3+!   dup >r 2 cells + +! r@ cell+ +! r> +! ;
: 3@   ( addr -- x y z ) @+ swap @+ swap @ ;
: 2h!   ( x y addr -- ) dup >r 2 + h! r> h! ;
: 4h!   ( 1 2 3 4 addr -- ) >r 2swap r@ 2h! r> 4 + 2h! ;
: c@+   ( addr -- addr+1 n ) dup c@ 1 u+ ;
: w!+ ( addr n -- addr+2 )  over w! 2 + ;
aka w!+ h!+ \ alias

\ add a cell int to a double
: m+!  ( n adr ) dup >r d@ rot m+ r> d! ;


\ -------------------------------------------------------------------------------------------------
\ Coordinate operators

\ 2+ and 2- are obsolete Forth words.  I've redefined them to something more useful.

: 2+  rot + >r + r> ;
: 2-  rot swap - >r - r> ;
: 3+  rot >r 2+ rot r> + -rot ;
: 3+  rot >r 2- rot r> - -rot ;
: xswap  swap rot 2swap ;
: yswap  swap rot ;
: area  2over 2+ ;
: -area   2over 2- ;

\ -------------------------------------------------------------------------------------------------
\ Profiling

\ print time given XT takes in microseconds
: exectime   ( xt -- n ) ucounter 2>r execute  ucounter 2r> d- d>s ;
: time?   ( xt -- ) exectime . ;

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
      here 13 + dup >r ,call               \ forward call to code compiled by wpcall
      ( proc ) ,                           \ compile address of proc
      0 ,                                  \ ( void dll pointer )
      ( n ) wpcall                         \ compile in-line code to make the actual proc call
      r> code> ['] .proc decode, ;         \ make a way to decode it

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

: ?create   >in @    absent if >in ! create exit then   drop 0 parse 2drop  r> drop ;

: processpath   bl skip -trailing   2dup [char] / [char] \ REPLACE-CHAR ;
   
: namespec  [char] | parse processpath ;
