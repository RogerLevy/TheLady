animdata death.scml data/death/animdata/death eyes.scml
death.scml animation death_1 rotating eyes

%actor ~> %death
   0 z !
   start:
      death_1
      0.85 animspeed!
      me [[ perform dup >dspt => -0.005 angle +! ]] parallel
      0.00021 +zoom 
   ;
endp

: death
   \ 1152.0 letterbox!
   clear-sounds clear-blood clean   player disable
   screen middle 600.0 + at %death one drop
   once *neardeath*
   lives @ 2 = if 6 else 3 then 60 * gofor
   fadeout2
   4 60 * gofor
   clear-sounds
   unfade
   stage:deletions
;