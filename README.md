## Yelp

This is a Yelp search app using the [Yelp API](http://developer.rottentomatoes.com/docs/read/JSON).

Time spent: `12`

### Installation

1. Clone repo.
2. `git submodule update --init`
3. `cd ReactiveCocoa; script/bootstrap; cd ..`
4. `pod update`

### Notes

Once again, I built this app using the MVVM
pattern. [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)
is used heavily to glue the components together.

In the past, I've decoupled services (e.g. `YelpService`,
`ViewModelServices`) from their implementation(s) through protocols
that are then implemented with a `ServiceNameImpl` class -- this is a
pattern that I've grown to like, but have found unnecessary for these
projects due to the lack of a need to mock classes for testing purposes.

There are some bits of code that I'd like to improve upon -- I'm not
too happy with my models surrounding filters -- much of the code found
in `FiltersViewModel.swift` could be considerably cleaned up with a
better model implementation, but alas -- I'm out of time.

Unfortunately, I spend much more time than I had anticipated dealing
with `ReactiveCocoa` bindings in reusable cells -- this caused a
number of strange bugs that are rather difficult to figure out given
that `ReactiveCocoa` is a very ObjC-heavy library and doesn't play
entirely well with Swift (or at least my knowledge of ObjC -- or Swift
for that matter -- isn't quite good enough to figure out what's going on).

I'm happy with the architecture and learned quite a bit in the process, so that's a win.

Also of note, constraints work on rotation to landscape!

### Features

#### Required

- [x] Search results page
   - [x] Table rows should be dynamic height according to the content height
   - [x] Custom cells should have the proper Auto Layout constraints
   - [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
- [x] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
   - [x] The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off).
   - [x] The filters table should be organized into sections as in the mock.
   - [x] You can use the default UISwitch for on/off states. Optional: implement a custom switch
   - [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
   - [x] Display some of the available Yelp categories (choose any 3-4 that you want).

#### Optional

- [ ] Search results page
   - [ ] Infinite scroll for restaurant results
   - [ ] Implement map view of restaurant results
- [ ] Filter page
   - [ ] Radius filter should expand as in the real Yelp app
   - [ ] Categories should show a subset of the full list with a "See All" row to expand. Category list is here: http://www.yelp.com/developers/documentation/category_list (Links to an external site.)
- [ ] Implement the restaurant detail page.

### Walkthrough

![Video Walkthrough](...)

### Credits

* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [JGProgressHUD](https://github.com/JonasGessner/JGProgressHUD)
* [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)
