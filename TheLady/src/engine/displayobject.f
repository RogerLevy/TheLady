\ module ~displayobject

0 value me   \ the current entity

: be   to me ;
code be>
   &of me [u] eax mov
   ebx &of me [u] mov \ set me
   pop(ebx)
   0 [esp] ecx mov    \ get return addr
   eax 0 [esp] mov    \ save me
   ecx call
   eax pop
   eax &of me [u] mov
ret 

: {   me >o to me ;
: }   o> to me ;


\ all transforms are "local"
pstruct %displayobject
   : displayobject-fields  [[ create over , + does> @ me + ]] is create-ifield ;
   [[ displayobject-fields ]] fields
   
   %displaytransform inline: dspt
      \ it's important to not touch the placement of this because it allows us
      \ to treat displayobjects directly as vectors.

   mark: vel                           
   var velx  var vely  var velz
   
   true var: active                    \ means something exists in this object, for allocation
   true var: en   true var: vis        \ flags: enabled, visible
   
   noop: oninit
   noop: ondelete
   noop: (delete)                         \ any special internal housekeeping that scripting should be oblivious of
   noop: onstep
   noop: ondraw
   noop: (instance)

endp

: (!color) ;
\   dspt >tint a!>
\      red @ 1clamp p>c c!+
\      green @ 1clamp p>c c!+
\      blue @ 1clamp p>c c!+
\      alpha @ 1clamp p>c c!+ ;

\ from here-on-out x y z refer to entity positions.  all mathy vector stuff should be encapsulated in prior files.
\  note that >x >y >z still function the same so they can still be used to access random coordinates if needed!

aka dspt pos
aka >position >pos
: px  pos >x ;
: py  pos >y ;
: pz  pos >z ;
: vx  vel >x ;
: vy  vel >y ;
: vz  vel >z ;
: >vx  >vel >x ;
: >vy  >vel >y ;
: >vz  >vel >z ;

aka px x   aka py y   aka pz z


\ ----------------------------------------------------------------------
\ Logic and drawing

: step   dspt => onstep @ execute ;
: draw   dspt => ondraw @ execute ;
: ?step  en @ -exit  step ;
: ?draw  active @ -exit vis @ -exit draw ;


\ ----------------------------------------------------------------------
\ Color stuff

: alpha@   ( -- a. ) dspt >alpha @ ;
: alpha!   ( a. -- ) 1clamp dspt >alpha ! ;
: alpha+!  ( a. -- ) dspt >alpha @ + 1clamp dspt >alpha ! ;

: tint@    ( -- r. g. b. ) dspt >red 3@ ;
: tint!    ( r. g. b. -- ) dspt >red 3! ;
: tint+!   ( r. g. b. -- ) dspt >red 3+! ;
