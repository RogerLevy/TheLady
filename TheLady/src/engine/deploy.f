: releasebuild   ( xt -- ) ['] release-ok is ok   is autoexec deploy ;
: devbuild       ['] dev-ok is ok ['] noop is autoexec debug ;

: filestem  including -path -ext ;

: bibuild  ( startxt -- )
   dup .s " fullscreen  releasebuild bin\" <$ filestem $+ " _fullscreen" $+ $> evaluate
   .s
   " windowed 320 480 res 2! releasebuild bin\" <$ filestem $+ " _windowed" $+ $> evaluate ;

: tribuild  ( startxt -- )
   bibuild
   " commandline 320 480 res 2! devbuild bin\" <$ filestem $+ " _console" $+ $> evaluate ;

