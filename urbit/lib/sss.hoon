/-  *sss
::
|*  [pub=(lake) sub=(lake)]
|%
++  agent
  $_  ^|
  |_  =bowl:agent:gall
  ++  on-init                               *(quip card _^|(..on-init))
  ++  on-save                               *vase
  ++  on-load   |~  vase                    *(quip card _^|(..on-init))
  ++  on-poke   |~  [mark vase]             *(quip card _^|(..on-init))
  ++  on-watch  |~  path                    *(quip card _^|(..on-init))
  ++  on-leave  |~  path                    *(quip card _^|(..on-init))
  ++  on-peek   |~  path                    *(unit (unit cage))
  ++  on-agent  |~  [wire sign:agent:gall]  *(quip card _^|(..on-init))
  ++  on-rock   |~  rock:sub                *(quip card _^|(..on-init))
  ++  on-wave   |~  [rock:sub wave:sub]     *(quip card _^|(..on-init))
  ++  on-arvo   |~  [wire sign-arvo]        *(quip card _^|(..on-init))
  ++  on-fail   |~  [term tang]             *(quip card _^|(..on-init))
  --
::
+$  card  (wind note gift)
+$  note
  $%  [%agent [=ship name=term] =task]
      [%arvo note-arvo]
      [%pyre =tang]
  ==
+$  task
  $%  [%surf =path]
      task:agent:gall
  ==
+$  gift
  $%  [%wave =path =wave:pub]
      gift:agent:gall
  ==
::
+$  state
  $:  exo=(map [ship dude path] flow)
      endo=(map path tide)
      =agent
  ==
+$  rule  [rocks=_1 waves=_5]
+$  aeon  @ud
++  tide
  $:  rok=((mop aeon rock:pub) gte)
      wav=((mop aeon wave:pub) lte)
      rul=rule
  ==
++  flow
  $:  =aeon
      rok=[=aeon =rock:sub]
      wav=((mop aeon wave:sub) lte)
  ==
++  rok  ((on aeon rock:pub) gte)
++  wav
  |*  =(lake)
  ((on aeon wave:lake) lte)
