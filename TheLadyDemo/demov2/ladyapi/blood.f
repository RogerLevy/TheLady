
1024 constant #bloods

create bloods   #bloods %particle sizeof array,
create freeblood    #bloods stack,

: blood:delete   struct freeblood push ;
: blood-instance freeblood pop ;

[[ dup freeblood push => ['] blood:delete particle:delete! ]] bloods each

: clear-blood
   [[ particle:delete ]] bloods all-particles ;

: draw-blood
   bloods draw-particles ;

\ room for improvement...
: cull-blood
   [[ struct >y @ vh 1p 50.0 + > if particle:delete then ]] bloods all-particles ;

%actor begets %bloodrenderer
%bloodrenderer script
   stays on
   0.275 0.0 0.01 tint!
   0.5 0.5 pivot 2!
   0.155 0.155 scale 2!

   [[ draw-blood cull-blood ]] ondraw !
   ondelete: clear-blood ;
endp

: blooddrop  ( vx. vy. gravity. -- )
   0 swap circle64.image 400 blood-instance init-particle ;

0 value blood

: init-blood
   clear-blood %bloodrenderer one to blood
;

: .bloods  bloods .particles ;

init-blood
