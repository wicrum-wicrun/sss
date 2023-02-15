/-  sum, log
/+  verb, dbug, *sss
::
%-  agent:dbug
%+  verb  &
::
=/  sub-log  (mk-subs log ,[%log @ ~])
=/  sub-sum  (mk-subs sum ,[%sum *])
=/  pub-log  (mk-pubs log ?([%log *] [%other-log ~]))
=/  pub-sum  (mk-pubs sum ,[%sum %foo ~])
::
|_  =bowl:gall
+*  this  .
    da-sub-log   =/  da  (da log ,[%log @ ~])
                ~(. da sub-log bowl -:!>(*result:da) -:!>(*from:da))
::
    da-sub-sum   =/  da  (da sum ,[%sum *])
                ~(. da sub-sum bowl -:!>(*result:da) -:!>(*from:da))
::
    du-pub-log  =/  du  (du log ?([%log *] [%other-log ~]))
                ~(. du pub-log bowl -:!>(*result:du))
::
    du-pub-sum  =/  du  (du sum ,[%sum %foo ~])
                ~(. du pub-sum bowl -:!>(*result:du))
::
++  on-init  `this
++  on-save  !>([sub-log sub-sum pub-log pub-sum])
++  on-load  _`this
::  |=  =vase
::  =/  old  !<([=_sub-log =_sub-sum =_pub-log =_pub-sum] vase)
::  `this(sub-log sub-log.old, sub-sum.old, pub-log pub-log.old)
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card:agent:gall _this)
  ~&  >>  "sub-log was: {<read:da-sub-log>}"
  ~&  >>  "pub-log was: {<read:du-pub-log>}"
  ~&  >>  "sub-sum was: {<read:da-sub-sum>}"
  ~&  >>  "pub-sum was: {<read:du-pub-sum>}"
  ?-    mark
      %noun  `this
      %add
    =^  cards  pub-sum  (give:du-pub-sum !<([[%sum %foo ~] @ud] vase))
    ~&  >  "pub-sum is: {<read:du-pub-sum>}"
    [cards this]
  ::
      %log
    =^  cards  pub-log  (give:du-pub-log !<([?([%log *] [%other-log ~]) cord] vase))
    ~&  >  "pub-log is: {<read:du-pub-log>}"
    [cards this]
  ::
      %surf-log
    :_  this
    ~[(surf:da-sub-log !<(@p (slot 2 vase)) %simple !<([%log @ ~] (slot 3 vase)))]
  ::
      %surf-sum
    :_  this
    ~[(surf:da-sub-sum !<(@p (slot 2 vase)) %simple !<([%sum *] (slot 3 vase)))]
  ::
      %rule-log
    =.  pub-log  (rule:du-pub-log !<($%([[%log *] @ud @ud] [[%other-log ~] @ud @ud]) vase))
    ~&  >  "pub-log is: {<read:du-pub-log>}"
    `this
  ::
      %rule-sum
    =.  pub-sum  (rule:du-pub-sum !<([[%sum %foo ~] @ud @ud] vase))
    ~&  >  "pub-sum is: {<read:du-pub-sum>}"
    `this
  ::
      %wipe-log
    =.  pub-log  (wipe:du-pub-log !<(?([%log *] [%other-log ~]) vase))
    ~&  >  "pub-log is: {<read:du-pub-log>}"
    `this
  ::
      %sss-on-rock
    ?-    msg=!<($%(from:da-sub-log from:da-sub-sum) (fled vase))
        [[%log * ~] *]
      ~?  ?=(^ rock.msg)
        "last message from {<from.msg>} on {<src.msg>} is {<,.-.rock.msg>}"
      ?<  ?=([%crash *] rock.msg)
      `this
    ::
        [[%sum *] *]
      ?.  =(rock.msg 42)  `this
      ~&  "sum from {<from.msg>} on {<src.msg>} is 42"  ::NOTE src.msg not src.bowl!
      `this
    ==
  ::
      %sss-to-pub
    ?-  msg=!<($%(into:du-pub-log into:du-pub-sum) (fled vase))
        [[%sum %foo ~] *]
      =^  cards  pub-sum  (apply:du-pub-sum msg)
      [cards this]
    ::
        *
      =^  cards  pub-log  (apply:du-pub-log msg)
      [cards this]
    ==
  ::
      *
    ?-    msg=!<($%(into:da-sub-log into:da-sub-sum) (fled vase))
        [[%log * ~] *]
      =^  cards  sub-log  (apply:da-sub-log msg)
      ~&  >  "sub-log is: {<read:da-sub-log>}"
      [cards this]
    ::
        [[%sum *] *]
      =^  cards  sub-sum  (apply:da-sub-sum msg)
      ~&  >  "sub-sum is: {<read:da-sub-sum>}"
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
    =.  sub-log  (chit:da-sub-log |3:wire sign)
    ~&  >  "sub-log is: {<read:da-sub-log>}"
    `this
  ::
      [~ %sss %on-rock @ @ @ %sum *]
    =.  sub-sum  (chit:da-sub-sum |3:wire sign)
    ~&  >  "sub-sum is: {<read:da-sub-sum>}"
    `this
  ==
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card:agent:gall _this)
  ?+    wire  `this
      [~ %sss %sub %behn @ @ @ %sum *]    [(behn:da-sub-sum |4:wire) this]
      [~ %sss %sub %behn @ @ @ %log @ ~]  [(behn:da-sub-log |4:wire) this]
      [~ %sss %pub %behn @ @ @ %sum %foo ~]
    `this(pub-sum (behn:du-pub-sum |4:wire))
  ::
      [~ %sss %pub %behn @ @ @ ?([%log *] [%other-log ~])]
    `this(pub-log (behn:du-pub-log |4:wire))
  ==
::
++  on-peek   _~
++  on-watch  _`this
++  on-leave  _`this
++  on-fail   _`this
--
