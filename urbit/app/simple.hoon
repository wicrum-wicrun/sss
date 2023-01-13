/+  verb, dbug, *sss
::
=>
  |%
  ++  sum
    |%
    +$  rock  @ud
    +$  wave  @ud
    ++  wash  add
    --
  ++  log
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
=/  in-log  (mk-subs log [/foo/bar]~)
=/  in-sum  (mk-subs sum [/baz sum]~)
=/  out-log  (mk-pubs log [/foo/bar]~)
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
  ~&  >  "sub-map is: {<~(take da in-log)>}"
  ?+    mark
      %add
    =^  cards  out-log  (~(give da out-log) /foo/bar !<(cord vase))
    [cards this]
  ::
      %surf
    =^  cards  in-log  (~(surf da in-log) !<(@p vase) %simple /foo/bar)
    [cards this]
  ::
      %sss-request
    :_  this
    =/  req  !<(request:poke vase)
    ?-  path.req
      [%foo %bar ~]  ~[(~(request du out-log) req)]
    ==
  ::
      %sss-response
    =/  res  !<((response:poke (lake)) vase)
    ?-    -.res
        %pine
      :_  this
      ?-  path.res
        [%foo %bar ~]  (~(pine-response du in-log) res)
      ==
    ::
        %scry
      ?-  &5.res
        [%foo %bar ~]  =^  cards  in-log  (~(scry-response du in-log) res)
                       [cards this]
      ==
    ==
  ::
      %sss-on-rock
    ?-    res=!<(?(~(mold da in-log) ~(mold da in-sum)))
        [* [%foo %bar ~] *]
      !!
    ::
        [* [%baz ~] *]
      !!
    ==
  ==
::
++  on-agent  _`this
::  ++  on-rock
::    |=  [dud=dude:gall rok=rock:in wav=(unit wave:in)]
::    ?-    -.rok
::        [%foo %bar ~]
::      ~&  >  "ship {<src.bowl>}, agent {<dud>}, path {<`path`-.rok>}:"
::      ~?  >  ?=(^ wav)  "received wave {<+.u.wav>}"
::      ~&  >  "rock is now {<+.rok>}"
::      ~&  >  "sub-map is: {<sub>}"
::      ?:  ?=([~ * %crash] wav)  ~&  >>>  'crash!'  !!
::      `this
::    ==
++  on-arvo   _`this
++  on-peek   _~
++  on-watch  _`this
++  on-leave  _`this
++  on-fail
  ~&  >>  %on-fail
  ~&  >  "sub-map is: {<~(read da in-log)>}"
  _`this
--
