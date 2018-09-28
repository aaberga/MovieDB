# MovieDB
A simple but scalable iOS native app architecture, built around the coordinator pattern and sporting data services.

To operate, run the project on any simulator (or a device).
Upon launch the app will fetch the list of movies playing now in cinemas.

Movie posters are asynchronously fetched, saved on disk and reused in the next collection view reload.

More work is planned to complete grabbing movie details, when the user selects a movie (cell): if a movie is part of a collection, then the 'sub panel' to present movies of the collection, should appear.

To do so, the relevant API call code should be finished and linked to the 'architecture elements' (coordinator and view).

Even if I do generally advocate (and work with) unit tests, I did not need any up to this point, as I was in 'scouting mode'. That means I was progressively adding thought, logic and code, at every build.

Unit tests can capture only part of the process, as it was always starting from the UI (from super rough to OK).

TDD is left as a future element to study, probably at the time when creating an Xcode architectural template out of this (and the additional, related) code exercise(s).  

_Stay tuned._

The current, single UIViewController is one of the shortest ever written. 
It does not contain any logic, network or other code more than simply the methods needed to trigger the network/API call and -asynchronously- the presentation of results.
(It is actually as short as the one created here: https://github.com/aaberga/weather_5d ....

MVC bye, bye!

Inspiration is taken from the cool Coordinator patten presentation at NSSpain 2015, as well as the nice Coordinator tutorial on the Wenderlich site.

a) Presenting Coordinators - Soroush Khanlou
[https://vimeo.com/144116310]()

b) Coordinator Tutorial for iOS: Getting Started
[https://www.raywenderlich.com/158-coordinator-tutorial-for-ios-getting-started]()


The idea about confining any API call logic *out* of the coordinators, in its own layer, is an improvement on a pure coordinators based architecture.
