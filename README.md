
# GitCommits
> Our mobile application always you to search for a GitHub user and comb through thier repository. In the app you'll be able to get basic details about the user as well as their commit details. 

[![Swift Version][swift-image]][swift-url]



<img src ="GHCommitsHomeScreen.png">

## Features

- [x] URLSession 
- [x] User Defaults
- [x] Storyboards
- [x] Dynamic Dark Mode


## Requirements

- iOS 14.4+
- Xcode 12.5

## Installation 

#### Internet Connection
Ensure you are connected to the interent [iCloud](https://support.apple.com/en-us/HT203512)

## Model Code Snippet 
Utilizing coding keys and Decodable to properly obtain and read the api data 
```swift

struct Repo: Decodable {
    let name: String
    let owner: Owner
}

struct Owner: Decodable {
    let avatarURL: URL?
    let login: String
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case login 
    }
}
}
```
## URLSessions Code Snippet 
Leveraging the Result type to handle success and faliure calls
```swift 

Leveraging the power of URLSessions we can get the users commits 
func fetchRepos(for user: String, completion: @escaping (Result<[Repo], NetworkingError>) -> Void) {
......
}
```
## Let me know what you think

Ivan Ramirez – [@IvansTwitter](https://twitter.com/iramirezdev) – iramirez22ios@gmail.com

[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
