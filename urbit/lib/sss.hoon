/-  *sss
::
|*  [pub=(lake) sub=(lake)]
|%
++  agent
  $_  ^|
  |_  [bowl:agent:gall (map path rock:pub) (map [ship dude path] [? rock:sub])]
  ++  on-init                                        *(quip card _^|(..on-init))
  ++  on-save                                        *vase
  ++  on-load   |~  vase                             *(quip card _^|(..on-init))
  ++  on-poke   |~  [mark vase]                      *(quip card _^|(..on-init))
  ++  on-watch  |~  path                             *(quip card _^|(..on-init))
  ++  on-leave  |~  path                             *(quip card _^|(..on-init))
  ++  on-peek   |~  path                             *(unit (unit cage))
  ++  on-agent  |~  [wire sign:agent:gall]           *(quip card _^|(..on-init))
  ++  on-rock   |~  [dude rock:sub (unit wave:sub)]  *(quip card _^|(..on-init))
  ++  on-arvo   |~  [wire sign-arvo]                 *(quip card _^|(..on-init))
  ++  on-fail   |~  [term tang]                      *(quip card _^|(..on-init))
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
      rok=[=aeon fail=_| =rock:sub]
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
  +*  ag       ~(. agent bowl inject-endo inject-exo)
      this     .
      handler  ~(sss-core hc bowl)
  ::
  ++  on-init
    =^  cards  state  abet:(run:handler on-init:ag)
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
    =^  cards  state  abet:(run:handler (on-load:ag (slot 2 vase)))
    [cards this]
  ::
  ++  on-poke
    |=  [=mark =vase]
    ?+      mark
          =^  cards  state  abet:(run:handler (on-poke:ag +<))
          [cards this]
        %sss-request
      :_  this
      ~[(~(request hc bowl) !<(request:poke vase))]
    ::
        %sss-response
      =^  cards  state  abet:(response:handler !<((response:poke sub) vase))
      [cards this]
    ::
        %sss-solidify
      ?>  =(src our):bowl
      `this(endo (~(solidify hc bowl) !<(path vase)))
    ==
  ++  on-watch
    |=  path
    =^  cards  state  abet:(run:handler (on-watch:ag +<))
    [cards this]
  ::
  ++  on-leave
    |=  path
    =^  cards  state  abet:(run:handler (on-leave:ag +<))
    [cards this]
  ::
  ++  on-peek  on-peek:ag
  ::
  ++  on-agent
    |=  [=wire =sign:agent:gall]
    ?.  ?=([~ %sss *] wire)
      =^  cards  state  abet:(run:handler (on-agent:ag +<))
      [cards this]
    ?.  ?=(%poke-ack -.sign)  `this
    ?~  p.sign  `this
    ((slog u.p.sign) `this)
  ::
  ++  on-arvo
    |=  [=wire sign=sign-arvo]
    ?.  ?=([~ %sss *] wire)
      =^  cards  state  abet:(run:handler (on-arvo:ag +<))
      [cards this]
    =>  .(wire |2.wire)
    ?.  ?=([%pine ship=@ dude=@ path=*] wire)  ~&  >>>  "weird wire"    `this
    ?.  ?=([%behn %wake ~] sign)               ~&  >>>  "strange sign"  `this
    :_  this
    ~[(~(pine hc bowl) %wave (slav %p &2.wire) &3.wire |3.wire)]
  ::
  ++  on-fail
    |=  [term tang]
    =^  cards  state  abet:(run:handler (on-fail:ag +<))
    [cards this]
  ::
  --
  ++  inject-endo
    ^-  (map path rock:pub)
    %-  ~(run by endo)
    |=  =tide
    val:(fall (pry:rok rok.tide) *[key =val]:rok)
  ::
  ++  inject-exo
    ^-  (map [ship dude path] [? rock:sub])
    %-  ~(run by exo)
    |=  =flow
    [fail rock]:rok.flow
  ::
  ++  hc
    |_  =bowl:gall
    ++  pine
      |=  [=what =ship =dude =path]
      ^-  card:agent:gall
      :*  %pass   /
          %agent  [ship dude]
          %poke   %sss-request  !>  ^-  request:poke
          [%pine dap.bowl what path]
      ==
    ::
    ++  request
      |=  req=request:poke
      ^-  card:agent:gall
      =/  =tide  (~(gut by endo) ?-(-.req %scry path.req, * path.req) *tide)
      ?-    -.req
          %scry
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
    ++  solidify
      |=  =path
      ^+  endo
      %+  ~(put by endo)  path
      =/  =tide  (~(gut by endo) path *tide)
      =^  last  rok.tide  (pop:rok rok.tide)
      =^  next  wav.tide
        %^    (dip:(wav pub) ,[aeon rock:pub])
            (lot:(wav pub) wav.tide `-.last ~)
          last
        |=  [[aeon =rock:pub] [=aeon =wave:pub]]
        ^-  [(unit wave:pub) ? [^aeon rock:pub]]
        [~ | aeon (wash:pub rock wave)]
      tide(rok (put:rok +<-:put:rok next))
    ::
    ++  give
      |=  [=path =wave:pub]
      ^+  endo
      %+  ~(put by endo)  path
      =/  =tide  (~(gut by endo) path *tide)
      =/  next=aeon
        .+  %+  max  
          (fall (bind (pry:rok rok.tide) head) 0)
        (fall (bind (ram:(wav pub) wav.tide) head) 0)
      =/  last=[=aeon =rock:pub]  (fall (pry:rok rok.tide) *[key val]:rok)
      =.  wav.tide  (put:(wav pub) wav.tide next wave)
      ?.  =(next (add aeon.last waves.rul.tide))  tide
      =.  rok.tide
        %+  gas:rok  +<-:gas:rok
        %-  tab:rok  :_  [~ +(rocks.rul.tide)]
        %^  put:rok  rok.tide  next
        %+  roll  (tab:(wav pub) wav.tide `aeon.last waves.rul.tide)
        |=  [[aeon =wave:pub] =_rock.last]
        (wash:pub rock wave)
      tide(wav (lot:(wav pub) wav.tide (bind (ram:rok rok.tide) head) ~))
    ::
    ++  sss-core
      |_  cards=(list card:agent:gall)
      ++  sss   .
      ++  abet  [(flop cards) state]
      ++  emit  |=  =card:agent:gall           sss(cards [card cards])
      ++  emil  |=  cs=(list card:agent:gall)  sss(cards (weld (flop cs) cards))
      ++  run   |=  =(quip card ^agent)        (output(agent +.quip) -.quip)
      ++  output
        |=  cs=(list card)
        %+  roll  cs
        |=  [=card =_sss]
        ?+    card  (emit:sss `card:agent:gall`card)
            [%slip %agent * %surf *]    ~|(%slip-surf !!)
            [%give %wave *]             sss(endo (give [path wave]:p.card))
            [%pass * %agent * %surf *]
          (emit:sss (pine %wave [ship name path.task]:q.card))
        ==
      ::
      ++  response
        |=  res=(response:poke sub)
        ^+  sss
        =/  =path  ?-(-.res %scry &5.res, * path.res)
        =*  current  [src.bowl from.res path]
        =/  =flow  (~(gut by exo) current *flow)
        |^  ?-  -.res
              %pine  abet:pine
              %scry  abet:(scry |3.res)
            ==
        ++  flow-core  .
        ++  abet  sss(exo (~(put by exo) current flow))
        ++  pine
          ^+  flow-core
          =.  aeon.flow  (max aeon.flow aeon.res)
          ?-    what.res
              %rock
            =?  sss  |((lth aeon.rok.flow aeon.res) =(aeon.res 0))
              %:  emit
                %pass   /
                %agent  [src.bowl from.res]
                %poke   %sss-request  !>  ^-  request:poke
                [%scry dap.bowl %rock path aeon.res]
              ==
            flow-core
          ::
              %wave
            =.  sss
              %:  emit
                %pass  (zoom pine/(scot %p src.bowl)^from.res^path)
                %arvo  %b  %wait  (add ~s10 now.bowl)
              ==
            =?  sss  (gth aeon.res +(aeon.flow))
              (emit (^pine %rock current))
            =?  sss  (gth aeon.res aeon.flow)
              %-  emil
              %+  turn  (gulf +(aeon.flow) aeon.res)
              |=  =aeon
              :*  %pass   /
                  %agent  [src.bowl from.res]
                  %poke   %sss-request  !>  ^-  request:poke
                  [%scry dap.bowl %wave path aeon]
              ==
            flow-core
          ==
        ::
        ++  scry  |^
          |=  scry=_|3:*$>(%scry (response:poke sub))
          ^+  flow-core
          ?.  (lth aeon.rok.flow aeon.res)
            %.  flow-core
            (slog leaf/"ignoring stale {<what.scry>} at aeon {<aeon.res>}" ~)
          ?-    what.scry
              %rock
            =.  wav.flow  (lot:(wav sub) wav.flow `aeon.res ~)
            =.  rok.flow  [aeon.res | rock.scry]
            =.  aeon.flow  (max aeon.res aeon.flow)
            (swim ~)
          ::
              %wave
            ?.  =(aeon.res +(aeon.rok.flow))
              flow-core(wav.flow (put:(wav sub) wav.flow aeon.res wave.scry))
            =.  rok.flow  [aeon.res | (wash:sub rock.rok.flow wave.scry)]
            (swim `wave.scry)
          ==
          ++  swim
            |=  wave=(unit wave:sub)
            ^+  flow-core
            =*  ag
              %~  .  agent
              :+  bowl  ~+(inject-endo)
              (~(put by ~+(inject-exo)) current [fail rock]:rok.flow)
            ?-    res=(mule |.((on-rock:ag from.res rock.rok.flow wave)))
                [%& *]  (dive p.res)
                [%| *]
              =.  fail.rok.flow  &
              ?~  res=(mole |.((on-fail:ag %on-rock p.res)))
                (dive `agent)
              (dive u.res)
            ==
          ++  dive
            |=  =(quip card _agent)
            ^+  flow-core
            =.  sss  (run quip)
            =^  wave  wav.flow  (del:(wav sub) wav.flow +(aeon.rok.flow))
            ?~  wave  flow-core
            =.  rok.flow  [+(aeon.rok.flow) | (wash:sub rock.rok.flow u.wave)]
            (swim wave)
          --
        --
      --
    --
  --
--
