
\ ----------------------------------------------------------------------
\ Collision stuff

variable show-hitboxes  \ show-hitboxes on


: box/actor
   a!>    @+ @+ x 2@ 2+   z @ scrolled    @+ @+ ;

: hitbox>   ( -- xywh )
   hitbox box/actor ;

: 1/viewfactor  1e viewfactor @ p>f f/ ;

: ofs  0.5 dup 2+ ;

: draw-hitbox   hitbox>  xyxy   2swap   ofs 2p>f  ofs 2p>f  1e 0e 0e 1e 1/viewfactor  al_draw_rectangle ;
: ?draw-hitboxes   show-hitboxes @ -exit  0 colorfx   [[ draw-hitbox ]] all ;

: colliding?   ( obj1 obj2 -- flag )
   >r { hitbox> } xyxy r> { hitbox> } xyxy overlap? ;

0 value you

\ all are checked; last one colliding (if any) is returned
: ?collideany   ( array -- false | stageobj )
   me to you   0 [[ @ { me you colliding? if drop me then } ]] rot each ;

0 value flags
defer response

: collides ( cflags response -- )  ( me=collider-actor you=collider-actor; -- )
   ['] response >body @ >r   is response   flags >r   to flags   you >r   me to you
      [[ cflags @ flags and if me you colliding? if response then then ]] all
   r> to you r> to flags r> is response ;

: cflags?   cflags @ and ;


\ -------------------------------------------------   ---------------------
\ Positioning utils


\ for displayobjects et al
: put  2?p x 2! ;
: +put 2?p x 2+! ;
   \ ex:  1500 500 put
   \ ex:  view 0.25 0.75 around put
   \ ex:  view middle put


: vel!  2?ps vel 2! ;
: halt  0 dup dup vel! speed ! ;

: travel  ( angle|. speed|. -- )
   2?ps 2vec vel 2! ;
: travelling ( -- angle. speed. )
   vel 2@ 2ang vel 2@ 2length ;

\ work with vectors or displayobjects or entities or actors...
: near ( angle|. dist|. target -- x. y. )
   >r 2?p 2vec r> >x 2@ 2+ ;
   \ ex:  45 100 player near put

: near?  ( x. y. x. y. dist|. -- flag )
   ?p >r 2- 2length r> <= ;

: closeby?  ( obj1 obj2 dist|n -- flag )
   >r >r >x 2@ r> >x 2@ r> near? ;

\ ----------------------------------------------------------------------
\ Picking utils

: which ( xt -- ... n ) ( -- flag )
   locals| xt |
   0 [[ xt execute if me swap 1 + then ]] all ;

: oneof
   dup >r rnd pick r> nips ;

: onewhich  ( xt -- n | 0 ) ( -- flag )
   which dup -exit oneof ;

: numberof ( prototype -- n )
   locals| t |
   0 [[ enttype @ t = if 1 + then ]] all ;

\ get actors of a certain type
: allof ( prototype -- ... n )
   locals| t |
   0 [[ enttype @ t = if me swap 1 + then ]] all ;

: id>  ( name c -- actor | 0 )
   locals| c n |
   0 [[ myname count n c compare 0= if drop me then ]] all ;

\ pick a random actor of type
: any ( prototype -- stageobj )
   allof ?dup 0= abort" Error in ANY : There aren't any actors of the given type on the stage."
   dup >r rnd pick r> swap >r drops r> ;


\ get actors within a circle
: inradius ( x. y. radius|. xt -- ... n )
   locals| xt r y x |
   0 [[ me >x 2@ x y r near? xt execute and if me swap 1 + then ]] all ;

\ get actors within a rectangle
: inrect ( xyxy. -- ... n )
   2?p 2swap 2?p 2swap locals| d c b a |
   0 [[ hitbox> a b c d overlap? if me swap 1 + then ]] all ;

\ itterate on items on stack
: execs   ( ... n xt -- ) ( item -- )
   swap 0 ?do >r r@ execute r> loop drop ;

: genocide ( prototype -- )
   allof [[ delete ]] execs ;

\ push into an array
: pushes  ( ... n array -- )
   locals| a | 0 ?do a push loop ;

\ pop from an array
: pops    ( array n -- ... n )
   locals| l a | l 0 ?do a pop loop l ;

: popall   dup length pops ;

: countof   dup >r drops r> ;

\ ----------------------------------------------------------------------
\ Spacial utils

: scale*   scale 2@ 2p* ;
: uscale!   dup scale 2! ;   \ uniform scale
: uscale*!  dup scale* scale 2! ;

\ get xyxy covered by displayobjects or vectors
\ TODO

\ get midpoint and radius of displayobjects or vectors
\ TODO (it's really involved - see http://nayuki.eigenstate.org/res/smallest-enclosing-circle/smallestenclosingcircle.js)

\ get averaged midpoint of displayobjects or vectors
: avgpos ( ... n -- x. y. )
   dup 0 <= abort" Error in AVGPOS : No entities given, or invalid length."
   0 0 locals| ay ax |
   0 do
      >x 2@ ay -  i 1 +  /  +to ay
            ax -  i 1 +  /  +to ax
   loop ax ay ;


\ ----------------------------------------------------------------------
\ Instance utils

: another   ( stageobj -- stageobj )
   stageobj:instance { me over >enttype @ dup >r clone   r> *entid   pen 2@ x 2!  me } ;

: morph   ( prototype -- )
   x 2@ at me init-entity ;

\ ----------------------------------------------------------------------
\ Interactive development utils

0 value lasttype

: entproto   enttype @ >proto @ ;

\ idea: could be enhanced to use SAVEPROPS and LOADPROPS internally to retain some state.
: (update)  ( prototype entity -- )
   { morph } ;
\   over to lasttype {
\      dup >proto @ >actorvt @
\      actorvt ! enttype !
      \ kludge
      \ entproto >ondraw @ ondraw !
      \ entproto >ondelete @ ondelete !
      \ entproto >oninit @ execute        
      
\   } ;

\ convenient way to change a vtable for a specific prototype at the commandline
: actions  ( prototype -- )   \ overload
   >proto @ >actorvt @ to vt ;

\ these could help when/if the folder tree ever gets complex enough ...
\ but they are mainly useful for updating entities already on the stage

\ reload entity's prototype from source and replace the vtable and enttype
: update  ( entity -- )
   dup >enttype @ locals| t e |
      t >ppath count 2dup type $reload
      t body> >name find 0= abort" File reloaded, but the new version of the prototype wasn't found."
      execute e (update)
   ;

\ reload all actors of a certain prototype's file(s)
\ THIS IS WRONG, 1) it shouldn't abort if no entities of that type and 2 it shouldn't UPDATE each one,
\  it should just UPDATE one and (UPDATE) the rest
\ : revamp  ( -- <prototype> )
\    ' execute
\   allof ?dup 0= abort" Error in REVAMP : No actors of that type are on the stage."
\   swap update 1 - [[ lasttype swap (update) ]] execs ;


\ ----------------------------------------------------------------------
\ Misc

: center-bitmap-box  ( bitmap scale. -- xywh )
   swap bitmap-size 2p rot dup 2p* 2dup -0.5 dup 2p* 2swap ;

: corner-bitmap-box  ( bitmap scale. -- xywh )
   over >r center-bitmap-box 2swap r> bitmap-size 2p 0.5 0.5 2p* 2+ 2swap ;

: onscreen?
   x 2@ 2dup myview xyxy overlap? ;

: outofsight?
   onscreen? not ;

: screencull
   outofsight? if end exit then ;

: atop     >priority @ 1 + nextpri ! ;
: beneath  >priority @ 1 - nextpri ! ;


\ ----------------------------------------------------------------------
\ Scripting Tools

: escript   be   actor:define   ;
: script   ( prototype -- ) >proto @ ?dup 0= if prototype then   escript ;
: start:   behavior:   ;
: enable    ?dup -exit { vis on   en on } ;
: restart   ?dup -exit { me enable   oninit @ execute } ;
: disable   ?dup -exit { vis off  en off } ;


: haltall   [[ 0.0 animspeed! halt nod ]] all ;

: pauseall  [[ en off ]] all ;
: resumeall  [[ en on ]] eaeo ;

: propel   ( vx. vy. time|. entity -- )
   { nod -rot vx 2! ( time ) [[ delay owner @ { idle } end ]] parallel } ;

: xdist   >x @ swap >x @ - abs ;
: close?   ( object dist|. -- ) ?p swap me xdist swap <= ;

pstruct %params
   9 cells +
endp
256 %params pool params
: >params ( ... n --- params )
   dup >r reverse r>  params pool-one dup a!> >r dup !+ 0 do !+ loop r> ;
: params@ ( params -- ... )
   a!> @+ 0 do @+ loop ;
: params/ params pool-return ;
: params> dup >r params@ r> params/ ;

: pos@  >pos 2@ ;

: sendto   ( object x. y. speed. )
   locals| spd y x obj |
   x y obj pos@ 2- spd 2chop obj >vel 2!
   x y 2dup obj pos@ 2- 2length spd p/ 1i obj swap ( x y object #steps )
   4 >params [[ params> pauses { halt pos 2! } end ]] parallel
;


%script ~> %attacher
   [i var it i]

   : detach ( object -- )
      >owner off ;

   : attach ( object holder -- )
      { dup { halt } dup >x 2@ x 2@ 2- third >lx 2!
      [[ it ! post owner @ >x 2@ it >lx 2@ 2+ it >x 2! ]] %attacher setoff } ;
      
endp

: timebomb ( delay -- ) [[ delay owner @ kill end ]] parallel ;


\ directional stuff (some lady-specific)
: ?face   direction @ left = 1 and flip ! ;
: dir!    direction ! ?face ;
: ?leftright   ( entity -- direction ) >x @ x @ < if left else right then ;
: approaching?
   dup >vx @ if dup ?leftright swap >direction @ <>
   else drop false then ;
: retreating?
   dup >vx @ if approaching? not else drop false then ;
: ?neg   direction @ left = if negate then ;



: bmpw   bmp @ bitmap-size drop 1p ;
: bmph   bmp @ bitmap-size nip  1p ;

: ?flash   invuln @ 2 every and if vis toggle else vis on then ;

: -vx      vx @ negate vx ! ;
