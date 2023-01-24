|%
++  lake
  |$  [rock wave]
  $_  ^?
  |%
  +$  rock  ^rock
  +$  wave  ^wave
  ++  wash  |~  [rock wave]  *rock
  --
::  +$  aeon  @ud
+$  dude  dude:agent:gall
+$  what  ?(%rock %wave)
++  poke
  |%
  ++  request
    $%  [%pine from=dude =what =path]
        [%scry from=dude =what =path aeon=@ud]
    ==
  ++  response
    |*  [=(lake) paths=mold]
    $:  path=paths
        from=dude
        aeon=@ud
        $=  payload
        $@  =what
        $%  [what=%rock =rock:lake]
            [what=%wave =wave:lake]
    ==  ==
  --
--
