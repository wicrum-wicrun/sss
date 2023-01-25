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
    da-in-log   =/  da  (da log ,[%foo %bar ~])
                ~(. da in-log bowl -:!>(*result:da) -:!>(from:da))
    da-in-sum   =/  da  (da sum ,[%baz ~])
                ~(. da in-sum bowl -:!>(*result:da) -:!>(from:da))
    du-out-log  =/  du  (du log ,[%foo %bar ~])
                ~(. du out-log bowl -:!>(*result:du))
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
      %sss-on-rock
    ?-    msg=!<($%(from:da-in-log from:da-in-sum) vase)
        [[%foo %bar ~] *]
      ~&  "last message from {<from.msg>} on {<src.msg>} is {<,.-.rock.msg>}"
      ?<  =(-.rock.msg 'crash')
      `this
    ::
        [[%baz ~] *]
      ?.  =(rock.msg 42)  `this
      ~&  "sum from {<from.msg>} on {<src.msg>} is 42"  ::NOTE src.msg not src.bowl!
      `this
    ==
  ::
      %sss-to-pub
    :_  this
    ?-  msg=!<(into:du-out-log vase)
      [[%foo %bar ~] *]  ~[(apply:du-out-log msg)]
    ==
  ::
      %sss-to-sub
    ?-    msg=!<($%(into:da-in-log into:da-in-sum) vase)
        [[%foo %bar ~] *]
      =^  cards  in-log  (apply:da-in-log msg)
      [cards this]
    ::
        [[%baz ~] *]
      =^  cards  in-sum  (apply:da-in-sum msg)
      [cards this]
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
