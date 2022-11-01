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
++  poke
  |%
  +$  request
    $%  [%pine from=dude =path]
        [%scry from=dude =path aeon=@ud]
    ==
  ++  response
    |*  sub=(lake)
    $%  [%pine from=dude aeon=@ud =rock:sub]
        [%scry from=dude aeon=@ud =wave:sub]
    ==
  --
--
