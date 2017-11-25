# Project 2 - Flix

Flix is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).


## User Stories

The following **required** functionality is complete:

- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the Alamofire library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] User sees an error message when there's a networking error.
- [x] Movies are displayed using a CollectionView instead of a TableView.
- [ ] User can search for a movie.
- [ ] All images fade in as they are loading.
- [ ] User can view the large movie poster by tapping on a cell.
- [ ] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [ ] Customize the selection effect of the cell.
- [ ] Customize the navigation bar.
- [ ] Customize the UI.

## User Stories

The following **required** functionality is completed:

- [x] User can tap a cell to see a detail view
- [x] User can tap a tab bar button to view a grid layout of Movie Posters using a CollectionView

The following **optional** features are implemented:

- [x] User can tap a poster in the collection view to see a detail screen of that movie
- [ ] In the detail view, when the user taps the poster, a new screen is presented modally where they can view the trailer
- [ ] Customize the navigation bar

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://i.imgur.com/sZyQguE.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Credits

- [Alamofire](https://github.com/Alamofire/Alamofire) - networking task library
- [SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD) - displays loading state
- [Reachability](https://github.com/ashleymills/Reachability.swift) - determines network reachability status

## License

Copyright [2017] [Jamie Shi]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
