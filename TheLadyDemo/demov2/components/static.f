animdata static.scml data\tv\animdata\static.scml
static.scml animation static_anim NewAnimation_000
sample *static* data\tv\3 door.ogg

%actor begets %static
%static script
   0 z !
   static_anim
endp


: freezefor  allowinput off poll +timer for frame(s) next -timer allowinput on ;

: static
   looped *static* 1.5 sndspd! 2.2 sndvol! snd
   0 0 at %static one dup { 2.0 dspt -> uscale! }
   25 freezefor \ temporary total freeze; ensure no player control
   delete stopsound
;
