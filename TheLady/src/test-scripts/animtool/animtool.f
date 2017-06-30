(
 to load files,
  1 - hit ctrl+o to open file via dialog
   or
  2 - drag and drop files into the graphics window
   or
  3 - load with commandline
 both #1 and #2 insert commands into the console so they can be reloaded via command history.

 automatic reloading when files are updated is coming soon.

 all instances use indices rather than pointers
 so reloading the scml should be seamless
 
 mouse controls:
 
 keyboard controls:

)

engine

10 constant #maxfiles
0 value currentfile    \ index
0 value ci \ curreint instance, index

: instances,   swap 0 do dup instance, loop drop ;

%actor ~> %animinstance
   var curfile
   var curanm
   var placed
endp

[[ >placed off ]] entities each

pstruct %scmlfile
   256 field path
   /array field animations
endp

create files   #maxfiles %scmlfile 2dup sizeof array> instances,
create backup-files   #maxfiles %scmlfile 2dup sizeof array> instances,


variable ps
: clear-files   ps off ;
: +file  ( addr c -- %scmlfile )
   report" Added file: " 2dup type
   ps @ files [] dup >r >path place   ps @ 1 + dup #maxfiles >= abort" Max files reached" ps !
   r> ;

create scmls   10 stack,


also ~spriter
: destroy-bitmaps
   [[ @
      [[ @
         [[ @
            >bmp @ destroy-asset
         ]] swap >files each
      ]] swap >folders each
   ]] scmls each ;
previous   

: current-instance   ci entities [] ;

: gather-animations  ( struct=scmlfile )
   scmls top@ to scml
   64 cell animations -> *stack
   [[ animations push ]] each-animation ;
   
: init ( me=instance )
   placed @ not if
      %animinstance me initialize
   then
   currentfile curfile !
   curfile @ scmls [] @ animdata!
   placed @ not if
      0 curanm !
      \ cr curanm ?
      0 0 animate
      \ cr curanm ?
      vres 2@ 2s>p 0.5 0.5 2p* px 2!
      \ cr curanm ?
      vis on
      placed on
   then
   
   ;


: add-scml  ( addr c -- )
   2dup spriter-schema scmls push +file -> gather-animations
   scmls length 1 - dup to ci to currentfile
   current-instance e-> init ;

: add-scml-dialog
   z" ."  z" Add SCML file" z" *.scml" 0 al_create_native_file_dialog locals| d |
   0 d al_show_native_file_dialog if
      d 0 al_get_native_file_dialog_path zcount add-scml
   then
   ;

: current-file  ( me=instance; -- %scmlfile )
   curfile @ files [] ;

: +ca  ( me=instance; n -- )
   current-file >animations locals| animations |

   curanm @ + 0 animations length wrap curanm !
   curanm @ animations [] @ animate!
   cr curanm dup ? @ animations [] @ count type ;

: +cfi  ( me=instance; n -- )   \ current file instance
   ci + 0 scmls length wrap to ci
   cr ci . ci files [] count -path type ;

: backup   files backup-files copy ;
: cleanup   destroy-bitmaps   clear-files   scmls vacate   empty  ;
: reload   [[ >path count add-scml ]] backup-files each ;
: refresh   scmls length -exit   backup cleanup reload ;
: rewind   me    scmls length 0 ?do  i entities [] be 0 animpos!  loop   be ;
: clear   cleanup  [[ >placed off ]] entities each ;
: straighten   1.0 dup dspt >scale 2!   0 dspt >rotation >z ! ;

: help
cr
report" === ANIMATION TESTING TOOL === "
cr
report" -- Controls -- "
cr
report" Mouse: "
report"  Drag anywhere to move the current animation around."
cr
report" Keyboard: "
report" <f1>                 help" 
report" <f5>                 refresh "
report" <ctrl>+<a>           add file "
\ report" <ctrl>+<l>           change current file "
report" <tab> <shift+>+<tab> switch between playing files "
report" <q> <w>              rotate "
report" <e> <r>              scale "
report" <backspace>          reset transformation "
report" <z> <x>              cycle through animations "
report" <f>                  toggle double speed "
report" <space>              pause/unpause "
report" <enter>              rewind all animations "
report" <ctrl>+<n>           clear animations "
cr ;

: toggle-speeds
   me    scmls length 0 ?do  i entities [] be 
      animspeed@ 2.0 <> if 2.0 else 1.0 then animspeed! 
   loop   be ;
   
: instance-controls
   current-instance be>
   1 mousebtn if mdelta 2s>p viewfactor @ dup 2p/ px 2+! then
   dspt =>
   <q> kstate if 1.0 rotation >z +! then
   <w> kstate if -1.0 rotation >z +! then
   <e> kstate if -0.05 dup scale 2+! then
   <r> kstate if 0.05 dup scale 2+! then
   <z> kpressed if -1 +ca  then
   <x> kpressed if 1 +ca then
   <a> kpressed ctrl? and if add-scml-dialog then
   <n> kpressed ctrl? and if clear then
   <f5> kpressed if refresh then
   <space> kpressed if pause-animations toggle then
   <enter> kpressed if rewind then
   <backspace> kpressed if straighten then
   <f> kpressed if toggle-speeds then
   <tab> kpressed if  shift? if -1 else 1 then  +cfi  then
   <f1> kpressed if help then
;


: toolframe
   poll-keyboard poll-mouse
   [[ instance-controls ]] catch ['] throw catch drop
   0 cls
   scmls length 0 ?do   i entities [] be draw     loop
   show-frame pause ;

: ok
   res 2@ set-viewport
   >gfx 
   begin
      ['] toolframe exectime s>f 0.001e f* fto framedelta
   <escape> kpressed until
   >ide ;   

\ Instructions:
wipe help

gild
add-scml-dialog ok 