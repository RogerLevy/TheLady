\ ==============================================================================
\ ForestLib > GameBlocks > Allegro5 I/O
\ Audio foundation
\ ========================= copyright 2014 Roger Levy ==========================

0 value audio?
0 value mixer
64 constant #maxsmp
create sample-instances  #maxsmp stack,

: init-audio
   [[ al_install_audio 0= if " Couldn't initialize any audio device." alert -1 throw then
   al_init_acodec_addon 0= if " Couldn't install audio codecs." alert -1 throw then ]] catch if
      false to audio?
      " Error in INIT-AUDIO; audio won't function.  Maybe INIT-ALLEGRO wasn't called beforehand." alert
      exit
   then
   true to audio?
   al_restore_default_mixer   al_get_default_mixer to mixer
   \ 32 al_reserve_samples 0= abort" Couldn't reserve samples. (?)"
   sample-instances vacate
   #maxsmp 0 do
      0 al_create_sample_instance 
      dup sample-instances push
          mixer al_attach_sample_instance_to_mixer drop
   loop
   report" Allegro Audio Subsystems Initialized"
   al_init_acodec_addon
   ; 
