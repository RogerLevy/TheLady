\ -----------------------------------------------------------------------------------------
\ 1/17 The Lady (DEMO)

" The Lady (Demo)" titlebar

fload demodeps

\ Load the level code
fload level1demo

image creds.image data/demo/demo credits.jpg

: credits
   clear-stage creds.image billboard{ fillscreen }
   fadein
   0 [[
      3.0 delay
      <space> kpressed
      <enter> kpressed or
      <escape> kpressed or if clear-sounds clear-assets close-sound close-allegro 0 exitprocess then
   ]] parallel
;

: ending
   0 [[
      stays on
      6.0 delay
      fadeout
      3.0 delay
      credits
      end
   ]] parallel
;

: playgame
   clean /lady ['] ending nextup 1 loadlevel
;

: go
   ['] playgame nextup title
   ok
;


: releasebuild   ['] release-ok is ok ['] go is autoexec deploy ;
: devbuild       ['] dev-ok is ok ['] noop is autoexec debug ;

: filestem  including -path -ext ;

: bibuild
   iconpath
      " fullscreen releasebuild bin\" <$ filestem $+ " _fullscreen " $+ $+ $> evaluate

   iconpath
      " windowed 800 600 res 2! releasebuild bin\" <$ filestem $+ " _windowed " $+ $+ $> evaluate ;

: tribuild
   bibuild
   " commandline 640 480 res 2! devbuild bin\" <$ filestem $+ " _console" $+ $> evaluate ;

tribuild
