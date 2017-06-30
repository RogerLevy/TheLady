animdata l1door.scml data\l1door\lv1door.scml
l1door.scml animation l1door_anim NewAnimation

\ jittery animation playback
: fluctuate   begin 0.3 1.3 between animspeed! 0.1 0.3 between delay again ;

%door ~> %l1door

   hitbox: -50.0 -781.0 100.0 781.0 ;
   l1door_anim  
   1.1 scale >x !
   
   start: me doors push 0 perform fluctuate ;

endp
