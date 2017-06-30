image blood.image data\misc_images\blood.png


2048 %particle pool bloods
\ initializes deletion
[[
   s! [[ struct bloods pool-return ]] particle:delete!
]] bloods each


: clear-blood  [[ particle:delete ]] bloods all-particles ; \ bloods reset-pool ;

\ room for improvement...
: cull-blood   [[ struct >y @ 1202.0 > -exit particle:delete ]] bloods all-particles ;

%actor ~> %bloodrenderer
   stays on
   \ 0.275 0.0 0.01 tint!
   0.5 0.5 0.5 tint!
   0.5 0.5 pivot 2!
   0.75 0.75 scale 2!

   [[ bloods draw-particles ]] ondraw !

   start:   0 perform cull-blood bloods step-particles ;

   ondelete: clear-blood ;

endp

: blooddrop  ( vx. vy. gravity. -- )
   1 bloods pool-free? if
      0 swap blood.image 400 bloods pool-one init-particle
   else
      3drop exit
   then
   ;

0 value blood

: init-blood   clear-blood %bloodrenderer one to blood ;

: .bloods  bloods .particles ;

init-blood
