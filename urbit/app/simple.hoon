/-  sum, log
/+  verb, dbug, *sss
::
%-  agent:dbug
%+  verb  &
::
=/  in-log  (mk-subs log ,[%log @ ~])
=/  in-sum  (mk-subs sum ,[%sum *])
=/  out-log  (mk-pubs log ?([%log *] [%other-log ~]))
=/  out-sum  (mk-pubs sum ,[%sum %foo ~])
::
|_  =bowl:gall
+*  this  .
    da-in-log   =/  da  (da log ,[%log @ ~])
                ~(. da in-log bowl -:!>(*result:da) -:!>(*from:da))
::
    da-in-sum   =/  da  (da sum ,[%sum *])
                ~(. da in-sum bowl -:!>(*result:da) -:!>(*from:da))
::
    du-out-log  =/  du  (du log ?([%log *] [%other-log ~]))
                ~(. du out-log bowl -:!>(*result:du))
::
    du-out-sum  =/  du  (du sum ,[%sum %foo ~])
                ~(. du out-sum bowl -:!>(*result:du))
::
++  on-init  `this
++  on-save  !>([in-log in-sum out-log out-sum])
++  on-load  _`this
::  |=  =vase
::  =/  old  !<([=_in-log =_in-sum =_out-log] vase)
::  `this(in-log in-log.old, in-sum in-sum.old, out-log out-log.old)
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card:agent:gall _this)
  ~&  >>  "in-log was: {<read:da-in-log>}"
  ~&  >>  "out-log was: {<read:du-out-log>}"
  ~&  >>  "in-sum was: {<read:da-in-sum>}"
  ~&  >>  "out-sum was: {<read:du-out-sum>}"
  ?-    mark
      %noun  `this
      %add
    =.  out-sum  (give:du-out-sum !<([[%sum %foo ~] @ud] vase))
    ~&  >  "out-sum is: {<read:du-out-sum>}"
    `this
::
      %log
    =.  out-log  (give:du-out-log !<([?([%log *] [%other-log ~]) cord] vase))
    ~&  >  "out-log is: {<read:du-out-log>}"
    `this
  ::
      %surf-log
    :_  this
    ~[(surf:da-in-log !<(@p (slot 2 vase)) %simple !<([%log @ ~] (slot 3 vase)))]
  ::
      %surf-sum
    :_  this
    ~[(surf:da-in-sum !<(@p (slot 2 vase)) %simple !<([%sum *] (slot 3 vase)))]
  ::
      %sss-on-rock
    ?-    msg=!<($%(from:da-in-log from:da-in-sum) (fled vase))
        [[%log * ~] *]
      ~&  "last message from {<from.msg>} on {<src.msg>} is {<,.-.rock.msg>}"
      ?<  =(-.rock.msg 'crash')
      `this
    ::
        [[%sum *] *]
      ?.  =(rock.msg 42)  `this
      ~&  "sum from {<from.msg>} on {<src.msg>} is 42"  ::NOTE src.msg not src.bowl!
      `this
    ==
  ::
      %sss-to-pub
    :_  this
    ?-  msg=!<($%(into:du-out-log into:du-out-sum) (fled vase))
      [[%sum %foo ~] *]   ~[(apply:du-out-sum msg)]
      *                   ~[(apply:du-out-log msg)]
    ==
  ::
      *
    ?-    msg=!<($%(into:da-in-log into:da-in-sum) (fled vase))
        [[%log * ~] *]
      =^  cards  in-log  (apply:da-in-log msg)
      ~&  >  "in-log is: {<read:da-in-log>}"
      [cards this]
    ::
        [[%sum *] *]
      =^  cards  in-sum  (apply:da-in-sum msg)
      ~&  >  "in-sum is: {<read:da-in-sum>}"
      [cards this]
    ==
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card:agent:gall _this)
  ?>  ?=(%poke-ack -.sign)
  ?~  p.sign  `this
  %-  (slog u.p.sign)
  ?+    wire   `this
      [~ %sss %on-rock @ @ @ %log @ ~]
    =.  in-log  (chit:da-in-log |3:wire sign)
    ~&  >  "in-log is: {<read:da-in-log>}"
    `this
  ::
      [~ %sss %on-rock @ @ @ %sum *]
    =.  in-sum  (chit:da-in-sum |3:wire sign)
    ~&  >  "in-sum is: {<read:da-in-sum>}"
    `this
  ==
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card:agent:gall _this)
  :_  this
  ?+  wire  ~
    [~ %sss %behn @ @ %log @ ~]  (behn:da-in-log |3:wire)
    [~ %sss %behn @ @ %sum *]    (behn:da-in-sum |3:wire)
  ==
::
++  on-peek   _~
++  on-watch  _`this
++  on-leave  _`this
++  on-fail   _`this
--
