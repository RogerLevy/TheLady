\ ---------------------------------------------------------------------------
\ Long room

absent %baby ?fload babyghost
stream *madness* data/l1misc/Nearing the edge 3.ogg

16 constant #babies
variable babies


5.0 1.0 %l1baseroom room: l1r3     L1 Baby ghost room

roomdef defineroom
5.0 vw 1p p* 2 / 1152.0 startpos 2!

variable m

: fade-in-madness
   looped *madness* 0.0 sndvol! 0.85 sndspd! snd m !
   0 [[
      m @ snd! 0.001 + dup 1.0 min sndvol!
      dup 0.6 >= when end
   ]] parallel
;

: shydoor:script
   vis off
   [[ reloadroom ]] ondoor !
   post babies @ ?exit outofsight? if
      vis on [[ north ]] ondoor ! post noop
   then
;

: shydoor
   .. door{ shydoor:script }
;

: l1r3:stuff
   500 bud !
   babies vacate
   #babies for 0 roomw @ 1p between 0 at %baby one babies ++ { [[ babies -- ]] ondelete ! } next
   200.0 1500.0 between ground at
   10 for shydoor 400.0 600.0 between 0 +at next
;

construct:
   \ ambience
   l1-defaultbgm
   fade-in-madness

   \ bg/fg
   l1-defaultbgfg

   \ objects
   l1r3:stuff

   \ scripts
   l1r3:| player emote
;
