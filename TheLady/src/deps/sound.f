
module ~audio

0 value snd

: snd!   to snd ;

ALLEGRO_PLAYMODE_ONCE constant once
ALLEGRO_PLAYMODE_LOOP constant looped
ALLEGRO_PLAYMODE_BIDIR constant bidir

\ floating point tween controller
\  has a destination, speed, destination value, and current value
\  TODO: tweening curves
pstruct %ftweener
   0e sfvar: fval
   0e sfvar: fsrcval
   0e sfvar: fdestval
   0e sfvar: fstep       \ timestep 10ms
   var ftweenflags      \ 1 = enable
   noop: onftweenend
endp


%asset ~> %sample
   var alsmp
   
   : sample:onload  z$ al_load_sample dup 0= abort" Error in SAMPLE:ONLOAD : There was a problem loading a sample."
      alsmp ! ;
      
   ' sample:onload onload !
endp

: sample,  %sample build> asset^ ;


\ sound object
\  abstracts samples, file streams, and dsp streams
\  allows ramped (tweened) changes of volume, pan, pitch
: sound-fields  [[ create over , + does> @ snd + ]] is create-ifield   prototype snd! ;

pstruct %sound   
   [[ sound-fields ]] fields

   var handle
   var playmode
   var juststarted
  
   create sndvt-root 10 vtable,
   sndvt-root var: sndvt   
   [[ @ sndvt @ ]] sndvt-root set-vtable-fetcher
   2 0 action (vol!) \ ( handle sfloat ) 
   2 0 action (pan!) \ ( handle sfloat ) 
   2 0 action (spd!) \ ( handle sfloat ) 
   2 0 action (playmode!) ( handle mode -- )
   2 0 action (seek)   \ ( handle n -- ) unit depends
   1 1 action (pos)
   1 1 action (length) \ ( handle -- n ) unit depends
   1 1 action (finished) ( handle -- flag )
   2 0 action (playstate!) ( handle flag -- )
   1 0 action (kill) ( handle -- )
      
   [[ prototype >sndvt @ vbeget prototype >sndvt ! ]] begetting
 
   %ftweener inline: sndvol   1e sndvol sf!
   %ftweener inline: sndpan   0.0e sndpan sf!   \ -1.0e is left, 1.0e is right.
   %ftweener inline: sndspd   1e sndspd sf!
   0e sfvar: tempvol
   0e sfvar: tempspd
\   var sipa \ sample instance pointer address
\   noop: onsndloop
\   noop: onsndend
   [[ sound-fields sndvt @ to vt ]] fields
endp


\ : smpinst>   sipa @ @ ;


create sounds     #maxsmp %sound sizeof array,
create freesounds #maxsmp stack, [[ freesounds push ]] sounds each

: smpinst>   snd sounds >items - %sound sizeof / sample-instances [] @ ;

: onesound       ( prototype -- sound )
   freesounds length 0= abort" Exceeded maximum sounds. TODO: add sound-stealing or something"
   freesounds pop swap over initialize ;
   
: sound:delete   handle @ (kill) handle off snd freesounds push report" sound deleted " ;
: clear-sounds   [[ snd! handle @ if sound:delete then ]] sounds each ;

%sound ~> %streamsound
   :: (vol!)       al_set_audio_stream_gain drop ;
   :: (pan!)       al_set_audio_stream_pan drop ;
   :: (spd!)       al_set_audio_stream_speed drop ;
   :: (playmode!)  dup playmode ! al_set_audio_stream_playmode drop ;    
   :: (seek)       ( seconds ) 0 al_seek_audio_stream_secs drop ;
   :: (pos)        al_get_audio_stream_position_secs ;
   :: (length)     ( -- seconds ) al_get_audio_stream_length_secs ; 
   :: (playstate!) al_set_audio_stream_playing drop ;
   :: (finished)   playmode @ once <> if drop 0 exit then dup al_get_audio_stream_position_secs swap al_get_audio_stream_length_secs >= ;
   :: (kill)       al_destroy_audio_stream ;
endp

