/-  *sss
::
|%
++  mk-subs
  |*  [=(lake) (list path)]
  *(map [ship dude path] (flow lake)) ::TODO $% paths
::
++  mk-pubs
  |*  [=(lake) (list path)]
  *(map path (tide lake))
::
++  da
  |*  =(lake)
  |_  [sub=(exo lake) =bowl:gall]
  +*  hc    ~(. ^hc bowl)
      wav  ((on aeon wave:lake) lte)
  +$  on-rock  [dude:gall rock:lake (unit wave:lake)]
  ++  surf  (pine:hc %wave [ship name path.task]:q.card)
  ++  read
    ^-  (map [ship dude path] [? rock:sub])
    %-  ~(run by sub)
    |=  =flow
    [fail rock]:rok.flow
  ::
  ++  pine-response
    |=  res=$>(%pine (response:poke lake))
    ^-  (quip card:agent:gall _sub)
    =*  current  [src.bowl from.res path.res]
    =/  =(flow lake)  (~(gut by sub) current *(flow lake))
    :_  %+  ~(put by sub)  current
        flow(aeon (max aeon.flow aeon.res))
    ?-    what.res
        %rock
      ?.  |((lth aeon.rok.flow aeon.res) =(aeon.res 0))  ~
      :~  :*  %pass   /
              %agent  [src.bowl from.res]
              %poke   %sss-request  !>  ^-  request:poke
              [%scry dap.bowl %rock path aeon.res]
      ==  ==
    ::
        %wave
      =/  cards=(list card:agent:gall)
        :_  ~
        :*  %pass  (zoom pine/(scot %p src.bowl)^from.res^path)
            %arvo  %b  %wait  (add ~s10 now.bowl)
        ==
      =?  cards  (gth aeon.res +(aeon.flow))  [(pine:hc %rock current) cards]
      =?  cards  (gth aeon.res aeon.flow)
        %+  weld  cards
        %+  turn  (gulf +(aeon.flow) aeon.res)
        |=  =aeon
        :*  %pass   /
            %agent  [src.bowl from.res]
            %poke   %sss-request  !>  ^-  request:poke
            [%scry dap.bowl %wave path aeon]
        ==
      cards
    ==
  ::
  ++  scry-response
    |=  res=$>(%scry (response:poke lake))
    ^-  (quip card:agent:gall _sub)
    ?.  (lth aeon.rok.flow aeon.res)
      %.  `sub
      (slog leaf/"ignoring stale {<what.res>} at aeon {<aeon.res>}" ~)
    =*  current  [src.bowl from.res &5.res]
    =/  =(flow lake)  (~(gut by sub) current *(flow lake))
    |^
    ?-    what.res
        %rock
      =.  wav.flow  (lot:wav wav.flow `aeon.res ~)
      =.  rok.flow  [aeon.res | rock.res]
      =.  aeon.flow  (max aeon.res aeon.flow)
      (swim ~)
    ::
        %wave
      ?.  =(aeon.res +(aeon.rok.flow))
        `(~(put by sub) current flow(wav (put:wav wav.flow aeon.res wave.res)))
      =.  rok.flow  [aeon.res | (wash:sub rock.rok.flow wave.res)]
      (swim `wave.res)
    ==
    ++  swim
      |=  wave=(unit wave:lake)
      ^-  (quip card:agent:gall _sub)
      =^  wave  wav.flow  (del:wav wav.flow +(aeon.rok.flow))
      ?^  wave
        =.  rok.flow  [+(aeon.rok.flow) | (wash:sub rock.rok.flow u.wave)]
        (swim wave)
      :_  (~(put by sub) current flow)
      :~  :*  %pass   //sss/something
              %agent  [our dap]:bowl
              %poke   on-rock+!>([from.res rock.rok.flow ^wave])
      ==  ==
    --
  --
++  du
  |*  =(lake)
  |_  [pub=(endo lake) =bowl:gall]
  +*  rok  ((on aeon rock:lake) gte)
      wav  ((on aeon wave:lake) lte)
  ::
  ++  give
    |=  [=path =wave:lake]
    ^+  pub
    %+  ~(put by pub)  path
    =/  =(tide lake)  (~(gut by pub) path *(tide lake))
    =/  next=aeon
      .+  %+  max  
        (fall (bind (pry:rok rok.tide) head) 0)
      (fall (bind (ram:wav wav.tide) head) 0)
    =/  last=[=aeon =rock:lake]  (fall (pry:rok rok.tide) *[key val]:rok)
    =.  wav.tide  (put:wav wav.tide next wave)
    ?.  =(next (add aeon.last waves.rul.tide))  tide
    =.  rok.tide
      %+  gas:rok  +<-:gas:rok
      %-  tab:rok  :_  [~ +(rocks.rul.tide)]
      %^  put:rok  rok.tide  next
      %+  roll  (tab:wav wav.tide `aeon.last waves.rul.tide)
      |=  [[aeon =wave:lake] =_rock.last]
      (wash:lake rock wave)
    tide(wav (lot:wav wav.tide (bind (ram:rok rok.tide) head) ~))
  ::
  ++  read
    ^-  (map path rock:lake)
    %-  ~(run by pub)
    |=  =tide
    val:(fall (pry:rok rok.tide) *[key =val]:rok)
  ::
  ++  wipe
    |=  =path
    ^+  pub
    %+  ~(put by pub)  path
    =/  =(tide lake)  (~(gut by pub) path *(tide lake))
    =^  last  rok.tide  (pop:rok rok.tide)
    =^  next  wav.tide
      %^    (dip:wav ,[aeon rock:pub])
          (lot:wav wav.tide `-.last ~)
        last
      |=  [[aeon =rock:pub] [=aeon =wave:pub]]
      ^-  [(unit wave:pub) ? [^aeon rock:pub]]
      [~ | aeon (wash:pub rock wave)]
    tide(rok (put:rok +<-:put:rok next))
  ::
  ++  request
    |=  req=request:poke
    ^-  card:agent:gall
    =/  =(tide lake)
      (~(gut by endo) ?-(-.req %scry path.req, * path.req) *(tide lake))
    ?-    -.req
        %scry
      :*  %pass   (zoom response/scry/(scot %p src.bowl)^from.req^(scot %ud aeon.req)^path.req)
          %agent  [src.bowl from.req]
          %poke   %sss-response  !>
          :*  %scry  dap.bowl  aeon.req  what.req  path.req
              ?-  what.req
                %rock  (got:rok rok.tide aeon.req)
                %wave  (got:wav wav.tide aeon.req)
      ==  ==  ==
    ::
        %pine
      =/  aeon=@ud
        ?-  what.req
          %rock  key:(fall (pry:rok rok.tide) *[=key =val]:rok)
          %wave  key:(fall (ram:wav wav.tide) *[=key =val]:wav)
        ==
      :*  %pass   (zoom response/pine/(scot %p src.bowl)^from.req^path.req)
          %agent  [src.bowl from.req]
          %poke   %sss-response  !>  ^-  (response:poke)
          [%pine dap.bowl aeon what.req path.req]
      ==
    ==
  --
::
+$  rule  [rocks=_1 waves=_5]
+$  aeon  @ud
++  tide
  |*  =(lake)
  $:  rok=((mop aeon rock:lake) gte)
      wav=((mop aeon wave:lake) lte)
      rul=rule
  ==
++  flow
  |*  =(lake)
  $:  =aeon
      rok=[=aeon fail=_| =rock:lake]
      wav=((mop aeon wave:lake) lte)
  ==
::
++  zoom  |=  =path  `^path`$/sss/path
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
  --
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
      --
    --
  --
--
