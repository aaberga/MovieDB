# MovieDB
A simple but scalable iOS native app architecture, built around the coordinator pattern and sporting data services.

To operate, run the project on any simulator (or a device).
Upon launch the app will fetch the list of movies playing now in cinemas.

Movie posters are asynchronously fetched, saved on disk and reused in the next collection view reload.

More work is planned to explore grabbing movie details, obviously when the user selects a movie (cell). 

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
