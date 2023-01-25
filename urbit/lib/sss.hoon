/-  *sss
::
|%
++  mk-subs
  |*  [=(lake) paths=mold]
  *(map [ship dude paths] (flow lake))
::
++  mk-pubs
  |*  [=(lake) paths=mold]
  *(map paths (tide lake))
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
++  da
  |*  [=(lake) paths=mold]
  |_  [sub=_(mk-subs lake paths) =bowl:gall result-type=type on-rock-type=type]
  +*  wav     ((on aeon wave:lake) lte)
  +$  from    (on-rock:poke lake paths)
  +$  into    (response:poke lake paths)
  +$  result  (request:poke paths)
  ++  pine
    |=  [=what =ship =dude path=paths]
    ^-  card:agent:gall
    :*  %pass   /
        %agent  [ship dude]
        %poke   %sss-to-pub  :-  result-type  ^-  result
        [path dap.bowl %pine what]
    ==
  ++  surf
    |=  [=ship =dude path=paths]
    (pine %wave ship dude path)
  ::
  ++  read
    ^-  (map [ship dude paths] [? rock:lake])
    %-  ~(run by sub)
    |=  =(flow lake)
    [fail rock]:rok.flow
  ::
  ++  chit
    |=  [[aeon=@ ship=@ dude=@ path=paths] =sign:agent:gall]
    ^+  sub
    ?>  ?=(%poke-ack -.sign)
    ?~  p.sign  sub
    %+  ~(jab by sub)  [(slav %p ship) dude path]
    |=  =(flow lake)
    ?.  =(aeon.rok.flow (slav %ud aeon))  flow
    flow(fail.rok &)
  ::
  ++  behn
    |=  [ship=term =dude path=paths]
    ^-  (list card:agent:gall)
    ~[(pine %wave (slav %p ship) dude path)]
  ::
  ++  apply
    |=  res=(response:poke lake paths)
    ~&  >  received-response/res
    =-  ~&  >>  [new-sub/-> cards/-<]  -
    ?@  payload.res
      (pine-response res)
    (scry-response res)
  ::
  ++  timer
    |=  [ship=@ dude=@ path=paths]
    ^-  card:agent:gall
    [%pass (zoom behn/ship^dude^path) %arvo %b %wait (add ~s10 now.bowl)]
  ::
  ++  pine-response
    |=  res=[path=paths from=dude =aeon =what]
    ^-  (quip card:agent:gall _sub)
    =*  current  [src.bowl from.res path.res]
    =/  =(flow lake)  (~(gut by sub) current *(flow lake))
    :_  (~(put by sub) current flow(aeon (max aeon.flow aeon.res)))
    ?-    what.res
        %rock
      ?.  |((lth aeon.rok.flow aeon.res) =(aeon.res 0))  ~
      :~  :*  %pass   /
              %agent  [src.bowl from.res]
              %poke   %sss-to-pub  :-  result-type  ^-  result
              [path.res dap.bowl %scry %rock aeon.res]
      ==  ==
    ::
        %wave
      =/  cards=(list card:agent:gall)
        ~[(timer (scot %p src.bowl) from.res path.res)]
      =?  cards  (gth aeon.res +(aeon.flow))  [(pine %rock current) cards]
      =?  cards  (gth aeon.res aeon.rok.flow)
        %+  weld  cards
        %+  turn  (gulf +(aeon.rok.flow) aeon.res)
        |=  =aeon
        ^-  card:agent:gall
        :*  %pass   /
            %agent  [src.bowl from.res]
            %poke   %sss-to-pub  :-  result-type  ^-  result
            [path.res dap.bowl %scry %wave aeon]
        ==
      cards
    ==
  ::
  ++  scry-response
    |=  $:  path=paths
            =dude
            =aeon
            $%([what=%rock =rock:lake] [what=%wave =wave:lake])
        ==
    ^-  (quip card:agent:gall _sub)
    =*  current  [src.bowl dude path]
    =/  =(flow lake)  (~(gut by sub) current *(flow lake))
    ?.  (lth aeon.rok.flow aeon)
      %.  `sub
      (slog leaf/"ignoring stale {<what>} at aeon {<aeon>}" ~)
    |^
    ?-    what
        %rock
      =.  wav.flow  (lot:wav wav.flow `aeon ~)
      =.  rok.flow  [aeon | rock]
      =.  aeon.flow  (max aeon aeon.flow)
      (swim ~)
    ::
        %wave
      ?:  =(aeon +(aeon.rok.flow))
        =.  rok.flow  [aeon | (wash:lake rock.rok.flow wave)]
        (swim `wave)
      `(~(put by sub) current flow(wav (put:wav wav.flow aeon wave)))
    ==
    ++  swim
      |=  wave=(unit wave:lake)
      ^-  (quip card:agent:gall _sub)
      =^  wave  wav.flow  (del:wav wav.flow +(aeon.rok.flow))
      ?^  wave
        =.  rok.flow  [+(aeon.rok.flow) | (wash:lake rock.rok.flow u.wave)]
        (swim wave)
      :_  (~(put by sub) current flow)
      :~  :*  %pass   (zoom on-rock/(scot %ud aeon.rok.flow)^(scot %p src.bowl)^dude^path)
              %agent  [our dap]:bowl
              %poke   %sss-on-rock  :-  on-rock-type  ^-  from
              [path src.bowl dude rock.rok.flow ^wave]
      ==  ==
    --
  --
++  du
  |*  [=(lake) paths=mold]
  |_  [pub=_(mk-pubs lake paths) =bowl:gall result-type=type]
  +*  rok  ((on aeon rock:lake) gte)
      wav  ((on aeon wave:lake) lte)
  ::
  +$  into    (request:poke paths)
  +$  result  (response:poke lake paths)
  ++  give
    |=  [path=paths =wave:lake]
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
    ^-  (map paths rock:lake)
    %-  ~(run by pub)
    |=  =(tide lake)
    =<  rock
    =/  snap=[=aeon =rock:lake]  (fall (pry:rok rok.tide) *[key val]:rok)
    %+  roll  (tap:wav (lot:wav wav.tide `aeon.snap ~))
    |=  [[=aeon =wave:lake] =_snap]
    ?.  =(aeon +(aeon.snap))  snap
    [aeon (wash:lake rock.snap wave)]
  ::
  ++  wipe
    |=  path=paths
    ^+  pub
    %+  ~(put by pub)  path
    =/  =(tide lake)  (~(gut by pub) path *(tide lake))
    =^  last  rok.tide  (pop:rok rok.tide)
    =^  next  wav.tide
      %^    (dip:wav ,[aeon rock:lake])
          (lot:wav wav.tide `-.last ~)
        last
      |=  [[aeon =rock:lake] [=aeon =wave:lake]]
      ^-  [(unit wave:lake) ? [^aeon rock:lake]]
      [~ | aeon (wash:lake rock wave)]
    tide(rok (put:rok +<-:put:rok next))
  ::
  ++  apply
    |=  req=(request:poke paths)
    ^-  card:agent:gall
    ~&  >  received-request/req
    =-  ~&  >>  cards/-  -  
    =/  =(tide lake)  (~(gut by pub) path.req *(tide lake))
    ?-    type.req
        %scry
      :*  %pass   (zoom response/scry/(scot %p src.bowl)^from.req^(scot %ud aeon.req)^path.req)
          %agent  [src.bowl from.req]
          %poke   %sss-to-sub  :-  result-type  ^-  result
          :*  path.req  dap.bowl  aeon.req
              ?-    what.req
                  %wave  wave/(got:wav wav.tide aeon.req)
                  %rock
                ?:  =(aeon.req 0)  rock/*rock:lake
                rock/(got:rok rok.tide aeon.req)
      ==  ==  ==
    ::
        %pine
      =/  =aeon
        ?-  what.req
          %rock  key:(fall (pry:rok rok.tide) *[=key =val]:rok)
          %wave  key:(fall (ram:wav wav.tide) *[=key =val]:wav)
        ==
      :*  %pass   (zoom response/pine/(scot %p src.bowl)^from.req^path.req)
          %agent  [src.bowl from.req]
          %poke   %sss-to-sub  :-  result-type  ^-  result
          [path.req dap.bowl aeon what.req]
      ==
    ==
  --
--
