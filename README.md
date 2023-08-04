This document aims to scrape the following websites:

-   <b>ufcstats.com</b> - (bout and fighter statistics)

-   <b>bestfightodds.com</b> - (odds)

-   <b>fightmatrix.com</b> (has historical rankings)

-   <b>sherdog.com</b> (birthday, fight name, country, height, (class,
    total win type, total loss type as of snapshot))

The main idea here is to take the historical events from `ufcstats`,
combine with `sherdog`, and snag whatever previous MMA fight history
outside of ufc events. Then join on the fight odds by UFC event number,
fighter name and birthday.

<u>UFCstats: (fighter page)</u> 
- Height 
- Reach 
- Stance 
- Birthday

<u>UFCstats: (event page)</u> 
- Knockdown 
- Strikes 
- Takedown 
- Submission 
- Weight class 
- Win method 
- Win round 
- Final round time

<u>Sherdog:</u> 
- HISTIORICAL wins/losses by type (useful for
recalculating MMA wins, ufc wins)

<u>bestfightodds:</u> 
- Fight odds for events

<br>

With this data joined together, it should be trivial to engineer some
solid variables for models. Some Ideas that come to mind are: 
- age (from birthday, recalculated as of event date) 
- net win/net loss by method (ex: # of submission wins - # of submission loss, potentially
weighted by experience) 
- some sort of variable to get at fight style (wrestling, jujitsu, etc.) 
- win streak, loss streak 
- title bout wins, current title holder indicator? 
- maybe club ranking or club performance, but with only a handful of serious fighters in a given
club, not sure if that will be good 
- Years in the UFC, years since first professional fight

undecided on whether to take the approach of appending new data as of a
snapshot with a separate scraper for updates, or if behind on events,
just run the whole data pull and break out the current event data to do
some live testing. There are some pros and cons to both:

If the variable engineering is modular enough, it would be
quite nice to pull (or enter manually if a site breaks / odds are
incorrect) the fighters names / birthdays / odds and have the variables
good to go

### Scraping as of event:

-   ensures a model ready dataset for largest possible train window,
    least amount of steps involved
-   if the scraper breaks, historical data would be annoying to
    reference

### Appending new data, updating historical:

-   easy data updates, can switch sites if required. less scraper run
    time.
-   recalculating some fields would require a little more finesse, but
    that will probably need to be done for appending the current fight
    event anyways

### Foreseeable issues:

-   Sites changing, so hopefully the scraper is modular enough to at
    least be able to obtain the data.
-   Poor fight odds. Probably worth checking the fight odds a couple
    days before on bestfightodds, then comparing it with the odds
    incrementally with a live event the day of. (1 hour before the card
    starts, time of card start, time of main event)
-   incorrect birthdays, nicknames, name abbreviation. This would break
    some joins and loose some data. This is especially important if I'm
    unable to capture data when I attempt to feature engineer an
    experience field or something similar.

### Modeling:

-   Probably use a Binomial GLM, predicting just W/L and see how
    predictive the variables are. If they prove to be pretty decent,
    I'll probably try out a couple more types of unsupervised models and
    compare performance, using the GLM as a baseline.
-   If historical vegas odds are accurate enough, might be worth
    exploring prop bets and testing performance.
