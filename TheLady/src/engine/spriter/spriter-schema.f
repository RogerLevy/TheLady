
\ relies on:
\  ~brute4x *stack %displaytransform


list folderlist
list filelist
list maplist
list charmaplist
list entitylist
list animationlist
list timelinelist
list mainlinelist
list bonelist
list objlist
list keylist


0 value mainlinepivotx
0 value mainlinepivoty
0 value mainlinehaspivot

%spritetimelinekey ~> %timelinekey-general
\ have to do this because of the weird way the scml handles the types of keys in timelines
\ fortunately for us it makes no difference
endp



: gather   ( list arrayfield -- ) locals| stack list |
   list howmany cell stack -> *stack   stack to destarr  [[ destarr push ]] list traverse ;

[schema spriter-schema  ( xmlfilename count -- <name> )
   \ onprocess: create ;

   [xmlnode spriter_data   \ must be first and only node
      onprocess:  ( -- scmlobject )
         %scmlobject instantiate
         folderlist startover
         entitylist startover
         ;
      onpostprocess: ( scmlobject -- scmlobject )
         dup =>
            folderlist folders gather
            entitylist entities gather
         ;

      [xmlnode folder
         onprocess: ( -- folder )
            %folder instantiate dup folderlist link,
            filelist startover  ;
         attribute: name   ; \ xmltext@ third >name place ;
         onpostprocess: ( folder -- )
            => filelist files gather ;

         [xmlnode file
            onprocess: ( -- file )
               %file instantiate dup filelist link, ;
            onpostprocess:  ( file -- )
               =>
                  struct >name count +localpath processpath ( cr 2dup type )
                  ?loaded if bmp ! else   here bmp ! bitmap,   then ;
            attribute: name   xmltext@ third >name place ;
            attribute: pivot_x   xmlfixed@ over >pivotx ! ;
            attribute: pivot_y   1.0 xmlfixed@ - over >pivoty ! ;
            attribute: width ;
            attribute: height ;
         xmlnode]

      xmlnode]

      [xmlnode entity
         onprocess:  ( -- entity )
            %entity instantiate dup entitylist link,
            charmaplist startover
            animationlist startover ;
         onpostprocess:  ( entity -- )
            => charmaplist charactermaps gather
               animationlist animations gather
            ;
         attribute: name   xmltext@ third >name place ;

         [xmlnode character_map
            onprocess:  ( -- charactermap )
               %charactermap instantiate dup charmaplist link,
               maplist startover ;
            onpostprocess:  ( charactermap -- )
               => maplist maps gather ;
            attribute: name   xmltext@ third >name place ;

            [xmlnode map
               onprocess: ( -- mapinstruction )
                  %mapinstruction instantiate dup maplist link, ;
               onpostprocess:  ( mapinstruction -- )
                  drop ;
               attribute: folder   xmlint@ over >folder ! ;
               attribute: file     xmlint@ over >file ! ;
               attribute: target_folder xmlint@ over >targetfolder ! ;
               attribute: target_file xmlint@ over >targetfile ! ;
            xmlnode]

         xmlnode]

         [xmlnode animation

            onprocess:  ( -- animation )
               %animation instantiate dup animationlist link,
               timelinelist startover
               mainlinelist startover ;

            onpostprocess:  ( animation -- )
               => timelinelist timelines gather
                  mainlinelist mainlinekeys gather
               ;
            attribute: name   xmltext@ third >name place ;
            attribute: length   xmlint@ over >duration ! ;
            attribute: looping  xmltext@ drop c@ [char] t = 1 and over >looptype ! ;

            [xmlnode mainline

               [xmlnode key
                  onprocess: ( -- mainlinekey )
                     %mainlinekey instantiate dup mainlinelist link,
                     bonelist startover
                     objlist startover   ; \ cr objlist cell+ @ ? ;
                  onpostprocess:  ( mainlinekey -- )
                     => bonelist bonerefs gather
                        objlist objectrefs gather ;
                  attribute: time   xmlint@ over >time ! ;

                  [xmlnode bone_ref
                     onprocess: ( -- ref )
                        %ref instantiate dup bonelist link,
                        ;
                     onpostprocess: drop ;
                     attribute: file ;
                     attribute: folder ;
                     attribute: name ;
                     attribute: parent   xmlint@ over >parent ! ;
                     attribute: timeline xmlint@ over >timeline ! ;
                     attribute: key      xmlint@ over >key ! ;
                  xmlnode]

                  [xmlnode object_ref
                     onprocess: ( -- ref )
                        %ref instantiate dup objlist link,
                        false to mainlinehaspivot
                        ;
                     onpostprocess: drop ;
                     attribute: file ;
                     attribute: folder ;
                     attribute: name ;
                     attribute: parent   xmlint@ over >parent ! ;
                     attribute: timeline xmlint@ over >timeline ! ;
                     attribute: key      xmlint@ over >key ! ;

                     attribute: abs_pivot_x   xmlfixed@ to mainlinepivotx   true to mainlinehaspivot ;
                     attribute: abs_pivot_y   1.0 xmlfixed@ - to mainlinepivoty ;

                  xmlnode]

               xmlnode]

            xmlnode]

            [xmlnode timeline
               onprocess: ( -- timeline )
                  %timeline instantiate dup timelinelist link,
                  keylist startover ;
               onpostprocess: ( timeline -- )
                  =>   keylist keys gather ;

               attribute: name   ; \ xmltext@ third >name place ;

               attribute: type
                  spriter open-package public >r >r >r
                     " object_type_" <$ xmltext@ $+ $> evaluate over >objecttype !
                  r> r> r> end-package ;

               [xmlnode key
                  onprocess: ( -- timelinekey )
                     %timelinekey-general instantiate dup keylist link, ;
                  onpostprocess: ( timelinekey -- )
                     =>
                        mainlinehaspivot if
                           mainlinepivotx 1.0 mainlinepivoty -  info >pivot 2!
                           usedefaultpivot off
                        then ;

                  attribute: time   xmlint@ over >time ! ;

                  attribute: spin   xmlint@ over >spin ! ;
                  \ attribute: c1 ;
                  \ attribute: c2 ;
                  attribute: curve_type   ; \ xmlint@ over >curvetype ! ;

                  [xmlnode bone
                     attribute: x xmlfixed@ over >info >px ! ;
                     attribute: y xmlfixed@ over >info >py ! ;
                     attribute: scale_x xmlfixed@ over >info >scale >x ! ;
                     attribute: scale_y xmlfixed@ over >info >scale >y ! ;
                     attribute: angle xmlfixed@ over >info >rotation >z ! ;
                     attribute: folder xmlint@ over >skfolder ! ;
                     attribute: file xmlint@ over >skfile ! ;
                     attribute: a xmlfixed@ over >a ! ;
                  xmlnode]

                  [xmlnode object  ( spritetimelinekey -- spritetimelinekey )
                     attribute: x   xmlfixed@ over >info >px ! ;  \ xmlfloat@ over >info >x sf! ;
                     attribute: y   xmlfixed@ over >info >py ! ;
                     attribute: scale_x   xmlfixed@ over >info >scale >x ! ;
                     attribute: scale_y   xmlfixed@ over >info >scale >y ! ;
                     attribute: pivot_x   xmlfixed@ over >info >pivot >x ! ;
                     attribute: pivot_y   1.0 xmlfixed@ - over >info >pivot >y ! ;
                     attribute: angle     xmlfixed@ over >info >rotation >z ! ;
                     attribute: folder    xmlint@ over >skfolder ! ;
                     attribute: file      xmlint@ over >skfile ! ;
                     attribute: a         xmlfixed@ over >a ! ;
                  xmlnode]

               xmlnode]

            xmlnode]

         xmlnode]

      xmlnode]

   xmlnode]

schema]
