---
title: "Gramophile"
date: 2024-06-16T14:19:16-07:00
---

So I've been building this thing for a long time, My first pull request was in March 2023, and it's been trundling
along since then. And I'm not fully sure what it is so I thought I'd starting writing about to help me clarify to 
myself what I'm working on.

It's called gramophile, and is a full re-write of something I wrote and tinkered with for a long time (and still do).
But it's kind of an interface into Discogs that allows you to make mass changes to your Discogs info, but also is
kind of a system for managing your record collection. One thing I realised a long time ago is that when you have a
sizable record collection (I'm not putting numbers here deliberately), it's a fair amount of work to manage the whole
thing. You need to add new stuff in, organize it all, have a system for choosing what to keep and what to sell, make
sure you're not forgetting about stuff and so on. So I wrote a whole system that interfaced with Discogs and did
all that for me. And I worked on different features over time, kept some, dropped some and eventually refined
it into something that was genuinely useful. And then added more and more infrastructure to it and landed
where it is today. It's certainly not for everyone but I really like having an organized and methodical system
for managing my record collection.

I also wanted to have other people able to access it, which they could, as long as they mirrored my setup and
could make the necessary code changes required to make it work for someone who was not me. Which was kind of a pain, 
especially as I had written a custom orchestrator and clustering system to support it.

So Gramophile is a rewrite of that system - written for Docker / Kubernetes and also a way of correcting a bunch
of pain points I'd introduced over time. Or that was the intent - it turned out that rewriting 10 years or so of work with principle
was actually kind of slow going and in doing the rewrite I managed to introduce some more pain points to deal with.

But it's also slow to re-write *everything* that I'd written for my origin record collection, and a lot of the processes
and factors were kind of interdependant on each other, so it was also hard to replace things piecemeal. So I wanted
to stop getting into twists and turns, sit down and write out a kind of roadmap for v1 of Gramophile. What should be
present and what is on the back burner - what bugs are blockers for release and whatnot. Just trying to get some
structure to what I'm doing.

## V1 cut

So the V1 cut, expressed as features that Gramophile supports:

1. Performs organization for you - i.e. tells you what records should go where in a given arrangement. Support for
   updating this organization and printing of slot moves.
1. Automatically handles sales - by which I mean once an item is for sale, Gramophile will track it, adjusting the
   price according to a set algorithm until it is sold.
1. Support wantlists. So gramophile will allow you to add a list of items you want, and dynamically add and remove
   them from your Discogs wantlist according to some specified algorithm.

### Organization

Most of the work here is done - I can pull in an organization and have it lay out records as I would want them to be
organized. I operate under a tight fit approach - i.e. the collection should be tight in a given unit, rather than trying
to fit it out across the shelves (though Gramophile does in theory support either approach).

The key issue here, is that I still use my old organization system - mainly because of habit, but also because of slight
differences between the two. On looking through diffs, this is down to a combination of Gramophile being a more precise
organization (it handles certain edge cases better), and also bugs in the difference.

*  **Work Item 1** Align Gramophile and Existing Organization

Another reason I don't currently actively use Gramophile organization is because my old system has built in support for
printing record moves (stay with me, this is one of the most useful things I've found for handling my record collection).
So when a record moves into an organization, I get a print out telling me where it should do. I have a restaurant receipt
printer that I've repurposed for this. I have the infrastructure in place to replicate this on Gramophile, I just need to tidy it up

* **Work Item 2** Fix printing for Gramophile Orgs

### Automatically handles sales

Again, most of this is done - there some finishing off needed, e.g. I still use my old system to actually set something for
sale, but once the sale is created, Gramophile will pick it up and make the necessary price adjustments. I have an 
algorithm in place which I like, where it effectively starts with a high price which gets gradually reduced to the Median price and
then waits there for a period and slowly gets adjusted to the Discogs low price. This is very much a price to sell approach but
it works for me, and I'm in a position where I'll let the market decide the sale price somewhat, rather than hold out for
more money. Sales are hard to validate since even unit tests don't catch how the thing acts in the real world

* **Work Item 3** Validate sale adjustments and wrap up

### Wantlists

Also, mostly done. I can define a one-by-one wantlist that creates a want in Discogs for the first item in the list, waits
for that item to be added to the collection, and then goes on to the next one. I think this is enough for V1 but I found
my process for handling Wants in Gramophile to be quite poor and tricky so I think it would be worth revisiting the whole thing.

* **Work Item 4** Re-design wantlist handling

## Other issues

I run Gramophile on a bare-metal Kubernetes cluster on my home network. It runs in a queued architecture for accessing
anything externally which is nice because it means that we are avoiding throttling from Discogs (which I've generally found
to be somewhat non-deterministic). However I find tracking the activity on the queue difficult, and ran into a bug where
I would flood the queue for some reason and then it would take days to clear.

* **Work Item 5** Resolve issues with queue processing.

## Roadmap

So that's 5 work items remaining for the V1 release, largely sprints and hopefully each less than a weeks worth of work. So
I should be in a position to launch within a month. Let's see how that goes.