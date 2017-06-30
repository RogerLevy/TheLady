\ ==============================================================================
\ ForestLib
\ Floating point extensions mainly for dealing with external libraries
\ ========================= copyright 2014 Roger Levy ==========================


\ Words for passing floats and doubles to DLL's:
iCODE 4sfparms ( f: x y z t -- ) ( s: -- x y z t )
    4 >fs \ make sure data on hardware stack
    16 # EBP SUB \ room for 4 integers and tos
    12 [EBP] DWORD FSTP                         \ convert t
     0 [EBP] DWORD FSTP                         \ convert z
     4 [EBP] DWORD FSTP                         \ convert y
     8 [EBP] DWORD FSTP                         \ convert x
    12 [EBP] EBX XCHG                           \ swap t and old tos
    RET END-CODE

iCODE 1dfparms ( f: x -- ) ( s: -- xl xh )
    >f                                          \ make sure data on hardware stack
    8 # EBP SUB \ make room for double
    0 [EBP] QWORD FSTP \ convert
    4 [EBP] EBX XCHG \ swap xh and old tos
    RET END-CODE

iCODE 3sfparms ( f: x y z -- ) ( s: -- x y z )
    3 >fs                                       \ make sure data on hardware stack
    12 # EBP SUB                                \ room for 3 integers and tos
     8 [EBP] DWORD FSTP                         \ convert z
     0 [EBP] DWORD FSTP                         \ convert y
     4 [EBP] DWORD FSTP                         \ convert x
     8 [EBP] EBX XCHG                           \ swap z and old tos
    RET END-CODE

iCODE 2sfparms ( f: x y z -- ) ( s: -- x y z )
    2 >fs                                       \ make sure data on hardware stack
    8 # EBP SUB                                \ room for 2 integers and tos
     4 [EBP] DWORD FSTP                         \ convert y
     0 [EBP] DWORD FSTP                         \ convert x
     4 [EBP] EBX XCHG                           \ swap z and old tos
    RET END-CODE

iCODE 1sfparms ( f: x -- ) ( s: -- x )
    1 >fs                                       \ make sure data on hardware stack
     4 # EBP SUB                                \ room for 1 integers and tos
     0 [EBP] DWORD FSTP                         \ convert x
     0 [EBP] EBX XCHG                           \ swap x and old tos
    RET END-CODE

iCODE FTHIRD ( -- ) ( r r r -- r r r r )
   3 >fs   ST(2) FLD   4 fs>   FNEXT


aka 1sfparms 1sf
aka 2sfparms 2sf
aka 3sfparms 3sf
aka 4sfparms 4sf

aka 1dfparms 1df
macro: 2df  1df 2>r 1df 2r> ;
: 3df  1df 2>r 1df 2>r 1df 2r> 2r> ;
: 4df  1df 2>r 1df 2>r 1df 2>r 1df 2r> 2r> 2r> ;
: 5df  1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2r> 2r> 2r> 2r> ;
: 6df  1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2r> 2r> 2r> 2r> 2r> ;
: 9df  1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df 2>r 1df
       2r> 2r> 2r> 2r> 2r> 2r> 2r> 2r> ;
: 0e    STATE @ IF POSTPONE #0.0e ELSE #0.0e THEN ; immediate
: 1e    STATE @ IF POSTPONE #1.0e ELSE #1.0e THEN ; immediate
macro: 2s>f  swap s>f s>f ;
macro: 3s>f  rot s>f swap s>f s>f ;
\ : f@+   dup f@ 8 + ;
\ : sf@+   dup sf@ cell+ ;
macro: c>f   s>f 255e f/ ;


: fValue    ( "name" -- )
    Create f,   immediate does> state @ if s" literal f@ " evaluate exit then
    f@  ;

: fto   ( f: v -- )
    ' >body    state @
    if   postpone literal
         postpone f!
    else f!
    then ; immediate
