\ relies on:
\  %displayobject

\ --------------------------------------------------------------------------------
\ entity (game object instance) 
\ relies on: /cgridbox %displaytransform entities max-entities

\ all entities are stored in one main pool.  they live on an imaginary plane
\ called the "stage".  for now there's just one stage, but it should be possible
\ to add more.
\ provisions are made to allow additional entities beyond the main pool,
\ for things like decorative particle generators or scenery.
\ entities can be up to /entslot in size.  

fload displayobject

variable nextpri
variable nextid
%displayobject ~> %entity
   var myid
   24 field myname
   : .name   myname count type space ;
   
   %entity var: enttype

   $DEADBEEF var: priority
\   /cgridbox field ahb                 \ absolute hitbox, for the collision grid
   100 var: hp
\   %animator inline: anm
   var cflags   \ collision mask
   mark: hitbox  0 ^ 0 ^ 100.0 ^ 100.0 ^         \ local - x,y,w,h
   4 cells field hitbox
   var bmp                                \ default bitmap.  
   \  var activebits   var pausedbits     \ define what processing to perform at what times, unused for now
   var stays
   var flip
   var blendmode
   noop: onpost
   var deleted
endp

: be-prototype   prototype be dspt s! ;


\ : n>   bl parse number ;

: hitbox:   [char] ; parse evaluate   4?p hitbox 4! ;




\ --------------------------------------------------------------------------------
\ common backend processing


PACKAGE OPTIMIZING-COMPILER
public
\ optimizing? @ [if]
\    : *entid
\       drop ;
\ [else]
   : *entid
      body> >name count 1 /string myname place
      " -" myname append
      nextid dup @ dup (.) myname append
                      myid !
                 ++ ;
\ [then]
END-PACKAGE


\ Initialize an entity
: init-entity   ( prototype entity )
   be>  dup me initialize dup *entid enttype !
      pen 2@ 2?p x 2!
      priority @ $DEADBEEF = if nextpri @ priority ! nextpri ++ then
      hitbox hitbox 4 imove
      dspt =>    oninit @ execute
;

: enttype$  enttype @ body> >name count ;
: autoprio   " =" enttype$ 1 /string strjoin uncount find if execute priority ! else drop then ;
