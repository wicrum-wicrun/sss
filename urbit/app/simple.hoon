/+  verb, dbug, sss
::
=>
  |%
  ++  in
    |%
    ++  rock
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
    ++  rock  (list cord)
    ++  wave  cord
    ++  wash
      |=  [xs=(list cord) x=cord]
      ^+  xs
      [x xs]
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
|_  =bowl:gall
+*  this  .
::
++  on-init  `this
++  on-save  *vase
++  on-load  _`this
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card:sss _this)
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
  |=  =rock:in
  ?-    -.rock
      [%foo %bar ~]
    ~&  >  "received rock {<rock>}"
    `this
  ==
::
++  on-wave
  |=  [=rock:in =wave:in]
  ?-    -.rock
      [%foo %bar ~]
    ~&  >  "received rock {<rock>} and wave {<wave>}"
    `this
  ==
::
++  on-arvo   _`this
++  on-peek   _~
++  on-watch  _`this
++  on-leave  _`this
++  on-fail   _`this
--