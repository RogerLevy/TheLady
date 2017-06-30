\ 11/7/2013 project started

+opt
\ -opt

: _poppath poppath ;
pushpath cd ..\ForestLib\rlevy-toolbelt
include rlevy-toolbelt
_poppath

cd src !home pushpath   \ make sure we're dropped off in the src folder, preventing file path conflicts during testing

[undefined] ~thelady [if]

   session ~thelady

\ -----------------------------------------------------------------------------------------
   \ put files and definitions that should only ever be loaded once per session here.

   fload opengl-lite
   fload allegro5-1 
   fload gameblocks
   
   \ : copyassets   ; \ " copyassets.bat" >shell ;
   : empty   /bal clear-assets close-sound close-allegro empty report" Empty, reset Allegro" ;
   
\ -----------------------------------------------------------------------------------------

   512 constant /entslot
   1024 constant max-entities
   8 constant #levels          \ 1-6 are the actual levels + the ending, first and last will both point to "limbo"
                               \ The level # is clamped, so if ever an invalid one is travelled to, the player gets dropped there.

gild 

[then]

\ -----------------------------------------------------------------------------------------

pwd

[defined] startfolder [if]
   startfolder count z$ SetCurrentDirectory drop 
[then]

fload go