
pstruct %particle
   [i
   var x   var y   var vx   var vy   var ax   var ay
   var ang   var bmp   var counter
   var val          \ general purpose value
   var 'delete
   i]
   
   : particle:delete   counter off   'delete @ execute exit ;
   
   : step-particles
      struct =>
         [[
            s! counter @ -exit
            vx 2@ x 2+! ax 2@ vx 2+! counter --
            counter @ 0 = if particle:delete then
         ]] swap each ;
   
   : draw-particles  ( array -- )   \ uses current actor's Z and DSPT
      struct =>
      batch[
         flipflags off
         [[
            s! counter @ -exit
            x 2@ pz ( current entity's Z ) @ scrolled 2i at bmp @ entire dspt blitrgnex
         ]] swap each
      ]batch ;
   
   : init-particle ( vx. vy. ax. ay. bitmap life particle -- )
      => counter ! bmp ! ax 2! vx 2! pen 2@ x 2! ;
   
   : particle:delete!   'delete ! ;
   
   0 value xt
   : all-particles ( xt array )
      swap to xt   [[ => counter @ if xt execute then ]] swap each ;
   
   : .particles ( array )
      [[ cr ." XY: " x 2p? ." VEL: " vx 2p? ." ACL: " ax 2p? ." CNT: " counter ? ]] swap all-particles ;

   
endp


\ ==============================================================================================
\ Generator  (WIP)

(
%actor ~> %particlegen
   var particlepool
%particlegen script


endp
)