%sound ~> %samplesound
   :: (vol!)       al_set_sample_instance_gain drop ;
   :: (pan!)       al_set_sample_instance_pan drop ;
   :: (spd!)       al_set_sample_instance_speed drop ;
   :: (playmode!)  dup playmode ! al_set_sample_instance_playmode drop ;
   :: (seek)       ( samples ) al_set_sample_instance_position drop ;
   :: (pos)        al_get_sample_instance_position ;
   :: (length)     ( -- samples ) al_get_sample_instance_length ;
   :: (playstate!) al_set_sample_instance_playing drop ;
   :: (finished)   playmode @ once <> if drop 0 exit then al_get_sample_instance_position 0 <= ;
   :: (kill)       false (playstate!) ;
endp




: playing! ( f )  handle @ swap (playstate!) ;

: sndlength@   handle @ (length) ;


: sound:update
   handle @ dup sndvol @ (vol!)
            dup sndpan @ (pan!)
                sndspd @ (spd!)  ;



\ temporarily doesn't support ramps...
: volramp ( src. dest. speed. ) drop nip p>f 1sf sndvol ! sound:update ;
: panramp ( src. dest. speed. ) drop nip p>f 1sf sndpan ! sound:update ;
: spdramp ( src. dest. speed. ) drop nip p>f 1sf sndspd ! sound:update ;

: sndvol!   0 swap 0 volramp ;
: sndpan!   0 swap 0 panramp ;
: sndspd!   0 swap 0 spdramp ;


\ could be generalized...
: seek ( n ) handle @ swap (seek) ;
: reversed   bidir (playmode!) sndlength@ (seek) ;  \ might not work


\ : playmode ( n ) handle @ swap (playmode!) 0 playing! 0 seek 1 playing! ;


\ TODO
\ use speed and volume to do this... NOT the playing state (would cause it to be deleted)
: sndpause    sndvol sf@ tempvol sf! 0e sndvol sf!
              sndspd sf@ tempspd sf! 0e sndspd sf!
              sound:update ;
: sndresume   tempvol sf@ 1sf sndvol !
              tempspd sf@ 1sf sndspd !
              sound:update ;


: playsample ( sample playmode -- )
   >r %samplesound onesound snd!   
   smpinst> handle !
   handle @ swap >alsmp @ al_set_sample drop
   handle @ mixer al_attach_sample_instance_to_mixer drop
   handle @ r> (playmode!)
   handle @ al_play_sample_instance drop
   10 juststarted !
   ; \ 1 playing! ;

: playstream ( path c playmode -- )
   >r %streamsound onesound snd!
   z$ 2 4096 al_load_audio_stream handle !   
   handle @ r> (playmode!) 
   handle @ mixer al_attach_audio_stream_to_mixer drop
   10 juststarted !
   ; 

: stopsound   snd! handle @ -exit sound:delete ;

: sample  ( -- <name> <path> ) ( playmode -- )
   ?create namespec sample,  does> swap playsample ;

: stream  ( -- <name> <path> ) ( playmode -- )
   create namespec string,  does> count find-asset rot playstream ;


: ?done   handle @ (finished) juststarted -- juststarted @ 0 <= and dup if sound:delete then ;

: sound:step
   ?done ?exit
   \ TODO: process ramps
   sound:update
;

: update-sounds
   snd [[ snd! handle @ if sound:step then ]] sounds each snd!
;

\ -------------------------------------------------------------------------------------- 
\ Fuck this!!!!!!

\ 1024 1024 * 4 * task audiotask

\ : /audiomngr
\    audiotask activate init-audio begin 1 Sleep drop [c update-sounds c] again
\ ;

\ variable soundframes
\ [[ 2drop [c init-audio c] begin soundframes ++ 1 sleep drop [c update-sounds c] again ]] 2 cb: mycb

\ 0 value t
\ -------------------------------------------------------------------------------------- 

: close-sound   ; \ t al_destroy_thread ;

: init-sound
   init-audio
   \ /audiomngr
   ; \ mycb 0 al_create_thread dup to t al_start_thread ;

\ /audiomngr


: pause-sounds
   snd [[ snd! handle @ if sndpause then ]] sounds each snd!
;
: resume-sounds
   snd [[ snd! handle @ if sndresume then ]] sounds each snd!
;


: mastervol!   mixer swap p>f 1sf al_set_mixer_gain drop ;

: -sounds   mixer 0e 1sf al_set_mixer_gain drop ;
: +sounds   mixer 1e 1sf al_set_mixer_gain drop ;
