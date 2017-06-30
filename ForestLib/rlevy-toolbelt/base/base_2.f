\ ==============================================================================
\ ForestLib
\ Base of toolbelt
\ ========================= copyright 2014 Roger Levy ==========================

\ ------------------------------------------------------------------------------
\ Floating-point

true constant HW-FLOAT-STACK 
include fpmath  \ note this version adds fixed point recognition to the interpreter

: f?  f@ f. ;
aka (f>s) f>s  \ disables rounding.  this fixes random crashes.

\ ------------------------------------------------------------------------------
\ fixed -EXT

: ENDING ( addr len char -- addr len )
   >R BEGIN  2DUP R@ SCAN
      ?DUP WHILE  2SWAP 2DROP  1 /STRING
   REPEAT  R> 2DROP ;

: -EXT ( a n -- a n )
   2dup [char] . scan nip 0= ?exit \ no dot
   2DUP  [CHAR] . ENDING  NIP -  1-  0 MAX ;

\ ------------------------------------------------------------------------------
cd qfolder
include qfolder
cd ..

include include         \ modified version of SwiftForth's INCLUDE that supports disabling cross-reference data
include nonstandard_2   \ so-called because it changes 2+ , @+ , pushpath , 2@ , and more.

\ ------------------------------------------------------------------------------
