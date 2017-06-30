empty
fload thelady
fload level1demo

: go
   1 loadlevel
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
