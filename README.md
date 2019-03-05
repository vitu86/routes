# Routes
## What?
Fifth project of iOS Developer Udacity Nanodegree Course
## How it works?
User define two locations to search for routes. The app will look for a route and show images through the route using Flickr API. The app also saves the history of routes.

---

## How to run:
1. You can [clone](https://help.github.com/en/articles/cloning-a-repository) or [download](https://stackoverflow.com/questions/6466945/fastest-way-to-download-a-github-project) the repository
2. [Install CocoaPods on your machine](https://guides.cocoapods.org/using/getting-started.html) (Just if your don't have yet)
3. Run `pod install` in the project folder
4. You're free to run

---

## Detailed explanation
#### There are four screens on the project:
1. **Home screen:** Here you input two places to search for routes. In navigation bar you can find a history button.
2. **History screen:** Here you can see the list of successful routes found. The app does not save places that didn't find any route. Here you can click to see the route or swipe to delete the history item.
3. **Map screen:** You can arrive here from home screen or history screen. The app shows you one route using the places you used before. Here there's a button on the bottom that lead to photo list screen and a button on navigation bar where you can change the map type to show.
4. **Photo list screen:** Here you find photos from the locations of your route. All photos are from Flickr API.
