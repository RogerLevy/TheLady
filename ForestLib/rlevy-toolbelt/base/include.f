\ from SwiftForth, Copyright FORTH Inc.

variable nesting
variable include-logging   include-logging  on

\ ------------------------------------------------------------------------------

icode @rel ( a -- n )
   0 [ebx] ecx mov              \ read value from address
   ecx ecx or  0<> if           \ skip if u = 0
      ebx ecx add               \ otherwise relocate relative to addr
   then
   ecx ebx mov
   ret end-code

icode !rel ( n a -- )
   0 [ebp] ecx mov
   ecx ecx or  0<> if
      ebx ecx sub
   then
   ecx 0 [ebx] mov
   4 [ebp] ebx mov
   8 # ebp add
   ret end-code

: rel, ( n -- )   h @  cell h +!  !rel ;

\ ------------------------------------------------------------------------------

variable crossref   crossref on

: /INCLUDE ( -- )
   SOURCE-ID ?EXIT  OBSCURED OFF  VIEWED OFF ;

: INCLUDE/ ( -- )
   SOURCE-ID ?EXIT  OBSCURED @ -EXIT  $10 WARNS -EXIT
   CR BRIGHT OBSCURED @ DUP . 1 = IF
         ." definition was hidden"
   ELSE  ." definitions were hidden"  THEN  NORMAL CR ;

VARIABLE LASTFILE       \ Pointer to name field of last file name

: =FILENAME ( n zstr -- )
   crossref @ 0= if 2drop exit then   
   R-BUF  ZCOUNT R@ ZPLACE  >R
   FILES-WORDLIST WID> CELL+ BEGIN ( link)
      @REL DUP WHILE  DUP LINK> >BODY @ R@ = IF ( match)
   DROP 2R> 2DROP EXIT  THEN  REPEAT DROP
   R> R> -ROOT FILES-WORDLIST -? (WID-CREATE) ,
   LAST @ LASTFILE ! ;

CODE (NEXTLINE) ( addr1 u1 -- addr1 u2 addr2 u3 )
   0 [EBP] ECX MOV                              \ ECX EBX: buf addr len
   ECX EDX MOV   EAX EAX XOR                    \ EDX EAX: line addr len
   BEGIN   EBX EBX OR   0> WHILE                \ len=0: skip to end
      $0A # 0 [ECX] BYTE CMP 0= NOT IF          \ =LF: skip to end
      $0D # 0 [ECX] BYTE CMP   0= NOT IF        \ =CR: skip to end
      $20 # 0 [ECX] BYTE CMP   U< IF            \ other ctrl char?
      $20 # 0 [ECX] BYTE MOV   THEN             \ substitute space
      EBX DEC   ECX INC   EAX INC               \ advance
   ROT AGAIN                                    \ back to BEGIN
   THEN ( cr)   EBX DEC   ECX INC               \ resolve fwd branch for =CR
   THEN ( lf)   EBX DEC   ECX INC               \ resolve fwd branch for =LF
   THEN ( len=0)   8 # EBP SUB
   EDX 8 [EBP] MOV   EAX 4 [EBP] MOV
   ECX 0 [EBP] MOV   RET   END-CODE

: (INCLUDES) ( -- )
   >MAPPED @ IF
      [DEFINED] ?SCRIPT [IF]  >MAPPED CELL+ @
      ?SCRIPT IF  REFILL-NEXTLINE DROP  THEN  [THEN]
      BEGIN  REFILL-NEXTLINE  WHILE  MONITOR
   INTERPRET  REPEAT  THEN ;

: INCLUDE-FILE ( fid -- )
   SAVE-INPUT N>R  >IN OFF  LINE OFF
   DUP 'SOURCE-ID !  MAP-FILE ?DUP ( *) 0= IF
      2DUP 2>R  >MAPPED 2!  ['] (INCLUDES) CATCH ( *)
   DUP IF  .FERROR  THEN  2R> UNMAP-FILE DROP  THEN
   SOURCE-ID CLOSE-FILE  DROP  NR> RESTORE-INPUT DROP
   ( *) THROW ;



\ Updated version of INCLUDE from Leon W that
\ doesn't call =FILENAME twice, and doesn't
\ call it at all if the file doesn't define
\ any new definitions.
\ I'm keeping CROSSREF anyway.
: INCLUDED ( c-addr u -- )   /INCLUDE
  1 nesting +!
    
  R-BUF  R@ FULLNAME                   \ qualify the name

  include-logging @ if
    cr  nesting @ 2 * spaces
    \ basename only:
    r@ zcount -path type
    \ fully qualified: 
    \ r@ zcount type
  then


  R@ ZCOUNT R/O OPEN-FILE THROW        \ open the file
  R> 'FNAME @ >R 'FNAME !              \ point 'fname to our name
  F# @ >R  FNUM++                      \ save starting F#, make us new
  LAST @ >R                            \ see if any new definitions
  ['] INCLUDE-FILE CATCH ( *)          \
  DUP IF  NIP  THEN                    \ ior, discarding remainder
  LAST @ R> <> IF                      \ no change in LAST, skip locate name
    HERE FENCE @REL = >R              \ was the last thing a GILD?
    F# @ 'FNAME @  =FILENAME          \ keep filename for locate
    R> IF  HERE FENCE !REL  THEN      \ reset FENCE to preserve GILDing
  THEN  R> F# !  R> 'FNAME !           \ restore f# and fname
  INCLUDE/  ( *) THROW                 \ restore 'fname, etc
  
  -1 nesting +!
  ;

: FILENAME ( -- addr len )
   >IN @ >R  BL WORD COUNT  OVER C@ [CHAR] " = IF
   2DROP  R@ >IN !  [CHAR] " WORD COUNT  THEN
   R> DROP  FILENAME-FIXUP 0= IF  2DROP HERE 0  THEN ;

: INCLUDE ( -- )   FILENAME DUP 0= -38 ?THROW INCLUDED ;
