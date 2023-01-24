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
=/  in-log  (mk-subs log ,[%foo %bar ~])
=/  in-sum  (mk-subs sum ,[%baz ~])
=/  out-log  (mk-pubs log ,[%foo %bar ~])
::
|_  =bowl:gall
+*  this  .
    da-in-log  ~(. (da log ,[%foo %bar ~]) in-log bowl)
    da-in-sum  ~(. (da sum ,[%baz ~]) in-sum bowl)
    du-out-log  ~(. (du log ,[%foo %bar ~]) out-log bowl)
::
++  on-init  `this
++  on-save  !>([in-log in-sum out-log])
++  on-load  _`this
::  |=  =vase
::  =/  old  !<([=_in-log =_in-sum =_out-log] vase)
::  `this(in-log in-log.old, in-sum in-sum.old, out-log out-log.old)
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card:agent:gall _this)
  ~&  >  "sub-map is: {<read:da-in-log>}"
  ~&  >  "pub-map is: {<read:du-out-log>}"
  ?+    mark  !!
      %noun  `this
      %add
    `this(out-log (give:du-out-log [%foo %bar ~] !<(cord vase)))
  ::
      %surf
    :_  this
    ~[(surf:da-in-log !<(@p vase) %simple [%foo %bar ~])]
  ::
      %sss-request
    :_  this
    =/  req  ;;(of:du-out-log !<(* vase))
    ?-    path.req
        [%foo %bar ~]
      ~[(request:du-out-log req)]
    ==
  ::
      %sss-response
    ?-    res=;;($%(to:da-in-log to:da-in-sum) !<(* vase))
        [[%foo %bar ~] *]
      =^  cards  in-log  (response:da-in-log res)
      [cards this]
    ::
        [[%baz ~] *]
      =^  cards  in-sum  (response:da-in-sum res)
      [cards this]
    ==
  ::
      %sss-on-rock
    ?-    res=;;($%(from:da-in-log from:da-in-sum) !<(* vase))
        [[%foo %bar ~] *]
      ~&  "last message from {<from.res>} on {<src.res>} is {<,.-.rock.res>}"
      ?<  =(-.rock.res 'crash')
      `this
    ::
        [[%baz ~] *]
      ?.  =(rock.res 42)  `this
      ~&  "sum from {<from.res>} on {<src.res>} is 42"  ::NOTE src.res not src.bowl!
      `this
    ==
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card:agent:gall _this)
  ?-    wire ::  `this
      [~ %sss %on-rock @ @ @ %foo %bar ~]
    `this(in-log (chit:da-in-log |3:wire sign))
  ::
      [~ %sss %on-rock @ @ @ %baz ~]
    `this(in-sum (chit:da-in-sum |3:wire sign))
  ::
      *
    ?>  ?=(%poke-ack -.sign)
    ?~  p.sign  `this
    ((slog u.p.sign) `this)
  ==
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card:agent:gall _this)
  :_  this
  ?+  wire  ~
    [~ %sss %behn @ @ %foo %bar ~]  (behn:da-in-log |3:wire)
    [~ %sss %behn @ @ %baz ~]       (behn:da-in-sum |3:wire)
  ==
::
++  on-peek   _~
++  on-watch  _`this
++  on-leave  _`this
++  on-fail   _`this
--
