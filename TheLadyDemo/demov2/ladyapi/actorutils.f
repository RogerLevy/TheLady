
\ ----------------------------------------------------------------------
\ Collision stuff

: hitbox>   ( -- xywh )
            hitbox a!> @+ @+ x 2@ 2+ z @ scrolled  @+ @+ ;

: 1/viewfactor  1e viewfactor @ p>f f/ ;

: ofs  0.5 dup 2+ ;

: draw-hitbox   hitbox>  xyxy   2swap   ofs 2p>f  ofs 2p>f  1e 0e 0e 1e 1/viewfactor  al_draw_rectangle ;

: colliding?   ( me=obj1 ; obj2 -- flag )
   { hitbox> xyxy } hitbox> xyxy overlap? ;

0 value you

\ all are checked; last one colliding (if any) is returned
: ?collideany   ( array -- false | stageobj )
   me to you   0 [[ @ { you colliding? if drop me then } ]] rot each ;

0 value flags
defer response

: collides ( flags response )  ( actor -- )
   ['] response >body @ >r   is response   flags >r   to flags   you >r   me to you  
      [[ cflags @ flags and if you colliding? if me you { response } then then ]] all
   r> to you r> to flags r> is response ;

: cflags?   cflags @ and ;


\ ----------------------------------------------------------------------
\ Positioning utils


\ for displayobjects et al
: put  2?p x 2! ;
: +put 2?p x 2+! ; 
   \ ex:  1500 500 put
   \ ex:  view 0.25 0.75 around put
   \ ex:  view middle put
   
: vel!  2?ps vel 2! ;
: halt  0 0 vel! ;
: travel  ( angle|. speed|. -- )
   2?ps 2vec vel 2! ;

\ work with vectors or displayobjects or entities or actors...
: near ( angle|. dist|. target -- x. y. )
   >r 2?p 2vec r> >x 2@ 2+ ;
   \ ex:  45 100 player near put
   
: from   ( x|. y|. target -- )
   >r 2?p r> >x 2@ 2+ at ;

: proximal?  ( x. y. x. y. dist. -- flag )
   >r 2- 2length r> <= ;

\ ----------------------------------------------------------------------
\ Picking utils

: which ( xt -- ... n ) ( -- flag )
   locals| xt |
   0 [[ xt execute if me swap 1 + then ]] all ;

: typecount ( prototype -- n )
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
: inradius ( x. y. radius. -- ... n )
   locals| r y x |
   0 [[ me x y r proximal? if me swap 1 + then ]] all ;
   
\ get actors within a rectangle
: inrect ( xyxy. -- ... n )
   2?p 2swap 2?p 2swap locals| d c b a |
   0 [[ hitbox> a b c d overlap? if me swap 1 + then ]] all ;

\ itterate on items on stack
: execs   ( ... n xt -- ) ( item -- )
   swap 0 ?do >r r@ execute r> loop drop ;

: ethnocide ( prototype -- )
   allof [[ delete ]] execs ;

\ push into an array
: pushes  ( ... n array -- )
   locals| a | 0 ?do a push loop ;

\ pop from an array
: pops    ( array n -- ... n )
   locals| l a | l 0 ?do a pop loop l ;

: popall   dup length pops ;

\ ----------------------------------------------------------------------
\ Spacial utils

: scale*   scale 2@ 2p* ;
: uscale!   dup scale 2! ;   \ uniform scale


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

: another   ( entity -- stageobj )
   stageobj:instance { me over >enttype @ dup >r clone   r> *entid   pen 2@ x 2!  me } ;

: morph   ( prototype -- )
   x 2@ at me init-entity ;

\ ----------------------------------------------------------------------
\ Interactive development utils

0 value lasttype

: (update)  ( prototype entity -- )
   over to lasttype {
      dup >proto @ >actorvt @  
      actorvt ! enttype !
   } ;
   
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
   x 2@ 2dup view xyxy overlap? ;

: outofsight?
   onscreen? not ;
   
: screencull
   outofsight? if me delete exit then ;

: atop     >priority @ 1 + nextpri ! ;
: beneath  >priority @ 1 - nextpri ! ;



\ TODO: i'd like to make it possible to as an option *conditionally* change the animation
\   only if it's not the current animation.  (this option gets reset with each call to ANIMATE and ANIMATE! )
: animation  ( animdata -- <name> <path> )
   create dup use-scml namespec find-animation , , does> 2@ animdata! animate! ;



\ ----------------------------------------------------------------------
\ Scripting Tools

: enttype$  enttype @ body> >name count ;
: autoprio   " =" enttype$ 1 /string strjoin uncount find if execute priority ! else drop then ;
: script   ( prototype -- ) >proto @ ?dup 0= if prototype then be  actor:define   autoprio ;
: start:   behavior:   ;
: restart   oninit @ execute ;
: disable   ['] noop 'post ! nod ;



\ ----------------------------------------------------------------------
\ General purpose actors

: drawblip   pen 2@ 2p>f s>f tint 4p@f al_draw_filled_circle ;

%actor begets %blip
   10 var: blipsize
   [[ x 3@ scrolled at blipsize @ dspt -> drawblip ]] ondraw !
endp

%actor begets %solidoverlay
%solidoverlay script
[[
   blendmode @ colorfx   -2e -2e vres 2@ 4 4 2+ 2s>f   tint@ 3p>f alpha@ p>f al_draw_filled_rectangle
]] ondraw !
endp


\ ----------------------------------------------------------------------
\ Common scripts

: slowfade   cflags off   0 perform   -0.004 alpha+!   alpha@ 0= when    end ;

: +zoom   perform  dup dup scale 2+! ;

   %script begets %fadescript
      var onend
      var target \ actor
      var destval
   endp

: fade   ( speed. onend-xt -- )
   me [[ 
      target ! onend !
      ( speed. ) perform
         target @ { dup alpha+! alpha@ } dup 0 = swap 1.0 = or when onend @ target @ { execute } end 
   ]] %fadescript setoff
;

: fadeto   ( speed. to. onend-xt -- )
   me [[ 
      target ! onend ! destval !
      ( speed. ) perform 
         dup 0< if  
            perform target @ { dup alpha+! alpha@ } destval @ <= when onend @ destval @ target @ { alpha! execute } end 
         else
            perform target @ { dup alpha+! alpha@ } destval @ >= when onend @ destval @ target @ { alpha! execute } end 
         then
   ]] %fadescript setoff
;

: heavens   view 0.01 0.99 between 0 around ;
