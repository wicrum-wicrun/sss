# Solid-state subscriptions
This is a prototype of solid-state subscriptions/publications, which is the
suggested path to subscription reform. The prototype is implemented in userspace
and has fairly limited functionality -- the intention is only to gather feedback
from real-world agents on how ergonomic this programming model actually is in
practice.

If something seems wrong, dumb, or just overly tedious, it might be an error,
but it could also be intentionally stripped down to allow us to focus on the
core issues. But please give me feedback on everything anyway! Barring
significant negative feedback, the core programming model used inside agents is
expected to be refined but not fundamentally changed, so now is your chance.

Below follows a description of how the current prototype is used, as well as a
discussion on how SSS is likely to evolve.

## The big picture
*(Skip this if you already know what and why SSS is.)*

SSS is intended to function as a *state replication system*. Agent A has a
piece of mutable state it wants to make available to its subscribers, and the
subscribers should be able to keep in sync with minimal work.

There exist two obvious solutions to this problem. First, Agent A could achieve
this by sending out the entire state every time it changes, but this is
obviously wasteful in most cases.

The more efficient solution is for A to only send out instructions on how to
*update* the state, but then any subscribed Agent B has to manually interpret
these, update its own state, and risk getting some detail wrong. Even if this
is done correctly, reimplementing this common pattern in many many agents is
obviously both wasting wetware and cluttering codebases.

SSS is how we plan to implement the second solution in kernelspece, reducing
code overhead, network load and memory usage at the same time.

## Usage
To use this prototype, define a core of the type `$agent:sss` and pass it to
the gate `+mk-agent:sss`. An `$agent:sss` is very similar to a normal
`$agent:gall`, and we will go through the differences
below, but for reference the complete definition is available in
[`/lib/sss/hoon`](/urbit/lib/sss.hoon).

There exists a very simple `$agent:sss` called `%simple` in
[`/app/simple/hoon`](/urbit/app/simple.hoon) that we will use as an example
throughout this explanation.

### Interface declaration: `$lake`
In order for your agent to be able to publish or subscribe to anything, the SSS
system needs two interface declaration cores, one for incoming subscriptions and
one for outgoing publications. Ideally these should be referenced kind of like
marks, but currently they are simply arguments to `+sss`:

```hoon
/+  sss
::
^-  agent:gall
=/  sss  (sss <outgoing-interface-core> <incoming-interface-core>)
%-  mk-agent:sss
^-  agent:sss
<your agent here>
```

Both of these cores need to have the type `$lake` (found in
[`/sur/sss/hoon`](/urbit/sur/sss.hoon)), and we will walk through their arms
below.

### Outgoing publications
Here is `%simple`'s outgoing interface, which declares a simple reverse-order
append-only text log:

```hoon
++  out
  |%
  +$  rock  (list cord)
  +$  wave  cord
  ++  wash
    |=  [rok=rock wav=wave]
    ^+  rok
    [wav rok]
  --
```

Let's take it arm by arm:

- The `$rock` is the type of the **state** that the agent makes available on its
publications. Note that the agent *never* publishes this manually, instead it is
initially bunted, and later possibly snapshotted, by the SSS system.
- The `$wave` is the type of the **diff** or **message** that the agent emits
every time it wants to update the published `$rock`.
- `+wash` is a **transition function**, i.e. a gate used by the SSS system to
get the next `$rock`. Note that the agent *never* calls this manually.

Again, the only part of this that the publishing agent will ever touch directly
is the `$wave`. Its *only* job is to `%give` new `$wave`s, like so:

```hoon
[%give %wave /foo/bar 'hello world!']
```

The SSS system then takes care of distributing these and any relevant `$rock`
snapshots to all *subscribing* agents, which are expected to have matching
`$lake` interfaces on their ends to interpret the incoming information.

### Incoming subscriptions
To receive `$wave`s such as the one above, the subscribing agent has to `%pass`
a `%surf` task to its SSS system, like so:

```hoon
[%pass /start/surf %agent [~sampel-palnet %simple] %surf /foo/bar]
```

This will cause the subscriber to request new `$wave`s as they are published on
the path `/foo/bar`.

#### Incoming interface declaration
Merely subscribing isn't enough, however. The agent also needs an interface
which knows how to handle the data that it receives. Just as with outgoing
publications, this is done using a `$lake` core:

