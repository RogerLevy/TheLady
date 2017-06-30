\ ==============================================================================
\ ForestLib
\ Regions dev session loader
\ ========================= copyright 2014 Roger Levy ==========================

+opt
\ -opt

: _poppath poppath ;
\ pushpath cd ..\..\ForestLib\rlevy-toolbelt
include rlevy-toolbelt
\ _poppath

\ cd src !home pushpath   \ make sure we're dropped off in the src folder, preventing file path conflicts during testing

[defined] startfolder [if]
   startfolder count z$ SetCurrentDirectory drop 
[then]

gild

\ this is loaded by the toolbelt now
\ fload regions


regions +order \ for testing
definitions


\ test

defer xt
: eachsr ( xt region -- ) ( subregion -- )
   swap is xt >lastsr @ begin ?dup while dup >r xt r> >regprev @ repeat ;
   

region r 
r 123 reserve constant a1
r 16384 reserve constant a2

\ r reclaim

\ r 123 reserve drop
\ r 16384 reserve drop


\ 12345 new-subregion constant s1
\ 123456 new-subregion constant s2
\ 12345 new-subregion constant s3

\ s1 free-subregion
\ s2 free-subregion
\ s3 free-subregion
