::
::  INTRO/THE BIG PICTURE
::
::  SSS is intended to function as a *state replication system*. Agent A has a
::  piece of mutable state it wants to make available to its subscribers, and
::  the subscribers should be able to keep in sync with minimal work.
::
::  There exist two obvious solutions to this problem. First, Agent A could send
::  out the entire state every time it changes, but this is obviously wasteful.
::
::  The more efficient solution is for A to only send out instructions on how to
::  *update* the state, but then any subscribed Agent B has to manually
::  interpret these, update its own state, and risk getting some detail wrong.
::  Even if this is done correctly, reimplementing this common pattern in many
::  agents is obviously both wasting wetware and cluttering codebases.
::
::  SSS is how we plan to implement the second solution in kernelspece, reducing
::  code overhead, network load and memory usage at the same time. The prototype
::  library that this current agent demonstrates the usage of does not quite
::  achieve all of those things -- specifically there will be lots of
::  boilerplate -- but it does give us a chance to see how ergonomic this
::  programming is in practice.
::
::  USAGE
::
::  In order to replicate a particular kind of state, we need a `lake`.
::  A `lake` is a polymorphic core of the shape:
::  |$  [rok wav]
::  |%
::  +$  rock  rok
::  +$  wave  wav
::  ++  wash  |=  [rok wav]  *rok
::  ++  name  *term
::  --
::
::  - `rock` is the type of the state to be replicated.
::  - `wave` is the type of the diff or "update instruction" that the
::    publisher emits every time it wants to update its published state.
::  - `wash` is a gate which takes an old state and a diff to a new state.
::  - `name` is not conceptually part of the `lake` but has to be there for this
::    prototype. It should be the name of the lake file.
::
:::::::::::::::::::
::
::  In this demo, `lake`s are stored in /sur:
/-  sum, log
::  NOTE: The publisher and all subscribers need to share the exact same `lake`!
::
::  Each lake also has to have a matching mar file: mar/<name:lake>/hoon.
::  It can be automatically generated this way:
::::::::::::::::::
::  /-  log
::  /+  *sss
::  (mk-mar log)
::::::::::::::::::
::
::  We also import the sss library itself from /lib:
/+  verb, dbug, *sss
::
%-  agent:dbug
%+  verb  &
::
::  In order to subscribe to a state, the agent declares the lake it wants to
::  use and on which paths the states of that shape can be received.
::
::  Here, the `log` lake will be used to manage states on the path `/log`: 
=/  sub-log  (mk-subs log ,[%log ~])
::  Note that the path is specified as a mold! This does not mean that you are
::  free to use molds that aren't path-shaped. Your agent will compile, but you
::  will get runtime errors and the library won't work.
::
::  Similarly, the `sum` lake will be used to manage states on paths starting
::  with `/sum`, e.g. `/sum/foo`, `/sum` or `/sum/foo/bar`. 
=/  sub-sum  (mk-subs sum ,[%sum *])
::
::  In order to publish a state, the agent makes the exact same declaration,
::  using a `lake` and a `path` expressed as a mold.
=/  pub-log  (mk-pubs log ?([%log *] [%other-log ~]))  ::NOTE $? can be used!
=/  pub-sum  (mk-pubs sum ,[%sum %foo ~])
::  Note that these paths aren't exactly identical to the ones used for
::  subscriptions! There is no requirement that the publisher and the subscriber
::  will share the full set of paths, just that they overlap on at least one.
::
|_  =bowl:gall
+*  this  .
    ::
    ::  The data structures created above are managed using two cores. For
    ::  subscriptions there's `da` and for publications there's `du`.
    ::
    ::  `da` and `du` need to be initialized in two steps.
    ::
    ::  First, you monomorphize their types, using the same arguments as when
    ::  the data structures above were created.
    ::
    ::  Second, you call them as a door, with the following sample:
    ::  - the data structure they should manage (the ones from above),
    ::  - your agent's bowl
    ::  - two types (for `da`) or one type (for `du`) that they can't create
    ::    themselves (due to wetness).
    ::
    da-sub-log  =/  da  (da log ,[%log ~])
                ~(. da sub-log bowl -:!>(*result:da) -:!>(*from:da))
