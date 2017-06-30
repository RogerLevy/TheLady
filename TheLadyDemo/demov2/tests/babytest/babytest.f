empty
fload thelady
fload babyghost
image l1bg.image data/l1misc/l1bg.jpg
sample *madness* data/l1misc/Nearing the edge 3.ogg
stream *l1bgm*   data/l1misc/Level 1.ogg
stream *l1scratch* data/l1misc/LVL 1 record scratch.ogg

: go
   l1bg.image setbg
   looped *l1bgm* 0.9 sndvol!
   looped *l1scratch* 0.75 sndvol!
   0 [[
      0.25 delay
      looped *madness* 0.3 sndvol! 1.1 sndspd!
      end
   ]] parallel
   0 [[
      <g> kpressed if view somewhere at %baby one { then
   ]] parallel
   view somewhere at  %baby one {
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
