\ ==============================================================================
\ ForestLib > Brute4X
\ Test schema
\ ========================= copyright 2014 Roger Levy ==========================

[schema test-schema
   [xmlnode hello
      [xmlnode forth
         onprocess: cr xmltext@ type ;
         attribute: attr1   xmltext@ type ;
         attribute: attr2   xmlint@ .   ;
         
         [xmlnode comment
            onprocess: cr xmltext@ type ;
            attribute: attr1 xmltext@ type ;
            attribute: attr2 xmlint@ .   ;
         xmlnode]
   
         [xmlnode colon
            onprocess: cr xmltext@ type ;
            attribute: attr1 xmltext@ type ;
            attribute: attr2 xmlint@ .   ;
            [xmlnode name
               onprocess:  xmltext@ type ;
            xmlnode]
            [xmlnode stack
               onprocess:  xmltext@ type ;
            xmlnode]
         xmlnode]
   
         [xmlnode run
            onprocess:  xmltext@ type ;
         xmlnode]
      xmlnode]
   xmlnode]
schema]