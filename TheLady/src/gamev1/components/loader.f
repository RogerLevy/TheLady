\ ---------------------------------------------------------------------------
\ Loader
0 value splash
create splash1 %bitmap instance,
create splash2 %bitmap instance,
create splash3 %bitmap instance,
create splasht %displaytransform instance,

: draw-loader
   FX_NORMAL colorfx    
   viewm al_identity_transform
   -1024e -576e viewm al_translate_transform
   ( progress ) dup p* 1.0 swap - dup
      -400.0 400.0 between -400.0 400.0 between rot dup 2p* 2p>f
         viewm al_translate_transform
      3 * 1.0 + dup 2p>f viewm al_scale_transform


   calc-viewport
   displaywh 2p 0.5 0.5 2p* topoffset @ - 2p>f viewm al_translate_transform

   viewm al_use_transform
   splash entire splasht 0 0 at blitrgnex ;

: load-now   dup >r >path place r> load-asset ;

: lady-loader
   counter bud !
   " data/load/Loading Screen 1.jpg" splash1 load-now
   " data/load/Loading Screen 2.jpg" splash2 load-now
   " data/load/Loading Screen 3.jpg" splash3 load-now
   3 rnd case
      0 of splash1 endof
      1 of splash2 endof
      2 of splash3 endof
   endcase
   to splash
   " data/title/Title Screen Track.ogg" looping playstream snd
   [[ progress% draw-loader show-frame ]] load-assets-showing-progress
   stopsound
;

' lady-loader is loader


: fake-loader ( image )
   to splash
   clear-sounds " data/title/Title Screen Track.ogg" looping playstream snd   
   0 [[ ]] [[ dup 179.0 p/ draw-loader 1.0 + ]] 180 interlude drop 100 ms
   stopsound
;