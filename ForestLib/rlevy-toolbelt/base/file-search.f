\ ==============================================================================
\ ForestLib
\ File search function, for FLOAD.
\ Derived from SwiftForth copyright FORTH Inc.
\ ========================= copyright 2014 Roger Levy ==========================


create efolder 256 /allot  \ exclude from search

WIN32_FIND_DATA SUBCLASS DIRTOOL

   VARIABLE HANDLE
   MAX_PATH BUFFER: SPEC
   MAX_PATH BUFFER: fullpath

   : IS-DIR ( -- flag )
      FileAttributes @ FILE_ATTRIBUTE_DIRECTORY AND 0<> ;

   : IS-SUBDIR ( -- flag )
      FileAttributes @ FILE_ATTRIBUTE_DIRECTORY AND
      FileName ZCOUNT S" ."  COMPARE 0<> AND
      FileName ZCOUNT S" .." COMPARE 0<> AND ;

   : FIRST ( zstr -- flag )
      ADDR :: FindFirstFile DUP HANDLE !  INVALID_HANDLE_VALUE <> ;

   : NEXT ( -- flag )
      HANDLE @ ADDR :: FindNextFile ;

   : CLOSE ( -- )
      HANDLE @ :: FindClose DROP ;

   : SPEC!
      SPEC zplace ;

   : fullname
      FileName MAX_PATH fullpath 0 GetFullPathName fullpath swap ;

END-CLASS

CLASS DIR-TRAVERSE

   \ these is the action to take on file matches
   \ returning zero means continue, non-zero means stop
   \ the non-zero will be returned as the flag from SEARCH ;

   DEFER: FILE-ACTION ( zstr -- flag )   DROP 0 ;

   \ give search a filespec to search for, and it will look
   \ in the current directory and all the subdirs until
   \ the file-action defer returns a non-zero

   : SEARCH ( zstr -- flag )
      [OBJECTS DIRTOOL MAKES FD OBJECTS]
      ZCOUNT FD SPEC!

      FD SPEC  FD FIRST BEGIN
         0<> WHILE
         FD IS-DIR NOT IF
            FD FileName FILE-ACTION
            ?DUP IF  FD CLOSE  EXIT  THEN
         THEN
         FD NEXT
      REPEAT FD CLOSE

      Z" *.*" FD FIRST BEGIN
         0<> WHILE

         FD IS-SUBDIR IF
            \ cr FD fullname 2dup type space efolder zcount 2dup type compare if
            FD fullname efolder zcount compare(nc)
            FD fullname s" .hg" search nip nip 0= and if
               FD FileName
                     \ dup cr zcount type
                  setdir DROP
               FD SPEC   RECURSE   ( flag )
               Z" .." setdir DROP
               ?DUP IF  FD CLOSE  EXIT  THEN
            else cr 14 attribute ." Skipped folder: " fd fullname -path type normal 
            THEN
         then
         FD NEXT
      REPEAT FD CLOSE 0 ;

   variable level

   \ version that only checks direct child files and direct child subdirs's files
   : SHALLOW-SEARCH ( zstr -- flag )
      [OBJECTS DIRTOOL MAKES FD OBJECTS]
      ZCOUNT FD SPEC ZPLACE
      \ check files
      FD SPEC  FD FIRST BEGIN
         0<> WHILE
         FD IS-DIR NOT IF
            FD FileName FILE-ACTION
            ?DUP IF  FD CLOSE  EXIT  THEN
         THEN
         FD NEXT
      REPEAT FD CLOSE
      \ check subdirs
      level @ 0= if
         Z" *.*" FD FIRST BEGIN
            0<> WHILE
            FD IS-SUBDIR
            FD fullname s" .hg" search nip nip 0= and 
            IF
               FD FileName
                  setdir DROP
               FD SPEC   level ++ RECURSE level -- ( flag )
               Z" .." setdir DROP
               ?DUP IF  FD CLOSE  EXIT  THEN
            THEN
            FD NEXT
         REPEAT FD CLOSE 0
      else 0 then ;


END-CLASS

DIR-TRAVERSE SUBCLASS FILE-FINDER

   MAX_PATH BUFFER: TARGET

   : FILE-ACTION ( zstr -- flag )
      drop \ cr zcount type
      MAX_PATH TARGET getdir DROP  TARGET ;

   : file-search ( zstr-name zpath -- zpath | false )
      PUSHPATH  setdir DROP  SEARCH  POPPATH ;

   : file-shallow-search
      PUSHPATH  setdir DROP  shallow-search  POPPATH ;

END-CLASS

