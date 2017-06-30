\ From SwiftForth, copyright FORTH Inc.
\ Note this is specific to x86 


OPTIONAL FPMATH Floating point math package

create 'fpopt
    [defined] HW-FLOAT-STACK [if] false [else] true [then] c,  \ Softare stack?
    [defined] DEBUG-FLOAT [if] true [else] false [then] c,     \ WAIT for exceptions?
    $F32 H,     \ FPU Control word
       7 C,     \ output precision
    ," FIX"     \ FIX SCI or ENG output format


DECIMAL  ONLY FORTH ALSO DEFINITIONS

'FPOPT 1+ C@ [IF] : FPDEBUG ; [THEN]

ASSEMBLER

: FNEXT ( -- )   [DEFINED] FPDEBUG [IF]  WAIT  [THEN]
   RET  END-CODE ;

FORTH

CODE /FSTACK
   'N0 [U] EAX MOV  EAX 'N [U] MOV
   RET END-CODE

CODE (/NDP)
   FINIT  'FPOPT 2+ EDX ADDR  0 [EDX] FLDCW
   ' /FSTACK >CODE JMP
   END-CODE

' (/NDP) IS /NDP   /NDP


'FPOPT C@ [IF] : NUMERICS ; [THEN]

VARIABLE NDP

: <<F ( -- )   [UNDEFINED] NUMERICS [IF]
      NDP GET  [THEN] ;
[DEFINED] NUMERICS [IF]  IMMEDIATE  [THEN]

: F>> ( -- )   [UNDEFINED] NUMERICS [IF]
      NDP RELEASE  [THEN] ;
[DEFINED] NUMERICS [IF]  IMMEDIATE  [THEN]


10 CONSTANT |NUMERIC|
32 CONSTANT #NS

CODE @FSTS ( -- n )
   4 # EBP SUB
   EBX 0 [EBP] MOV
   0 # PUSH
   0 [ESP] FSTSW
   EBX POP
   RET END-CODE

: FSTACK ( n -- )   [DEFINED] NUMERICS [IF]
      |NUMERIC| * ALLOT  HERE 'N0 !  /FSTACK
   [ELSE]  DROP  [THEN] ;

: ?FPERR ( flag -- )
   -EXIT  /NDP  -1 ABORT" Numeric stack error" ;

: ?FPSTACK ( -- )
   @FSTS $40 AND ?FPERR ;

: FDEPTH ( -- n )   [DEFINED] NUMERICS [IF]
      'N0 @ 'N @ - |NUMERIC| /
   [ELSE]  ?FPSTACK 8 @FSTS 2048 / 7 AND - 8 MOD  [THEN] ;

: ?FSTACK ( -- )
   FDEPTH 0 #NS 1+ WITHIN  ?EXIT
   /FSTACK  1 ?FPERR ;

