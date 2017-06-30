\ -----------------------------------------------------------------------------------------
\ 1/17 The Lady
" The Lady" titlebar

empty

fload thelady

\ Title screens and related
fload title
fload ending

\ Load the level code
fload level1
fload level2
fload level3
fload level4
fload level5

\ Arcade-style boss fights
fload retroboss

\ The ending
fload ending

\ Connect everything together
[[ 2 loadlevel ]]
   1 levels [] @ >oncompletelevel !

[[ splash2 fake-loader [[ 3 loadlevel ]] nextup purpleboss ]]
   2 levels [] @ >oncompletelevel !

[[ splash3 fake-loader [[ 4 loadlevel ]] nextup redboss ]]
   3 levels [] @ >oncompletelevel !

[[ 5 loadlevel ]]
   4 levels [] @ >oncompletelevel !

[[
   [[
      [[
         [[ title ]] nextup
         credits
      ]] nextup 
      ending
   ]] nextup blackboss
]]
   5 levels [] @ >oncompletelevel !

[[ clear-sounds title ]] is reset

: playgame   /lady 3 lives ! 1 loadlevel ;
: go   [[ playgame ]] nextup prelude ?ok ;

: releasebuild   ['] release-ok is ok ['] go is autoexec deploy ;
: devbuild       ['] dev-ok is ok ['] noop is autoexec debug ;

: filestem  including -path -ext ;

: bibuild
   " fullscreen releasebuild bin\TheLady_fullscreen ico\appicon.ico" evaluate
   " windowed 800 600 res 2! releasebuild bin\TheLady_windowed ico\appicon.ico" evaluate ;

: tribuild
   bibuild
   " commandline 640 480 res 2! devbuild bin\TheLady_console" evaluate ;

tribuild
