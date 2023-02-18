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
See example with extensive comments in [/app/simple.hoon](https://github.com/wicrum-wicrun/sss/blob/master/urbit/app/simple.hoon).
