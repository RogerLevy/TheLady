\ Engine stuff 

display 0= [if] init-game-window [then]

fload system            \ Callbacks and other words for creating various kinds of builds

fload spriter
fload colorfx
fload mainloop
fload parallax
fload entity
fload entity-stage2
\ fload flow
fload scmlanimator
fload actor
fload actor-spriter
fload actorutils
fload maze              \ maze logic
fload layout
fload particles

\ let this be last - these are tools this doesn't actually build anything automatically
\ TODO: figure out how to treat GO
\ fload build

remember engine

report( Loaded engine)
