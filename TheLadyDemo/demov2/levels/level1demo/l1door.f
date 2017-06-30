animdata l1door.scml data\l1door\lv1door.scml
l1door.scml animation l1door_anim NewAnimation

%door begets %l1door
%l1door script

default-hitbox: -50.0 -781.0 100.0 781.0 ;
l1door_anim  

1.1 scale >x !

start:
   0 perform
      begin
         0.3 1.3 between animspeed!   \ jittery animation playback
         0.1 0.3 between delay
      again
;

endp
