/+  verb, dbug, sss
::
=>
  |%
  ++  in
    |%
    +$  rock
      $%  [[%foo %bar ~] (list cord)]
      ==
    +$  wave
      $%  [[%foo %bar ~] cord]
      ==
    ++  wash
      |=  [rok=rock wav=wave]
      ^+  rok
      ?>  =(-.rok -.wav)
      [-.rok [+.wav +.rok]]
    --
  ++  out
    |%
    +$  rock  (list cord)
    +$  wave  cord
    ++  wash
      |=  [rok=rock wav=wave]
      ^+  rok
      [wav rok]
    --
  --
::
%-  agent:dbug
%+  verb  &
::
=/  sss  (sss out in)
%-  mk-agent:sss
^-  agent:sss
::
|_  [=bowl:gall pub=(map path rock:out) sub=(map [ship dude:gall path] [? rock:in])]
+*  this  .
::
++  on-init  `this
++  on-save  *vase
++  on-load  _`this
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card:sss _this)
  ~&  >>  %on-poke
  ~&  >  "sub-map is: {<sub>}"
  ?+    mark  !!
      %add
    :_  this
    [%give %wave /foo/bar !<(cord vase)]~
  ::
      %surf
    :_  this
    [%pass /start/surf %agent [!<(@p vase) %simple] %surf /foo/bar]~
  ==
::
++  on-agent  _`this
++  on-rock
  |=  [dud=dude:gall rok=rock:in wav=(unit wave:in)]
  ?-    -.rok
      [%foo %bar ~]
    ~&  >  "ship {<src.bowl>}, agent {<dud>}, path {<`path`-.rok>}:"
    ~?  >  ?=(^ wav)  "received wave {<+.u.wav>}"
    ~&  >  "rock is now {<+.rok>}"
    ~&  >  "sub-map is: {<sub>}"
    ?:  ?=([~ * %crash] wav)  ~&  >>>  'crash!'  !!
    `this
  ==
++  on-arvo   _`this
++  on-peek   _~
++  on-watch  _`this
++  on-leave  _`this
++  on-fail
  ~&  >>  %on-fail
  ~&  >  "sub-map is: {<sub>}"
  _`this
--
