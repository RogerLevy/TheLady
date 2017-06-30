empty
fload thelady
fload bighead
image l1bg.image data/l1misc/l1bg.jpg
stream *l1bgm* data/l1misc/lvl 1 record scratch.ogg

: go
   l1bg.image setbg  looped *l1bgm*
   lady { view 0.2 1.0 around put }
   view 0.7 0.5 around at %bighead one be 
   ok
;


: releasebuild   ['] release-ok is ok ['] go is autoexec deploy ;
: devbuild       ['] dev-ok is ok ['] noop is autoexec debug ;

: filestem  including -path -ext ;

: bibuild
   " fullscreen releasebuild bin\" <$ filestem $+ " _fullscreen" $+ $> evaluate
   " windowed 800 600 res 2! releasebuild bin\" <$ filestem $+ " _windowed" $+ $> evaluate ;

: tribuild
   bibuild
   " commandline 640 480 res 2! devbuild bin\" <$ filestem $+ " _console" $+ $> evaluate ;

tribuild
