---
title: "Gramophile Update"
date: 2024-07-07T14:19:16-07:00
---
Three weeks have passed, and I don't think I did that much. I worked mainly
on the printing piece. I have gramophile reminding me to mint up on certain
records that I want to get OGs of, but the ability to print moves eluded me. I tracked
it down to the fact that whilst I was updating releases, I was just pulling
the release data from Discogs. There's a seperate end point for updating
details about the specific record you're updating. I've nearly finished the update
that will enable that and that should unlock move printing.

Sale adjustments look fine to me, at least under the settings I'm running
on. I'm fairly confident that I have test coverage of the other settings (i.e. 
the ones I don't use myself). I found some bugs that may explain the queue
processing issues but it's still unknown. I think I need to take a week
to understand and remedy that one. And I haven't even started on the design
for proper want handling, I think that's maybe what I should focus on next week.