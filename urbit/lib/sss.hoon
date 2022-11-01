/-  *sss
::
|*  [pub=(lake) sub=(lake)]
|%
++  adit
  |*  [=wire =(lake)]
  %+  slap  !>([lake=lake ..zuse])
  ^-  spec
  :-  %ktcl
  :-  %bccl
  :~  :-  %bccl
      ;;  (lest spec)
      %-  snoc  :_  base/%null
      %+  turn  wire
      |=  =term
      ^-  spec
      [%leaf %tas `@`term]
  ::
      [%like ~[%rock] ~[~[%lake]]]
  ==
::
++  agent
  $_  ^|
  |_  =bowl:agent:gall
  ++  on-init                                   *(quip card _^|(..on-init))
  ++  on-save                                   *vase
  ++  on-load   |~  vase                        *(quip card _^|(..on-init))
  ++  on-poke   |~  [mark vase]                 *(quip card _^|(..on-init))
  ++  on-watch  |~  path                        *(quip card _^|(..on-init))
  ++  on-leave  |~  path                        *(quip card _^|(..on-init))
  ++  on-peek   |~  path                        *(unit (unit cage))
  ++  on-agent  |~  [wire sign:agent:gall]      *(quip card _^|(..on-init))
  ++  on-wave   |~  [rock:sub (unit wave:sub)]  *(quip card _^|(..on-init))
  ++  on-arvo   |~  [wire sign-arvo]            *(quip card _^|(..on-init))
  ++  on-fail   |~  [term tang]                 *(quip card _^|(..on-init))
  --
+$  act
  $%  [%on-init *]
      [%on-watch path]
  ==
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
  $:  exo=(map [ship dude path] (pair @ud rock:sub))
      endo=(map path tide)
      =agent
  ==
+$  tide
  $:  pine=[aeon=@ud =rock:pub]
      wait=((mop @ud (set (pair ship dude))) lte)
      book=((mop @ud wave:pub) gte)
  ==
++  wait  ((on @ud (set (pair ship dude))) lte)
++  book  ((on @ud wave:pub) gte)
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
    =/  old  !<([%sss =_exo =_endo] (slot 3 vase))
    =.  exo   exo.old
    =.  endo  endo.old
    =^  cards  state  (run:handler (on-load:ag (slot 2 vase)))
    [cards this]
  ::
  ++  on-poke
    |=  [=mark =vase]
    ?+      mark
          =^  cards  state  (run:handler (on-poke:ag +<))
          [cards this]
        %sss-request
      =^  cards  state  abet:(request:handler !<(request:poke vase))
      [cards this]
    ::
        %sss-response
      =^  cards  state  abet:(response:handler !<((response:poke sub) vase))
      [cards this]
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
    |=  [wire sign-arvo]
    =^  cards  state  (run:handler (on-arvo:ag +<))
    [cards this]
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
    ++  sss-engine
      |_  cards=(list card:agent:gall)
      +*  ag    ~(. agent bowl)
      ++  this  .
      ++  emit  |=(=card:agent:gall this(cards [card cards]))
::    ++  emil  |=(cs=_cards this(cards (weld cs cards)))  ::TODO roll?
      ++  abet  [(flop cards) state]
      ::
      ++  run
        |=  res=(quip card ^agent)
        ^-  (quip card:agent:gall _state)
        =^  cards  agent  res
        abet:(output cards)
      ::
      ++  request
        |=  req=request:poke
        ^+  this
        ?-    -.req
            %pine
          %-  emit
          :*  %pass   (zoom response/pine/(scot %p src.bowl)^from.req^path.req)
              %agent  [src.bowl from.req]
              %poke   :-  %sss-response  !> ::  ^-  response:poke
              =/  last  pine:(~(gut by endo) path.req *tide)
              [%pine dap.bowl aeon.last path.req rock.last]
          ==
        ::
            %scry
          ?^  wave=(get:book book:(~(got by endo) path.req) aeon.req)
            (respond-scry src.bowl u.wave +.req)
          %=    this
              endo
            %+  ~(jab by endo)  path.req
            |=  =tide
            %=    tide
                wait
              (put:wait wait.tide aeon.req *(set [ship dude]))
            ==
          ==
        ==
      ::
      ++  enqueue
        |=  [=dude =path aeon=@ud]
        ^+  endo
        %+  ~(jab by endo)  path
        |=  =tide
        %=    tide
            wait
          %^  put:wait  wait.tide  aeon
          %-  ~(put in (fall (get:wait wait.tide aeon) ~))
          [src.bowl dude]
        ==
      ::
      ++  respond-scry
        |=  [=ship =wave:pub =dude =path aeon=@ud]
        ^+  this
        %-  emit
        :*  %pass   (zoom response/scry/(scot %p ship)^dude^(scot %ud aeon)^path)
            %agent  [ship dude]
            %poke   :-  %sss-response  !> ::  ^-  response:poke
            [%scry dap.bowl aeon path wave]
        ==
      ::
      ++  response
        |=  res=(response:poke sub)
        ^+  this
        =/  old  (~(gut by exo) [src.bowl from.res &4.res] *[@ud rock:sub])
        =/  new
          ?-    -.res
              %pine
            ?>  |((gth aeon.res -.old) =(+.old rock.res))
            [rock.res ~]
          ::
              %scry
            ?>  =(aeon.res +(-.old))
            [(wash:sub +.old wave.res) `wave.res]
          ==
        =^  cards  agent  (on-wave:ag new)
        =.  exo
          (~(put by exo) [src.bowl from.res &4.res] aeon.res -.new)
        %-  output
        :_  cards
        :*  %pass   (zoom request/scry/(scot %p src.bowl)^from.res^(scot %ud +(aeon.res))^&4.res)
            %agent  [src.bowl from.res]
            %poke   :-  %sss-request  !>  ^-  request:poke
            [%scry dap.bowl &4.res +(aeon.res)]
        ==
      ::
      ++  wave
        |=  [=path =wave:pub]
        ^+  this
        =/  =tide  (~(gut by endo) path *tide)
        =/  next  +(key:(fall (pry:book book.tide) [key=0 value=*wave:pub]))
        =^  waiting=(unit (set (pair ship dude)))  wait.tide  (del:wait wait.tide next)
        =.  endo  (~(put by endo) path tide(book (put:book book.tide next wave)))
        ?~  waiting  this
        %-  ~(rep in u.waiting)
        |=  [[=ship =dude] =_this]
        ^+  this
        (respond-scry:this ship wave dude path next) ::TODO does this really work?
      ::
      ++  output
        |=  cs=(list card)
        %+  roll  cs
        |=  [=card =_this]
        ?+    card  (emit `card:agent:gall`card)
            [%slip %agent * %surf *]    ~|(%slip-surf !!)
            [%give %wave *]             (wave +.p.card)
            [%pass * %agent * %surf *]
          %-  emit
          :*  %pass   (zoom request/pine/(scot %p ship.&4.card)^name.&4.card^p.card)
              %agent  &4.card
              %poke   :-  %sss-request
              !>(`request:poke`[%pine dap.bowl path.task.q.card])
          ==
        ==
      --
    --
  --
--
