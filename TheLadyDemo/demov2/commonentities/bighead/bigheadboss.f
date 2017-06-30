C_SHOOTABLE C_REPEL or C_HARMFUL or value bighead-cflags

absent "glassfalling" ?fload glassfalling

%actor begets %harmfulzone
%harmfulzone script
   C_HARMFUL C_REPEL or cflags !
   vis off
   default-hitbox: -250.0 -250.0 500.0 500.0 ;
endp

%boss begets %bigheadboss

   var bgm

%bigheadboss script
bighead-cflags cflags !
bighead_idle
default-hitbox: -150.0 -150.0 300.0 300.0 ;

: ?*glass*  once hp @ 1 and if *glass1* else *glass2* then ;

: whiteflash
   [[ FX_ADD blendmode ! 0 alpha! 0.004 1.0 .. fadeto
      0 perform 5.0 delay 1 pauses end
   ]] %solidoverlay setoff ;

:: die
   glassfalling off
   bgm @ snd! 1.3 sndvol! 0.5 sndspd!
   whiteflash

   0 perform

   5.0 delay
   
   bgm @ stopsound
   owner @ ?dup if { removered end } then

   \ player appears laying on the floor
   calm player emote
   player { right direction ! cam @ 300.0 + x ! lady_floor_twitching }

   \ FOR DEMO: no player control, fade out and return to title

   player { nod }
   clear-blood
   complete
   end
;

: harmmotion
   -18.5 vx ! 0 perform 0.45 delay halt 0.6 delay end
;

: hairwhip
   bighead_attack 0 0 me from %harmfulzone one perform { harmmotion } 3.0 delay idle
;

: faster
   10 hp @ - 0.2 * 1.0 + animspeed! ;

:: idle
   bighead_idle faster 0 perform  3.0 4.0 between delay   hairwhip
;

: rainglass   ?*glass*  18 hp @ - shards ;
   
:: hurt
   negate hp +! cflags off 
   redflash once *bigheadimpact* 0.89 sndvol!  bighead_gethit faster
   0 perform
   0.04 delay  rainglass
   hp @ 5 <= if bgm @ snd! 1.2 sndvol! 1.001 sndspd! then
   hp @ 0 = if die exit then
   3.0 delay   bighead-cflags cflags !  hairwhip
;

start:
   10 hp !
   looped *bigheadbgm* snd bgm ! 1.1 sndvol!
   3 glassfalling !  1.25 glassfreq !
   hairwhip
;

endp