::
    da-sub-sum  =/  da  (da sum ,[%sum *])
                ~(. da sub-sum bowl -:!>(*result:da) -:!>(*from:da))
::
    du-pub-log  =/  du  (du log ?([%log *] [%other-log ~]))
                ~(. du pub-log bowl -:!>(*result:du))
::
    du-pub-sum  =/  du  (du sum ,[%sum %foo ~])
                ~(. du pub-sum bowl -:!>(*result:du))
::
++  on-init  `this
::
::  Any subscriptions and publications you want to maintain need to be managed
::  in `+on-save` and `+on-load`:
::
++  on-save  !>([sub-log sub-sum pub-log pub-sum])
++  on-load
  |=  =vase
  =/  old  !<([=_sub-log =_sub-sum =_pub-log =_pub-sum] vase)
  :-  ~
  %=  this
    sub-log  sub-log.old
    sub-sum  sub-sum.old
    pub-log  pub-log.old
    pub-sum  pub-sum.old
  ==
::
::  Most of the magic happens in `+on-poke`. The SSS library will give your
::  agent pokes with the following marks:
::
::  - %sss-on-rock
::    Received whenever a state you're subscribed to has updated.
::  - %sss-to-pub
::    Information to be handled by a du-core (i.e. a publication).
::  - %sss-<lake> (e.g. %sss-log or %sss-sum)
::    Information to be handled by a da-core (i.e. a subscription).
::
::  We will go through all of these below.
::
::  In this example agent, there are also several pokes that simply make the
::  agent do things like open a subscription or reclaim memory used by a
::  publication. Normally, these would be used wherever you need them, but here
::  they're gathered in `+on-poke` because it allows triggering them from the
::  dojo. These marks are arbitrary and unimportant, but we'll go through the
::  functions that they trigger.
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card:agent:gall _this)
  ::
  ::  First of all, both `da` and `du` have arms called `+read`. These are used
  ::  to get the current states you are aware of at different paths.
  ::
  ::  For `+read:da`, the type is `(map [ship dude path] [fail=? rock:lake])`,
  ::  where:
  ::  - `ship` is the ship the state is coming from,
  ::  - `dude` is the agent the state is coming from,
  ::  - `path` is the path the state is coming on -- specifically, it will be of
  ::    the path-as-mold that was passed to `da`,
  ::  - `fail` indicates whether we crashed while processing the latest state
  ::    update, and
  ::  -  `rock:lake` is the current state.
  ::
  ::  For `+read:du`, the type is `(map path rock:lake)`, where:
  ::  - `path` is the path the state is published on -- again, it will be of the
  ::    path-as-mold that was passed to `du`,
  ::  - `rock:lake` is the current state we have published.
  ::
  ::  Here, for example:
  ::  - `read:da-sub-sum` is of type `(map [ship dude [%sum *]] [? rock:sum])`
  ::  - `read:du-pub-log` is of type `(map ?([%log *] [%other-log ~]) rock:log)`
  ::
  ~&  >>  "sub-log was: {<read:da-sub-log>}"
  ~&  >>  "pub-log was: {<read:du-pub-log>}"
  ~&  >>  "sub-sum was: {<read:da-sub-sum>}"
  ~&  >>  "pub-sum was: {<read:du-pub-sum>}"
  ?+    mark  `this
    ::
    ::  Here we use `+give:du` to publish a wave through the `sum`-publication,
    ::  using the only possible path, `/sum/foo`. Think of this as analogous to
    ::  current `[%give %fact paths cage]` cards.
      %add
    =^  cards  pub-sum  (give:du-pub-sum !<([[%sum %foo ~] @ud] vase))
    ~&  >  "pub-sum is: {<read:du-pub-sum>}"
    [cards this]
  ::
  ::  Here we also use `+give:du`, but on the `log`-publication.
      %log
    =^  cards  pub-log
      (give:du-pub-log !<([?([%log *] [%other-log ~]) cord] vase))
    ~&  >  "pub-log is: {<read:du-pub-log>}"
    [cards this]
  ::
  ::  This uses `+surf:da` to open a new `log`-subscription. The head of the
  ::  sample is the ship to subscribe to, followed by the agent and then finally
  ::  the path, which must nest under the paths passed to `da`.
      %surf-log
    :_  this
    ~[(surf:da-sub-log !<(@p (slot 2 vase)) %simple !<([%log ~] (slot 3 vase)))]
  ::
  ::  This again uses `+surf:da` but on a `sum`-subscription.
      %surf-sum
    :_  this
    ~[(surf:da-sub-sum !<(@p (slot 2 vase)) %simple !<([%sum *] (slot 3 vase)))]
  ::
  ::  This uses `+rule:du` in order to set a new retention policy for a state
  ::  published on a particular path. The arguments here are:
  ::  1. The path,
  ::  2. `rocks=@ud`, the maximum number of extra rocks should be kept,
  ::  3. `waves=@ud`, how many waves should pass before a new rock is made.
  ::
  ::  Calling `+rule:du` will *immediately* delete superfluous rocks/waves, and
  ::  if applicable, make a new snapshot at the current aeon.
  ::
  ::  For example, if we previously had 5 rocks stored and 10 waves had passed
  ::  since the previous rock and set the new policy to `[1 2]`, we would create
  ::  a new rock at the current aeon, and then delete all the old rocks except
  ::  for the most recent one. All the waves prior to that rock would also be
  ::  deleted. Then, once two new waves have been given on that same path, a new
  ::  rock will be created, and the the oldest one would be deleted, leaving
  ::  only the rocks that were created after the new retention policy was
  ::  enacted.
  ::
  ::  Setting `waves=0` means "don't generate rocks". Note that this does not
  ::  imply that there won't be any rocks stored! We might have had a different
  ::  rule earlier, and removed old waves, so that when we switched to this
  ::  rule, we still needed to keep an old rock in order to allow any new
  ::  subscribers to get up to date.
  ::
  ::  Similarly, setting `rocks=0` means that there will be zero *extra* rocks.
  ::  There may always be one rock stored, to allow new subscribers to catch up.
      %rule-log
    =.  pub-log
      (rule:du-pub-log !<($%([[%log *] @ud @ud] [[%other-log ~] @ud @ud]) vase))
    ~&  >  "pub-log is: {<read:du-pub-log>}"
    `this
  ::
  ::  Same as above, but for `sum`.
      %rule-sum
    =.  pub-sum  (rule:du-pub-sum !<([[%sum %foo ~] @ud @ud] vase))
    ~&  >  "pub-sum is: {<read:du-pub-sum>}"
    `this
  ::
  ::  Here, we use `+wipe:du` to completely clear out old waves and rocks. Only
  ::  the most recent rock is kept.
      %wipe-log
    =.  pub-log  (wipe:du-pub-log !<(?([%log *] [%other-log ~]) vase))
    ~&  >  "pub-log is: {<read:du-pub-log>}"
    `this
  ::
  ::  Below is one of the marks that the SSS library will poke your agent with.
  ::  Specifically, an agent will get poked with this mark when a state it's
  ::  subscribed to changes. It's not strictly necessary to handle this, but
  ::  if you don't, the `fail` flag in `+read:da` will be `%.y`.
  ::
  ::  To handle these pokes, you need to do two things:
  ::  1. Run `+fled` on the incoming vase, and pass it to `!<`,
  ::  2. using a mold that's constructed as a tagged union ($%) of all your
  ::     subscriptions' on-rock molds, accessed using `$from:da`. 
  ::
  ::  This will give you a cell whose head will be the path that the state is
  ::  available on, and whose tail is
  ::  `[src=ship from=dude =rock:lake wave=(unit wave:lake)]`
  ::
  ::  Most of these should be self-explanatory. The `$wave:lake` is wrapped in
  ::  a `unit` because if the agent is starting from a snapshot, there won't be
  ::  a `$wave` available.
      %sss-on-rock
    ?-    msg=!<($%(from:da-sub-log from:da-sub-sum) (fled vase))
        [[%log ~] *]
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
  ::  Below is the `%sss-to-pub` poke, which any agent that uses the SSS library
  ::  *must* handle *without* crashing in order for the library to function.
  ::  THIS IS PURE BOILERPLATE. Do not do anything interesting here.
  ::
  ::  The things you need to do are as follows:
  ::  1. Run `+fled` on the incoming vase, and pass it to `!<`,
  ::  2. using a mold that's constructed as a tagged union ($%) of all your
  ::     publications' command molds, accessed using `$indo:du`.
  ::  3. Branch on the head of the resulting message and pass the result to the
  ::     appropriate `+apply:du` gate, and use `=^` to update the relevant state
  ::     as well as gathering resulting cards. Return these cards and your agent.
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
  ::  Below are the %sss-<lake> pokes, mentioned above. In our case, these are
  ::  %sss-log and %sss-sum. Again, these *must* be handled properly for the
  ::  SSS library to function properly, and are and should be pure boilerplate.
  ::  %sss-sum is explained below, but %sss-log is completely analogous.
  ::
      %sss-log
    =^  cards  sub-log  (apply:da-sub-log !<(into:da-sub-log (fled vase)))
    ~&  >  "sub-log is: {<read:da-sub-log>}"
    [cards this]
  ::
  ::  We handle %sss-sum in the following way:
  ::  1. Run `+fled` on the incoming vase, and pass it to `!<`,
  ::  2. using the `$into:da` mold of the `da` core that was initialized with
  ::     the `sum` lake.
  ::  3. Pass the result to the appropriate `+apply:da` gate, and use `=^` to
  ::     update the `sub-sum` state, as well as gathering resulting cards.
  ::     Return these cards and your agent.
  ::
      %sss-sum
    =^  cards  sub-sum  (apply:da-sub-sum !<(into:da-sub-sum (fled vase)))
    ~&  >  "sub-sum is: {<read:da-sub-sum>}"
    [cards this]
  ==
::
::  Apart from `+on-poke`, the SSS library also uses `+on-agent` to keep track
::  of when the agent failed to handle an `%sss-on-rock` poke. Essentially,
::  whenever a new state is received, the library causes the agent to poke
::  itself with an `%sss-on-rock` poke, and if that gives back a nack, it will
::  update the failure flag of that rock to `%.y`.
::
::  The acks from `%sss-on-rock` pokes will come over wires shaped like:
::  //sss/on-rock/[aeon]/[ship]/[dude]/[path] (the leading `//` means that the
::  head of the wire is `~`). As a developer you don't need to care about the
::  elements in the middle, only that there are three of them. The thing you do
::  need to do is the branch on the path if you have several types of
::  subscriptions, to determine which of the `da` cores you should use.
::
::  Once you've branched on the path, strip the first three elements of the wire
::  using `|3` and pass it to `+chit:da` and update the data structure for the
::  corresponding subscription with the result. Return a quip with no cards.
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card:agent:gall _this)
  ?>  ?=(%poke-ack -.sign)
  ?~  p.sign  `this
  %-  (slog u.p.sign)
  ?+    wire   `this
      [~ %sss %on-rock @ @ @ %log ~]
    =.  sub-log  (chit:da-sub-log |3:wire sign)
    ~&  >  "sub-log is: {<read:da-sub-log>}"
    `this
  ::
      [~ %sss %on-rock @ @ @ %sum *]
    =.  sub-sum  (chit:da-sub-sum |3:wire sign)
    ~&  >  "sub-sum is: {<read:da-sub-sum>}"
    `this
  ==
::
::  Finally, subscribers also uses `+on-arvo` to keep track of behn timers. The
::  wires here look like the ones in `+on-agent`, and are dispatched to
::  `+behn:da` in the same way (i.e. remember to use `|3`.
::
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card:agent:gall _this)
  ?+  wire  `this
    [~ %sss %behn @ @ @ %sum *]  [(behn:da-sub-sum |3:wire) this]
    [~ %sss %behn @ @ @ %log ~]  [(behn:da-sub-log |3:wire) this]
  ==
::
++  on-peek   _~
++  on-watch  _`this
++  on-leave  _`this
++  on-fail   _`this
--