:NONAME ( -- )
   [ ' ?STACK >BODY @ ] LITERAL EXECUTE ?FSTACK ; IS ?STACK


: ?FPRINT ( -- )
   ?FSTACK  FDEPTH 0= ABORT" No floating point number to print" ;


ALSO ASSEMBLER DEFINITIONS

: >f ( -- )   [DEFINED] NUMERICS [IF]
      'N [U] EAX MOV  0 [EAX] TBYTE FLD
      |NUMERIC| # 'N [U] ADD  [THEN] ;

: f> ( -- )   [DEFINED] NUMERICS [IF]
      |NUMERIC| # 'N [U] SUB  'N [U] EAX MOV
      0 [EAX] TBYTE FSTP  [THEN] ;

: >fs ( n -- )   [DEFINED] NUMERICS [IF]
      DUP ( n) |NUMERIC| * # 'N [U] ADD
      'N [U] EAX MOV
      ( n) # ECX MOV
      HERE
         |NUMERIC| # EAX SUB
         0 [EAX] TBYTE FLD
   LOOP  [ELSE]  DROP  [THEN] ;

: fs> ( n -- )   [DEFINED] NUMERICS [IF]
      DUP ( n) |NUMERIC| * # 'N [U] SUB
      'N [U] EAX MOV
      ( n) # ECX MOV
      HERE
         0 [EAX] TBYTE FSTP
         |NUMERIC| # EAX ADD
   LOOP  [ELSE]  DROP  [THEN] ;

PREVIOUS DEFINITIONS

CREATE FP-ROUND
BINARY             1100110010 H, \ ROUND
                  11100110010 H, \ FLOOR
                 101100110010 H, \ ROUND-UP
                 111100110010 H, \ TRUNCATE
DECIMAL


LABEL ROUNDING
   FP-ROUND EAX ADDR
   EAX EDX ADD                  \ and address of interest in eax
   4 # EBP SUB                  \ room for holding status
   >f                           \ move float to ndp
   0 [EBP] FNSTCW               \ save old rounding
   0 [EDX] FLDCW                \ write new rounding
   FRNDINT                      \ integerfy
   0 [EBP] FLDCW                \ restore old
   f>
   4 # EBP ADD
   FNEXT

CODE ROUND      0 # EDX MOV   ROUNDING JMP END-CODE
CODE FLOOR      2 # EDX MOV   ROUNDING JMP END-CODE
CODE ROUND-UP   4 # EDX MOV   ROUNDING JMP END-CODE
CODE TRUNCATE   6 # EDX MOV   ROUNDING JMP END-CODE

CODE MAKE-ROUND
   FP-ROUND EAX ADDR
   0 [EAX] FLDCW
   FNEXT

CODE MAKE-FLOOR
   FP-ROUND EAX ADDR
   2 [EAX] FLDCW
   FNEXT

CODE MAKE-ROUND-UP
   FP-ROUND EAX ADDR
   4 [EAX] FLDCW
   FNEXT

CODE MAKE-TRUNCATE
   FP-ROUND EAX ADDR
   6 [EAX] FLDCW
   FNEXT


CODE FSWAP ( -- ) ( r r -- r r )
   2 >fs   ST(1) FXCH   2 fs>   FNEXT

CODE FDUP ( -- ) ( r -- r r )
   >f  ST(0) FLD   2 fs>   FNEXT

CODE F2DUP ( -- ) ( r r -- r r r r )
   2 >fs   ST(1) FLD  ST(1) FLD   4 fs>
   FNEXT

CODE FOVER ( -- ) ( r r -- r r r )
   2 >fs   ST(1) FLD   3 fs>   FNEXT

CODE FDROP ( -- ) ( r -- )
   >f   ST(0) FSTP   FNEXT

CODE FROT ( -- ) ( r r r -- r r r )
   3 >fs   ST(1) FXCH   ST(2) FXCH  3 fs>   FNEXT

CODE S>F ( n -- ) ( -- r )
   0 [EBP] EBX XCHG  0 [EBP] DWORD FILD  4 # EBP ADD  f>  FNEXT

CODE D>F ( d -- ) ( -- r )
   4 [EBP] EBX XCHG   0 [EBP] QWORD FILD  8 # EBP ADD  f>  FNEXT

CODE (F>S) ( -- n ) ( r -- )
   >f  4 # EBP SUB  0 [EBP] DWORD FISTP  0 [EBP] EBX XCHG  FNEXT

CODE (F>D) ( -- d ) ( r -- )
   >f  8 # EBP SUB  0 [EBP] QWORD FISTP  4 [EBP] EBX XCHG  FNEXT

: F>D ( -- d ) ( r -- )   TRUNCATE (F>D) ;
: F>S ( -- n ) ( r -- )   TRUNCATE (F>S) ;


CODE F+ ( -- ) ( r r -- r )   2 >fs   FADDP   f>   FNEXT
CODE F- ( -- ) ( r r -- r )   2 >fs   FSUBP   f>   FNEXT
CODE F* ( -- ) ( r r -- r )   2 >fs   FMULP   f>   FNEXT
CODE F/ ( -- ) ( r r -- r )   2 >fs   FDIVP   f>   FNEXT

CODE FSQRT ( -- ) ( r -- r )   >f   FSQRT   f>   FNEXT
CODE FABS ( -- ) ( r -- r )   >f   FABS   f>   FNEXT
CODE FNEGATE ( -- ) ( r -- r )   >f   FCHS   f>   FNEXT
CODE Extract ( -- ) ( r -- x s)   >f   FXTRACT   2 fs>   FNEXT

CODE (TAN) ( -- ) ( r -- y x)   >f   FPTAN   2 fs>   FNEXT
CODE (ARCTAN) ( -- ) ( y x -- r )   2 >fs   FPATAN   f>   FNEXT
CODE 2**X-1 ( -- ) ( x -- r )   >f   F2XM1   f>   FNEXT
CODE Y*LOG2(X) ( -- ) ( y x -- r )   2 >fs   FYL2X   f>   FNEXT
CODE Y*LOG2(X+1) ( -- ) ( y x -- r )   2 >fs   FYL2XP1   f>   FNEXT
CODE FROUND ( -- ) ( r -- r )   >f   FRNDINT   f>   FNEXT
CODE 1/N ( -- ) ( x -- r )   >f   FLD1   FDIVRP  f>   FNEXT


CODE #0.0E ( -- ) ( -- r )   FLDZ   f>   FNEXT
CODE #1.0E ( -- ) ( -- r )   FLD1   f>   FNEXT
CODE PI ( -- ) ( -- r )   FLDPI  f>   FNEXT
CODE LN2 ( -- ) ( -- r )   FLDLN2 f>   FNEXT

CODE LOG2(E) ( -- ) ( -- r )   FLDL2E   f>   FNEXT
CODE LOG2(10) ( -- ) ( -- r )   FLDL2T   f>   FNEXT
CODE LOG10(2) ( -- ) ( -- r )   FLDLG2   f>   FNEXT

: FINTEGER ( n -- )  \ Usage: n FINTEGER <name>
   CREATE ( n) ,
   ;CODE
      EAX POP   0 [EAX] DWORD FILD  f>  FNEXT

-1 FINTEGER #-1.0E
-2 FINTEGER #-2.0E
 2 FINTEGER #2.0E
10 FINTEGER #10.0E


LABEL FTESTRES
      4 # EBP SUB       \ make room
      EBX 0 [EBP] MOV
      EBX EBX SUB       \ and a zero
      ECX POP           \ address of test value
      FSTSWAX           \ move ndp status word to ax
      $4100 # EAX AND
      0 [ECX] EAX CMP
      0= IF
         EBX DEC
      THEN
      RET END-CODE

: FUNARY ( cc -- )      \ Usage: nn FUNARY <name>
   CREATE ,
   ;CODE
      >f                \ push to ndp
      FTST              \ test value against zero
      ST(0) FSTP        \ and drop the value
      FTESTRES JMP
      END-CODE

: FBINARY ( cc -- )     \ Usage: nn FBINARY <name>
   CREATE ,
   ;CODE
      2 >fs             \ push values to ndp
      FCOMPP            \ compare two, pop both
      FTESTRES JMP
      END-CODE

$4000 FUNARY F0= ( -- flag )  ( r -- )
$0100 FUNARY F0< ( -- flag )  ( r -- )
$0000 FUNARY F0> ( -- flag )  ( r -- )

$4000 FBINARY F= ( -- flag )  ( r r -- )
$0100 FBINARY F> ( -- flag )  ( r r -- )
$0000 FBINARY F< ( -- flag )  ( r r -- )


: FMIN ( -- ) ( r r -- r )   F2DUP F>  IF  FSWAP  THEN  FDROP ;
: FMAX ( -- ) ( r r -- r )   F2DUP F<  IF  FSWAP  THEN  FDROP ;
: FWITHIN ( - t) ( n l h -- )   FROT  FDUP FROT F<  F2DUP F<
   F= OR  AND ;
: F?DUP ( -- t ) ( r -- , r )   FDUP F0= DUP  IF  FDROP  THEN  0= ;


: F~ ( -- t ) ( r r r -- )
   F?DUP IF
      FDUP  F0<  IF
         FABS FROT FROT F2DUP F- FABS    ( |r3 r1 r2 |r1-r2 )
         FROT FABS  FROT FABS F+ FROT F* ( |r1-r2 |r1+|r2 *|r3 )
         F<
      ELSE
         FROT FROT F- FABS               ( r3 |r1-r2 )
         F>
      THEN
   ELSE
      F=
   THEN ;


CODE SF! ( a -- ) ( r -- )
   >f   0 [EBX] DWORD FSTP
   0 [EBP] EBX MOV  4 # EBP ADD
   FNEXT

CODE SF@ ( a -- ) ( -- r )
   0 [EBX] DWORD FLD
   0 [EBP] EBX MOV  4 # EBP ADD
   f> FNEXT

CODE DF! ( a -- ) ( r -- )
   >f   0 [EBX] QWORD FSTP
   0 [EBP] EBX MOV  4 # EBP ADD
   FNEXT

CODE DF@ ( a -- ) ( -- r )
   0 [EBX] QWORD FLD
   0 [EBP] EBX MOV  4 # EBP ADD
   f> FNEXT

: SF, ( -- ) ( r -- )   HERE  4 ALLOT  SF! ;
: DF, ( -- ) ( r -- )   HERE  8 ALLOT  DF! ;

CODE SF+! ( a -- ) ( r -- )
   >f
   0 [EBX] DWORD FADD
   0 [EBX] DWORD FSTP
   0 [EBP] EBX MOV  4 # EBP ADD
   FNEXT

CODE DF+! ( a -- ) ( r -- )
   >f
   0 [EBX] QWORD FADD
   0 [EBX] QWORD FSTP
   0 [EBP] EBX MOV  4 # EBP ADD
   FNEXT

AKA DF!  F!
AKA DF@  F@
AKA DF+! F+!
AKA DF,  F,


: SFVARIABLE   CREATE  #0.0E SF, ;   \ Usage: SFVARIABLE <name>
: DFVARIABLE   CREATE  #0.0E DF, ;   \ Usage: DFVARIABLE <name>

: SFCONSTANT ( -- ) ( r -- ) \ Usage: r SFCONSTANT <name>
   CREATE  SF,
   ;CODE ( -- addr )
      EAX POP  0 [EAX] DWORD FLD   f> FNEXT


: DFCONSTANT ( -- ) ( r -- ) \ Usage: r DFCONSTANT <name>
   CREATE  DF,
   ;CODE ( -- addr )
      EAX POP  0 [EAX] QWORD FLD   f> FNEXT

AKA DFVARIABLE FVARIABLE
AKA DFCONSTANT FCONSTANT

CODE F2* ( r -- 2r )
   >f   ST(0) ST(0) FADD   f>   FNEXT

CODE F2/ ( r -- r/2 )
   >f
   ' #2.0E >BODY EAX ADDR
   0 [EAX] DWORD FIDIV
   f>   FNEXT


CODE (FVALUE) ( -- ) ( -- r )
      EAX POP  0 [EAX] QWORD FLD   f> FNEXT

: FVALUE ( -- ) ( r -- )
   HEADER  POSTPONE (FVALUE)  DF, ;

: >BODYF! ( n xt -- )   >BODY F! ;
: >BODYF+! ( n xt -- )   >BODY F+! ;

: (FTO) ( xt -- )
   STATE @ IF  POSTPONE LITERAL  POSTPONE >BODYF!  EXIT  THEN   >BODYF! ;

: (F+TO) ( xt -- )
   STATE @ IF  POSTPONE LITERAL  POSTPONE >BODYF+!  EXIT  THEN   >BODYF+! ;

: TO-FVALUE ( -- flag )   >IN @ >R  '
   DUP PARENT ['] (FVALUE) = IF  (FTO)  R> DROP  -1
   ELSE  DROP  R> >IN !  0  THEN ;

: +TO-FVALUE ( -- flag )   >IN @ >R  '
   DUP PARENT ['] (FVALUE) = IF  (F+TO)  R> DROP  -1
   ELSE  DROP  R> >IN !  0  THEN ;

-? : TO ( n -- )
   LOBJ-COMP TO-LOCAL ?EXIT    \ local object
   LVAR-COMP TO-LOCAL ?EXIT    \ local variable
             TO-VALUE ?EXIT    \ VALUE
             TO-FVALUE ?EXIT   \ FVALUE
   1 'METHOD ! ; IMMEDIATE     \ SINGLE

-? : +TO ( n -- )
   LOBJ-COMP +TO-LOCAL ?EXIT
   LVAR-COMP +TO-LOCAL ?EXIT
             +TO-VALUE ?EXIT
             +TO-FVALUE ?EXIT
   2 'METHOD ! ; IMMEDIATE


CODE ieee32 ( -- ) ( -- r )
   EAX POP
   0 [EAX] DWORD FLD
   4 # EAX ADD
   EAX PUSH
   f>
   FNEXT

CODE ieee64 ( -- ) ( -- r )
   EAX POP
   0 [EAX] QWORD FLD
   8 # EAX ADD
   EAX PUSH
   f>
   FNEXT

: SFLITERAL ( -- ) ( r -- )
   POSTPONE ieee32 SF, ; IMMEDIATE

: DFLITERAL ( -- ) ( r -- )
   POSTPONE ieee64 DF, ; IMMEDIATE

AKA DFLITERAL FLITERAL IMMEDIATE


: .ieee ( n )   SPACE  0 DO  1 +IP C@ 2 H.0  LOOP ;
: .ieee32   4 .ieee ;
: .ieee64   8 .ieee ;

DECODE: ieee32 .ieee32
DECODE: ieee64 .ieee64


CODE SFI! ( a -- ) ( r -- )
   >f
   0 [EBX] DWORD FISTP
   POP(EBX)
   FNEXT

CODE DFI! ( a -- ) ( r -- )
   >f
   0 [EBX] QWORD FISTP
   POP(EBX)
   FNEXT

CODE SFI@ ( a -- ) ( -- r )
   0 [EBX] DWORD FILD
   f>
   POP(EBX)
   FNEXT

CODE DFI@ ( a -- ) ( -- r )
   0 [EBX] QWORD FILD
   f>
   POP(EBX)
   FNEXT

: SFI, ( r -- )   HERE  4 ALLOT  SFI! ;
: DFI, ( r -- )   HERE  8 ALLOT  DFI! ;

AKA DFI! FI!
AKA DFI@ FI@
AKA DFI, FI,


CODE ieee32i ( -- ) ( -- r )
   EAX POP
   0 [EAX] DWORD FILD
   4 # EAX ADD
   EAX PUSH
   f>
   FNEXT

CODE ieee64i ( -- ) ( -- r )
   EAX POP
   0 [EAX] QWORD FILD
   8 # EAX ADD
   EAX PUSH
   f>
   FNEXT

: FILITERAL ( r -- )
   FDUP FABS
   $7FFFFFFF S>F F> IF
      POSTPONE ieee64i DFI,
   ELSE  POSTPONE ieee32i SFI,
   THEN ; IMMEDIATE


AKA CELLS SFLOATS
AKA CELL+ SFLOAT+

: DFLOATS ( n -- n' )   8 * ;
: DFLOAT+ ( n -- n' )   8 + ;

AKA DFLOATS FLOATS
AKA DFLOAT+ FLOAT+

: DFALIGNED ( addr -- dfaddr)
   7 + -8 AND ;

: DFALIGN ( -- )
   HERE DFALIGNED H ! ;

AKA DFALIGN FALIGN       AKA ALIGN SFALIGN
AKA DFALIGNED FALIGNED   AKA ALIGNED SFALIGNED


CREATE POWERS
   #10.0E
      #1.0E    FDUP F,          ( 0  1.0)
      FOVER F* FDUP F,          ( 1  10.0)
      FOVER F* FDUP F,          ( 2  100.0)
      FOVER F* FDUP F,          ( 3  1000.0)
      FOVER F* FDUP F,          ( 4  10000.0)
      FOVER F* FDUP F,          ( 5  100000.0)
      FOVER F* FDUP F,          ( 6  1000000.0)
      FOVER F* FDUP F,          ( 7  10000000.0)
      FOVER F* FDUP F,          ( 8  100000000.0)
      FOVER F* FDUP F,          ( 9  1000000000.0)
      FOVER F* FDUP F,          ( 10 10000000000.0)
      FOVER F* FDUP F,          ( 11 100000000000.0)
      FOVER F* FDUP F,          ( 12 1000000000000.0)
      FOVER F* FDUP F,          ( 13 10000000000000.0)
      FOVER F* FDUP F,          ( 14 100000000000000.0)
      FOVER F* FDUP F,          ( 15 1000000000000000.0)
      FOVER F* FDUP F,          ( 16 10000000000000000.0)
      FOVER F* FDUP F,          ( 17 100000000000000000.0)
      FOVER F* FDUP F,          ( 18 1000000000000000000.0)
   FDROP FDROP

CODE T10** ( +n) ( -- r )
   POWERS EAX ADDR
   0 [EAX] [EBX*8] QWORD FLD
   f>
   POP(EBX)
   FNEXT


CODE (I+F) ( -- ) ( r -- x s)
   >f
   EAX PUSH
   0 [ESP] FNSTCW
   0 [ESP] EAX MOV
   $F3FF # EAX AND
   $0400 # EAX OR
   EAX 0 [ESP] XCHG
   FLD1
   FCHS
   ST(1) FLD
   0 [ESP] FLDCW
   FRNDINT
   EAX 0 [ESP] MOV
   0 [ESP] FLDCW
   ST(2) FXCH
   EAX POP
   ST(2) ST(0) FSUB
   FSCALE
   F2XM1
   ST(0) ST(1) FSUBP
   ST(0) ST(0) FMUL
   2 fs>
   FNEXT

CODE [Raise] ( t -- ) ( r x s -- r )
   3 >fs
   ST(1) FXCH   ST(2) FXCH
   EBX EBX OR 0= IF
      ST(0) ST(1) FMULP
   ELSE
      FDIVRP
      ST(1) FXCH  FCHS  ST(1) FXCH
   THEN  FSCALE  ST(1) FXCH  ST(0) FSTP
   POP(EBX)
   f> FNEXT

: >10** ( n -- ) ( r -- r )
   DUP 0<  SWAP  ABS DUP 19 <  IF
      T10** Extract
   ELSE
      S>F LOG2(10) F* (I+F)
   THEN  [Raise]  ;

: /10** ( n) ( r -- r )   #1.0E >10**  F/  ;

CODE *DIGIT ( d a n -- d a )
   4 [EBP] EAX MOV      \ eax = hi(d)
   8 [EBP] ECX MOV      \ ecx = lo(d)
   BASE [U] MUL         \ shift hi(d) up by base
   EAX ECX XCHG         \
   BASE [U] MUL         \ shift lo(d) up by base
   EBX EAX ADD          \ add new digit
   EDX ECX ADC          \ and accumulate overflow from lo(d) shift
   ECX 4 [EBP] MOV      \ put back on stack
   EAX 8 [EBP] MOV      \
   POP(EBX)             \ and pop
   RET END-CODE


: HAS ( a addr n -- a c 0 | a+1 c 1 )
   THIRD C@ DUP >R SCAN NIP 0<> 1 AND TUCK + SWAP R> SWAP ;

: <SIGN>  ( a -- a' c f )   S" +-" HAS ;
: <DOT>   ( a -- a' c f )   S" ." HAS ;
: <E>     ( a -- a' c f )   S" Ee" HAS ;
: <ED>    ( a -- a' c f )   S" EeDd" HAS ;
: <BL>    ( a -- a' c f )   S"  " HAS ;
: <DIGIT> ( a -- a' c f )   S" 0123456789" HAS ;

: <DIGITS> ( a -- a' d f )
   0 0 ROT 0 BEGIN ( d a n)
      >R <DIGIT> WHILE [CHAR] 0 - *DIGIT R> 1+
   REPEAT DROP -ROT R> ;

: FCONVERT ( a -- 0 | a -1 ) ( -- | r )
   <SIGN>    ( a c f)  DROP [CHAR] - = >R
   <DIGITS>  ( a d n)  0= IF 2DROP R> 2DROP 0 EXIT THEN D>F
   <DOT>     ( a c f)  2DROP
   <DIGITS>  ( a d n)  -ROT D>F T10** F/ F+
                       R> IF FNEGATE THEN
   <E>       ( a c f)  0= IF FDROP 2DROP 0 EXIT THEN DROP
   <SIGN>    ( a c f)  DROP [CHAR] - = >R
   <DIGITS>  ( a d n)  2DROP R> IF NEGATE THEN >10**
   <BL>      ( a c f)  0= IF FDROP 2DROP 0 EXIT THEN DROP
   -1 ;

: FCONVERT2 ( a -- 0 | a -1 ) ( -- | r )
   <SIGN>    ( a c f)  DROP [CHAR] - = >R
   <DIGITS>  ( a d n)  DROP D>F
   <DOT>     ( a c f)  2DROP
   <DIGITS>  ( a d n)  -ROT D>F T10** F/ F+
                       R> IF FNEGATE THEN
   <ED>      ( a c f)  2DROP
   <SIGN>    ( a c f)  DROP [CHAR] - = >R
   <DIGITS>  ( a d n)  2DROP R> IF NEGATE THEN >10**
   -1 ;


: (REAL) ( a -- a 0 | -1 ) ( -- r )
   DUP 1+ FCONVERT
   DUP -EXIT -ROT 2DROP ;

: >FLOAT ( caddr n -- true | false ) ( -- r )
   R-BUF  -TRAILING R@ ZPLACE  R@ FCONVERT2 ( 0 | a\f ) IF
      R> ZCOUNT + = DUP ?EXIT FDROP EXIT
   THEN R> DROP 0 ;


: FNUMBER? ( addr len 0 | ... xt -- addr len 0 | ... xt )
   ?DUP ?EXIT  BASE @ 10 = IF
      R-BUF  2DUP R@ PLACE  BL R@ COUNT + C!  R> (REAL) IF
         2DROP ['] FLITERAL  EXIT
   ELSE DROP THEN THEN 0 ;

' FNUMBER? NUMBER-CONVERSION <CHAIN


: F2** ( -- )( r -- r )
   FDUP F0< FABS #1.0E FSWAP (I+F) [Raise]  ;

: F** ( -- ) ( y x -- r )   FSWAP Y*LOG2(X) F2**  ;   \ y to the x
: FEXP ( -- ) ( x -- r )   LOG2(E) F* F2**  ;         \ e to the x
: FALOG ( -- ) ( x -- r )   LOG2(10) F* F2**  ;       \ 10 to the x

( Natural log of x)
CODE FLN ( -- ) ( x -- r )   >f
   FLDLN2
   ST(1) FXCH
   FYL2X
   f> FNEXT

( Log base 10 of x)
CODE FLOG ( -- ) ( x -- r )   >f
   FLDLG2
   ST(1) FXCH
   FYL2X
   f> FNEXT

: FLNP1 ( r -- r )
   FDUP [ 1.0E 2.0E FSQRT 2.0E F/ F- FNEGATE ] FLITERAL F> IF
     FDUP [ 2.0E FSQRT 1.0E F- ] FLITERAL F< IF
       LN2  FSWAP  Y*LOG2(X+1)  EXIT  THEN THEN
   #1.0E F+ FLN ;    \ ln(x+1)

: FEXPM1 ( r -- r )
   LOG2(E) F*
   FDUP FABS #1.0E F< IF
     2**X-1
   ELSE
     F2** #1.0E F-  THEN ;  \ (e to the x) - 1


: PRECISION ( -- u )   'FPOPT 4 + C@ ;

: SET-PRECISION ( u -- )   1 MAX 17 MIN  'FPOPT 4 + C!  ;


18 CONSTANT MAX-FBUFFER

CREATE FBUFFER MAX-FBUFFER 2+ ALLOT

: FSIGN? ( -- n ) ( r -- r )   FDUP F0<  ;

: #EXP ( -- n ) ( r -- r )   FDUP F0=  IF  PRECISION  ELSE
   FDUP FABS FLOG FLOOR F>S  THEN  ;

: FSIGN ( n -- )   IF  [CHAR] - EMIT  THEN  ;

: 0'S ( n -- )   DUP 0> IF DUP 0  DO
   [CHAR] 0 EMIT  LOOP  THEN  DROP  ;

: REPRESENT ( c-addr u -- n f1 f2 )
   2DUP [CHAR] 0 FILL 2DUP FSIGN? >R FABS
   #EXP DUP >R - 1- >10** DROP  F>D <# #S #>
   ROT 2DUP - >R  MIN ROT SWAP MOVE 2R> + 1+  R> -1 ;


: FDISPLAY ( n -- )
   FBUFFER  OVER 0 MAX TYPE   [CHAR] . EMIT
   DUP FBUFFER +  SWAP NEGATE 0 MIN PRECISION + TYPE  ;

: .EXP ( n -- )
   [CHAR] E EMIT  DUP ABS  0  <#  #S
   PAD DPL @ -  1 = IF  [CHAR] 0 HOLD  THEN
   ROT 0<  IF  [CHAR] -  ELSE  [CHAR] +  THEN  HOLD  #>
   TYPE SPACE  ;

: FS. ( r -- )
   ?FPRINT  FBUFFER PRECISION REPRESENT DROP FSIGN
   1 FDISPLAY 1-  .EXP  ;

: Adjust ( n - n' 1|2|3 )
   S>D 3 FM/MOD 3 * SWAP 1+  ;


: FE. ( r)
   ?FPRINT  FBUFFER PRECISION REPRESENT DROP FSIGN
   1- Adjust FDISPLAY  .EXP  ;


: DISPLAY-SMALL ( n -- )
   [CHAR] 0 EMIT [CHAR] . EMIT
   ABS DUP PRECISION MIN 1- 0'S
   FBUFFER PRECISION ROT - 0 MAX TYPE  ;

: DISPLAY-BIG ( n -- )
   FBUFFER PRECISION TYPE PRECISION - 1+ 0'S [CHAR] . EMIT  ;

: FNS. ( -- ) ( r -- )
   ?FPRINT #EXP 0< >R
   FBUFFER PRECISION  REPRESENT DROP FSIGN R> IF
      DUP 1 < IF 1- DISPLAY-SMALL ELSE FDISPLAY THEN
   ELSE
      DUP PRECISION >  IF  1- DISPLAY-BIG  ELSE  FDISPLAY  THEN
   THEN  ;

: F. ( -- ) ( r -- )   FNS. SPACE  ;


: FS.R ( u -- ) ( r -- )
   FSIGN?  2 #EXP ABS 99 > -  SWAP -  3 +  -
   PRECISION 2DUP > IF TUCK - SPACES ELSE SWAP SET-PRECISION THEN
   FS.  SET-PRECISION  ;

: F.R ( u -- ) ( r -- )
   ?FPRINT 1- FSIGN? + PRECISION 2DUP >
   IF  OVER SET-PRECISION   ELSE  2DUP SWAP - SPACES  THEN
   FNS. SET-PRECISION DROP  ;


#USER DUP USER 'POINTS
CELL+ DUP USER 'FORMAT
CELL+ TO #USER

: N. ( -- ) ( r -- )
   ?FPRINT PRECISION
   'POINTS @ SET-PRECISION 'FORMAT @EXECUTE SET-PRECISION  ;

: [N] ( -- ) \ Usage: [N] <existingname> <name>
   ' CREATE ,
   DOES> ( n a -- )   @ 'FORMAT !  'POINTS !  ;

[N] F. FIX    [N] FS. SCI    [N] FE. ENG

'FPOPT 4 + COUNT SWAP COUNT EVALUATE


CODE F/DIGIT ( -- n ) ( r -- q )
   >f                                   \ r to tos
   ' #10.0E >BODY EAX ADDR
   0 [EAX] DWORD FILD                   \ push 10.0
   ST(1) FLD                            \ r 10 r
   FPREM                                \ r%10 10 r
   ST(2) FXCH                           \ r 10 r%10
   FDIVRP                               \ r/10 r%10
   0 # PUSH                             \ make a place
   0 [ESP] FNSTCW                       \ read control word
   0 [ESP] EAX MOV                      \ to eax
   $0C00 # EAX OR                       \ set mask
   0 [ESP] EAX XCHG                     \ swap new with old
   0 [ESP] FLDCW                        \ write new
   FRNDINT                              \
   0 [ESP] EAX XCHG                     \ swap new with old
   0 [ESP] FLDCW                        \ write old
   ST(1) FXCH                           \
   0 [ESP] FISTP                        \
   PUSH(EBX)                            \ push tos
   EBX POP                              \ and get n from stack
   f> FNEXT

: <#. ( -- ) ( r -- r )   FROUND  <# ;

: #. ( -- ) ( r -- q)   F/DIGIT  DIGIT HOLD ;

: #S. ( -- ) ( r -- r )   BEGIN  #.  FDUP F0= UNTIL ;

: .#> ( - a n) ( r -- )   FDROP  DPL @ PAD OVER - ;

: (FSIGN) ( n)   IF  [CHAR] -  ELSE  BL THEN  HOLD ;

: (F.) ( n - a n) ( r -- )   0 MAX 18 MIN  FDUP F0<  >R  FABS
   DUP >10**  <#.  ?DUP IF  0 DO  #. LOOP  THEN
   [CHAR] . HOLD  #S.  R> (FSIGN)  .#> ;


CODE % ( -- ) ( x % - x r)
   2 >fs
   ST(1) ST(0) FMUL
   100 # PUSH
   0 [ESP] FILD
   FDIVP
   4 # ESP ADD
   2 fs> FNEXT


: SMATRIX ( #r #c -- )
   CREATE
      DUP SFLOATS , * 0 DO
         #0.0E SF,
      LOOP
   DOES> ( r c a -- a )
      ROT OVER @ * ( c a o1) ROT SFLOATS +  +  CELL+ ;

: LMATRIX ( #r #c -- )
   CREATE
      DUP DFLOATS , * 0 DO
         #0.0E DF,
      LOOP
   DOES> ( r c a -- a )
      ROT OVER @ * ( c a o1) ROT DFLOATS +  +  CELL+ ;

( Short matrix display)

: SMD ( #r #c -- ) \ Usage: n m SMD <name>
   SWAP  ' >BODY CELL+ SWAP  0  ?DO
      CR OVER  0  DO
         DUP SF@ N. 1 SFLOATS +
      LOOP
   LOOP  CR 2DROP  ;

( Long matrix display)

: LMD ( #r #c -- ) \ Usage: n m LMD <name>
   SWAP  ' >BODY CELL+ SWAP  0  ?DO
      CR OVER  0 DO
         DUP DF@ N. 1 DFLOATS +
      LOOP
   LOOP  CR 2DROP  ;


PI 180.0E0 F/ DFCONSTANT PI/180
PI 4.0E0   F/ DFCONSTANT PI/4
PI 2.0E0   F/ DFCONSTANT PI/2

: R>D ( r -- r )   PI/180 F/  ;
: D>R ( r -- r )   PI/180 F*  ;

CODE FTAN ( r -- r )
   >f   FTST
   0 # PUSH  0 [ESP] FSTSW  EDX POP
   FABS
   ' PI/4 >BODY EAX ADDR
   EAX ECX MOV  0 [ECX] QWORD FLD
   ST(1) FXCH   FPREM   FSTSWAX
   ST(1) FSTP   $200 # EAX TEST   0= NOT  IF
      0 [ECX] QWORD FSUBR   THEN   FPTAN
   EAX ECX MOV   $4200 # ECX AND   0= NOT  IF  $4200 # ECX SUB
      0= NOT  IF  ST(1) FXCH   THEN   THEN   FDIVP
   $4000 # EAX TEST   0= NOT  IF  FCHS   THEN
   $100 # EDX TEST   0= NOT  IF  FCHS   THEN   f>   FNEXT

: TAN ( r -- r )   D>R FTAN  ;


CODE COS.SIN ( r -- r r )
   >f   FTST  0 # PUSH  0 [ESP] FSTSW  EDX POP   FABS
   ' PI/4 >BODY EAX ADDR
   EAX ECX MOV  0 [ECX] QWORD FLD
   ST(1) FXCH   FPREM   FSTSWAX
   ST(1) FSTP   $200 # EAX TEST   0= NOT  IF
      0 [ECX] QWORD FSUBR   THEN   FPTAN
   ST(0) FLD  ST(0) FLD  FMULP
   ST(2) FLD  ST(0) FLD  FMULP  FADDP  FSQRT
   ST(0) FLD  ST(0) ST(2) FDIVP ST(0) ST(2) FDIVP

   EAX ECX MOV  $4200 # ECX AND
   0= NOT IF  $4200 # ECX SUB  0= NOT IF  ST(1) FXCH  THEN THEN
   EAX ECX MOV  $4100 # ECX AND
   0= NOT IF  $4100 # ECX SUB  0= NOT IF  FCHS THEN THEN
   $100 # EAX TEST
   0= NOT IF  ST(1) FXCH FCHS ST(1) FXCH THEN
   $100 # EDX TEST
   0= NOT IF  ST(1) FXCH FCHS ST(1) FXCH THEN

   2 fs> FNEXT


: FSINCOS ( r -- r r )   COS.SIN ;
: FSIN ( r -- r )   COS.SIN  FDROP  ;
: FCOS ( r -- r )   COS.SIN  FSWAP  FDROP  ;
: SIN ( r -- r )   D>R FSIN  ;
: COS ( r -- r )   D>R FCOS  ;


: FCOMPLEMENT ( r -- r )   FNEGATE PI/2 F+  ;
: FSUPPLEMENT ( r -- r )   FNEGATE PI F+  ;

: [FATAN2] ( r r -- r )   F2DUP F<  IF  (ARCTAN)
   ELSE  FSWAP (ARCTAN) FNEGATE PI/2 F+  THEN  ;

: [FATAN] ( r -- r )   #1.0E  [FATAN2]  ;

: FATAN ( r -- r )   FDUP F0<  IF  FNEGATE [FATAN] FNEGATE
   ELSE  [FATAN]  THEN  ;

: FATAN2 ( r r -- r )   FOVER FABS  FOVER FABS  [FATAN2]
   FROT FROT   F0<  IF  F0<  IF  PI F+  ELSE  FSUPPLEMENT  THEN
   ELSE  F0<  IF  FNEGATE PI F2* F+  THEN  THEN  ;


: COT ( r -- r )   TAN 1/N  ;
: SEC ( r -- r )   COS 1/N  ;
: CSC ( r -- r )   SIN 1/N  ;
: R ( r -- r )   FDUP F* FNEGATE  #1.0E F+  FSQRT  ;
: FASIN ( r -- r )   FDUP  R  FATAN2  ;
: FACOS ( r -- r )   FDUP  R  FSWAP  FATAN2  ;

\ sinh(x) = 1/2 * (d + d/(d-1)) ; d = expm1(x)
: FSINH ( r -- r )
   FEXPM1  FDUP  FDUP #1.0E F+  F/  F+  f2/ ;

: FCOSH ( r -- r )   FEXP  FDUP  1/N  F+  F2/  ;

\ tanh(x) = -d / (d+2) ; d = expm1(-2x)
: FTANH ( r -- r )
   FDUP 22.0E0 F< IF
     F2* FEXPM1  2.0E0 FOVER  F+  F/
   ELSE  #1.0E
   THEN ;

\ asinh(x) = sign(x) * lnp1(|x| + x^2/(1 + sqrt(1+x^2)))
: FASINH ( r -- r )
   FDUP F0< >R FABS
   FDUP [ 28.0e F2** ] FLITERAL F< IF
     FDUP  FDUP F*
     FDUP  #1.0E F+  FSQRT  #1.0E F+  F/  F+  FLNP1
   ELSE
     FLN  LN2 F+    \ avoid overflow
   THEN
   R> IF  FNEGATE  THEN ;

\ acosh(x) = ln(x + sqrt(x^2-1))
: FACOSH ( r -- r )
   FABS FDUP [ 28.0E F2** ] FLITERAL F< IF
     FDUP  FDUP F*  #1.0E F-  FSQRT  F+  FLN
   ELSE
     FLN  LN2 F+    \ avoid overflow
   THEN ;

\ atanh(x) = sign(x)* 1/2 * lnp1(2*(x / (1-x)))
 : FATANH ( r -- r)
   FDUP F0< >R FABS
   FDUP #1.0E FOVER F- F/ F2*  FLNP1  F2/
   R> IF  FNEGATE  THEN ;


[DEFINED] NUMERICS [IF]

CODE FPICK ( n -- ) ( -- r )
   |NUMERIC| # EAX MOV  EBX MUL
   'N [U] EAX ADD  0 [EAX] TBYTE FLD
   0 [EBP] EBX MOV  4 # EBP ADD
   f> FNEXT

[ELSE]

LABEL (FPICK)
   ST(0) FLD   RET
   ST(1) FLD   RET
   ST(2) FLD   RET
   ST(3) FLD   RET
   ST(4) FLD   RET
   ST(5) FLD   RET
   ST(6) FLD   RET
   ST(7) FLD   RET
   END-CODE

CODE FPICK ( n -- ) ( -- r)
   3 # EAX MOV   EBX MUL
   (FPICK) # EAX ADD   POP(EBX)
   EAX JMP   END-CODE

[THEN]

-? : .S   .S  FDEPTH ?DUP IF
      0  DO  I' I - 1- FPICK N.  LOOP
   ." <-NTop "  THEN ;


: TANH ( r -- r )
   FEXP FDUP  FDUP 1/N FDUP  FROT FSWAP F-
   FROT FROT  F+  F/ ;

: +POINTS ( -- )   PRECISION 1+ DUP SET-PRECISION 'POINTS !  ;

: +N ( -- ) ( r -- r )   FDUP N. +POINTS CR  ;
: |N ( -- ) ( r -- )   FDROP 3 SET-PRECISION  ;

:ONENVLOAD   /NDP ;
/NDP

ONLY FORTH ALSO DEFINITIONS


\ Extend literals to support fixed-point
Variable .sign
: .FCONVERT ( a -- 0 | a -1 ) ( -- | r )
   <SIGN>    ( a c f)  DROP [CHAR] - = .sign !
   <DIGITS>  ( a d n)  0= IF 2DROP DROP 0 EXIT THEN D>F
   <DOT>     ( a c f)  0= IF FDROP 2DROP 0 EXIT THEN DROP
   <DIGITS>  ( a d n)  -ROT D>F T10** F/ F+
                       .sign @ IF FNEGATE THEN
   <E>       ( a c f)  IF FDROP 2DROP 0 EXIT THEN DROP
   -1 ;

: >.FLOAT ( caddr n -- true | false ) ( -- r )
   R-BUF  R@ ZPLACE  R@ .FCONVERT ( 0 | a\f ) IF
      R> ZCOUNT + = DUP ?EXIT FDROP EXIT
   THEN R> DROP 0 ;

: .NUMBER? ( addr len 0 | p.. xt -- addr len 0 | p.. xt )
     DUP IF EXIT THEN
     DROP
     BASE @ 10 = IF
          2DUP >.FLOAT IF 2DROP
               65536.0e ( 4096e ) f* (f>s) ['] LITERAL  EXIT THEN
     THEN   0 ;

' .NUMBER? NUMBER-CONVERSION >CHAIN

GILD