::
++  zoom  |=  =path  `^path`$/sss/path
::
++  mk-agent
  |=  inner=agent
  ::
  =|  state
  =.  agent  inner
  =*  state  -
  |^
  ^-  agent:gall
  |_  =bowl:gall
  +*  ag       ~(. agent bowl)
      this     .
      handler  ~(sss-engine hc bowl)
  ::
  ++  on-init
    =^  cards  state  (run:handler on-init:ag)
    [cards this]
  ::
  ++  on-save
    %+  slop  on-save:ag
    !>([%sss exo endo])
  ::
  ++  on-load
    |=  =vase
    =/  old    !<([%sss =_exo =_endo] (slot 3 vase))
    =.  exo    exo.old
    =.  endo   endo.old
    =^  cards  state  (run:handler (on-load:ag (slot 2 vase)))
    [cards this]
  ::
  ++  on-poke
    |=  [=mark =vase]
    ?+      mark
          =^  cards  state  (run:handler (on-poke:ag +<))
          [cards this]
        %sss-request
      :_  this
      (~(request hc bowl) !<(request:poke vase))
    ::
        %sss-response
      =^  cards  state  abet:(response:handler !<((response:poke sub) vase))
      [cards this]
    ::
        %sss-solidify
      ?>  =(src our):bowl
      :-  ~
      =/  =path  !<(path vase)
      %=  this  endo
        %+  ~(put by endo)  path
        =/  =tide  (~(got by endo) path)
        =^  last  rok.tide  (pop:rok rok.tide)
        =^  next  wav.tide
          %^    (dip:(wav pub) ,[aeon rock:pub])
              (lot:(wav pub) wav.tide `-.last ~)
            last
          |=  [[aeon =rock:pub] [=aeon =wave:pub]]
          ^-  [(unit wave:pub) ? [^aeon rock:pub]]
          [~ | aeon (wash:pub rock wave)]
        %=  tide  rok
          (put:rok +<-:put:rok next)
        ==
      ==
    ==
  ++  on-watch
    |=  path
    =^  cards  state  (run:handler (on-watch:ag +<))
    [cards this]
  ::
  ++  on-leave
    |=  path
    =^  cards  state  (run:handler (on-leave:ag +<))
    [cards this]
  ::
  ++  on-peek  on-peek:ag
  ::
  ++  on-agent
    |=  [=wire =sign:agent:gall]
    ?.  ?=([~ %sss *] wire)
      =^  cards  state  (run:handler (on-agent:ag +<))
      [cards this]
    ?.  ?=(%poke-ack -.sign)  `this
    ?~  p.sign  `this
    ((slog u.p.sign) `this)
  ::
  ++  on-arvo
    |=  [=wire sign=sign-arvo]
    ?.  ?=([~ %sss *] wire)
      =^  cards  state  (run:handler (on-arvo:ag +<))
      [cards this]
    =>  .(wire |2.wire)
    ?.  ?=([%pine ship=@ dude=@ path=*] wire)  ~&  >>>  "weird wire"    `this
    ?.  ?=([%behn %wake ~] sign)               ~&  >>>  "strange sign"  `this
    :_  this
    ~[(~(pine hc bowl) %wave (slav %p &2.wire) &3.wire |3.wire)]
  ::
  ++  on-fail
    |=  [term tang]
    =^  cards  state  (run:handler (on-fail:ag +<))
    [cards this]
  ::
  --
  ::
  ++  hc
    |_  =bowl:gall
    ::
    ++  pine
      |=  [what=?(%rock %wave) =ship =dude =path]
      :*  %pass   /
          %agent  [ship dude]
          %poke   %sss-request  !>  ^-  request:poke
          [%pine dap.bowl what path]
      ==
    ::
    ++  request
      |=  req=request:poke
      ^-  (list card:agent:gall)
      :_  ~
      ?-    -.req
          %scry
        =/  =tide  (~(gut by endo) path.req *tide)
        :*  %pass   (zoom response/scry/(scot %p src.bowl)^from.req^(scot %ud aeon.req)^path.req)
            %agent  [src.bowl from.req]
            %poke   %sss-response  !>
            :*  %scry  dap.bowl  aeon.req  what.req  path.req
                ?-  what.req
                  %rock  (got:rok rok.tide aeon.req)
                  %wave  (got:(wav pub) wav.tide aeon.req)
        ==  ==  ==
      ::
          %pine
        =/  =tide  (~(gut by endo) path.req *tide)
        =/  aeon=@ud
          ?-  what.req
            %rock  key:(fall (pry:rok rok.tide) *[=key =val]:rok)
            %wave  key:(fall (ram:(wav pub) wav.tide) *[=key =val]:(wav pub))
          ==
        :*  %pass   (zoom response/pine/(scot %p src.bowl)^from.req^path.req)
            %agent  [src.bowl from.req]
            %poke   %sss-response  !>  ^-  (response:poke)
            [%pine dap.bowl aeon what.req path.req]
        ==
      ==
    ::
    ++  sss-engine
      |_  cards=(list card:agent:gall)
      +*  ag    ~(. agent bowl)
      ++  this  .
      ++  emit  |=(=card:agent:gall this(cards [card cards]))
      ++  emil
        |=  cs=(list card:agent:gall)
        ^+  this
        %+  roll  cs
        |=  [=card:agent:gall =_this]
        (emit:this card)
      ::
      ++  abet  [(flop cards) state]
      ++  run
        |=  res=(quip card ^agent)
        ^-  (quip card:agent:gall _state)
        =^  cards  agent  res
        abet:(output cards)
      ::
      ++  response
        |=  res=(response:poke sub)
        ^+  this
        ?-    -.res
            %pine
          =/  =flow  (~(gut by exo) [src.bowl from.res path.res] *flow)
          =.  exo
            %+  ~(put by exo)  [src.bowl from.res path.res]
            flow(aeon (max aeon.flow aeon.res))
          ?-    what.res
              %rock
            ?.  |((lth aeon.rok.flow aeon.res) =(aeon.res 0))  this
            %-  emit
            :*  %pass   /
                %agent  [src.bowl from.res]
                %poke   %sss-request  !>  ^-  request:poke
                [%scry dap.bowl %rock path.res aeon.res]
            ==
          ::
              %wave
            %-  emil
            :-  :*  %pass  (zoom pine/(scot %p src.bowl)^from.res^path.res)
                    %arvo  %b  %wait  (add ~s10 now.bowl)
                ==
            ?.  (lte aeon.flow aeon.res)  ~
            %+  weld
              ?.  (gth aeon.res +(aeon.flow))  ~
              ~[(pine %rock src.bowl from.res path.res)]
            ?:  =(aeon.res aeon.flow)  ~
            %+  turn  (gulf +(aeon.flow) aeon.res)
            |=  =aeon
            :*  %pass   /
                %agent  [src.bowl from.res]
                %poke   %sss-request  !>  ^-  request:poke
                [%scry dap.bowl %wave path.res aeon]
            ==
          ==
        ::
            %scry
          =/  =flow  (~(gut by exo) [src.bowl from.res &5.res] *flow)
          ~&  >  [%new-scry flow=flow response=res]
          ?>  (lth aeon.rok.flow aeon.res)
          ?-    what.res
              %rock
            =^  cards  agent  (on-rock:ag rock.res)
            =.  exo
              %+  ~(put by exo)  [src.bowl from.res &5.res]
              flow(rok [aeon rock]:res, aeon (max aeon.res aeon.flow))
            (output cards)
          ::
              %wave
            =.  wav.flow  (put:(wav sub) wav.flow aeon.res wave.res)
            ?.  =(aeon.res +(aeon.rok.flow))
              this(exo (~(put by exo) [src.bowl from.res &5.res] flow))
            |-
            =^  wave  wav.flow  (del:(wav sub) wav.flow +(aeon.rok.flow))
            ?~  wave  this(exo (~(put by exo) [src.bowl from.res &5.res] flow))
            =/  =rock:sub  (wash:sub rock.rok.flow u.wave)
            =^  cards  agent  (on-wave:ag rock u.wave)
            $(this (output cards), rok.flow [+(aeon.rok.flow) rock])
          ==
        ==
      ::
      ++  output
        |=  cs=(list card)
        %+  roll  cs
        |=  [=card =_this]
        ?+    card  (emit `card:agent:gall`card)
            [%slip %agent * %surf *]  ~|(%slip-surf !!)
            [%pass * %agent * %surf *]
          %-  emil:this
          :~  (pine %wave [ship name path.task]:q.card)
              (pine %rock [ship name path.task]:q.card)
          ==
        ::
            [%give %wave *]
          %=  this  endo
            %+  ~(put by endo)  path.p.card
            =/  =tide  (~(gut by endo) path.p.card *tide)
            =/  next
              .+  %+  max  
                (fall (bind (pry:rok rok.tide) head) 0)
              (fall (bind (ram:(wav pub) wav.tide) head) 0)
            =/  last=[=aeon =rock:pub]  (fall (pry:rok rok.tide) *[key val]:rok)
            =.  wav.tide  (put:(wav pub) wav.tide next wave.p.card)
            ?.  =(next (add aeon.last waves.rul.tide))  tide
            =.  rok.tide
              %+  gas:rok  +<-:gas:rok
              %-  tab:rok  :_  [~ +(rocks.rul.tide)]
              %^  put:rok  rok.tide  next
              %+  roll  (tab:(wav pub) wav.tide `aeon.last waves.rul.tide)
              |=  [[aeon =wave:pub] =_rock.last]
              (wash:pub rock wave)
            %=  tide  wav
              (lot:(wav pub) wav.tide (bind (ram:rok rok.tide) head) ~)
            ==
          ==
        ==
      --
    --
  --
--
