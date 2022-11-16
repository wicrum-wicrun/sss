|%
++  lake
  |$  [rock wave]
  $_  ^?
  |%
  +$  rock  ^rock
  +$  wave  ^wave
  ++  wash  |~  [rock wave]  *rock
  --
+$  dude  dude:agent:gall
+$  what  ?(%rock %wave)
++  poke
  |%
  +$  request
    $%  [%pine from=dude =what =path]
        [%scry from=dude =what =path aeon=@ud]
    ==
  ++  response
    |*  =(lake)
    $%  [%pine from=dude aeon=@ud =what =path]
        $:  %scry  from=dude  aeon=@ud
            $%  [what=%rock =rock:lake]
                [what=%wave =wave:lake]
    ==  ==  ==
  --
--