```hoon
++  in
  |%
  +$  rock
    $%  [[%foo %bar ~] (list cord)]
    ==
  +$  wave
    $%  [[%foo %bar ~] cord]
    ==
  ++  wash
    |=  [rok=rock wav=wave]
    ^+  rok
    ?>  =(-.rok -.wav)
    [-.rok [+.wav +.rok]]
  --
```

(You may wonder why the head of the tuples in `$%` are cells instead of atoms.
This is actually something that Hoon already supports, it's just not widely
documented. It works as one would expect.)

The cell that we're using as a tag in the `$%` is `[%foo %bar ~]`, or put
differently: `/foo/bar`. The intention here is to include the `$path` that we
expect data on *in the interface declaration*. The specific way that we do this
here is pretty bad (see e.g. the bureaucracy in `+wash`) and
[the syntax could certainly be better](https://github.com/urbit/urbit/pull/5887),
but this general practice is intended to continue and should eventually be used
for outgoing publications as well.

But except for the inclusion of paths, both `+in` and `+out` represent the same
type of state: a reverse-order append-only text log. Using `+in`, the
subscribing agent can accept incoming data in a new arm called `+on-rock`:

```hoon
++  on-rock
  |=  [dud=dude:gall rok=rock:in wav=(unit wave:in)]
  ?-    -.rok
      [%foo %bar ~]
    ~&  >  "ship {<src.bowl>}, agent {<dud>}, path {<`path`-.rok>}:"
    ~?  >  ?=(^ wav)  "received wave {<+.u.wav>}"
    ~&  >  "rock is now {<+.rok>}"
    `this
  ==
```

Note that since `$rock:in` and `$wave:in` are defined using `$%` where the
head tag is the path, once we've confirmed the path using `?-`, it isn't
necessary to use `!<` to extract the incoming data from a `$vase` -- the typed
value is available directly!

In the sample, `rok` was most likely generated automatically by the subscriber's
SSS system by running `(wash prev-rock wave)`. If this is the case, `wav` will
be `[~ wave]`. But in some cases, the subscriber may not be able to get up to
date by simply downloading `$wave`s, but instead has to request a *snapshot*
`$rock` from the publisher, and then use all subsequent waves to catch up. When
this happens, the first `$rock` in that sequence will not be accompanied by any
wave, which means that `wav` will be `~`. 

### Multiple subscriptions
We could also expand `+in` to handle other types of incoming subscriptions on
other paths, by giving the `$%` multiple children instead of just one. For
example:

```hoon
+$  wave
  $%  [[%foo %bar ~] cord]
      [[%baz ~] @ud]
  ==
```

Of course, `$rock:in` would have to be modified in an analogous way and
`+wash:in` would have to deal with the different cases separately. Both of
these are further reasons for why this particular interface declaration format
isn't ideal.

But note that at the moment, there can only be one *outgoing* publication state
type, i.e. even though the agent can publish different states on many
different paths, all of these states have to be of the same type. This is
obviously not enough for many real-world use cases, but given that the current
interface declaration format isn't expected to remain, support for multiple
state types hasn't been a priority. Let me know if you really need this to test
your agent!


### State replication
So far, the subscriber has only had access to the replicated state in the
`+on-rock` arm, and the publisher has never had access to it. State is supposed
to be always available, so this is clearly insufficient. We solve this by
putting two maps containing all the incoming and outgoing states in the agent's
sample:

```hoon
^-  agent:sss
|_  [=bowl:gall pub=(map path rock:out) sub=(map [ship dude:gall path] rock:in)]
++  on-init
<...>
```

This means that any state that SSS handles, *no* agents will have to. This
decouples code from data and is one important step towards purely functional
agents.

### Subscribing to subpaths
Let's say we have the following `$wave` as part of the incoming interface for a
chat application:

```hoon
+$  wave
  $%  [[%chats ~] @p @da cord]
  ==
```

This is quite restrictive. Since the path in the type is declared explicitly
and statically, we can only ever subscribe to a single path, `/chats`. We can
make it possible to subscribe to dynamic paths while maintaining a static
interface declaration by changing the terminator from `~` to `*`:

```hoon
+$  wave
  $%  [[%chats *] @p @da cord]
  ==
```

This would enable the agent to subscribe to `/chats`, `/chats/chat-1`,
`/chats/chat-2`, `/chats/chat-1/subchat-1` and so on. These would all be handled
using the same `$lake` interface, but would still appear as completely distinct
states in `+on-rock` and the `map` in the agent's sample.

## Evolution of SSS
...
