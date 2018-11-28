# ohMyPost

This app is based in an Skeleton built by myself, that handles many things

## Installation

```
pod install && xed .
```

## Architecture

MVVM with Repositories and combined with RxSwift

## Layers

The App is splited in 

  - Network Layer: This one is tied to the Business Logic so its on the main target of the application, it's handle by the library Moya and a Repository that implements the Core API logic
  - Persistence Layer: This is a simple one and also is tied to the Business Logic, i use core data in this case so it will save al the elements and handle the watched and favorite state
  - Core: is in a separated target, not tied to UIKit so it can be used in Mac app or Notification extensions among others
  - View Layer: is all done in a programmatically way, so it won't have imposible conflicts like the xib or storyboards

## Responsabilities

This app is built based on the classes with have only one resposability, but there is one that handle 2 resposabilities, in this case is the ViewController, it handles the view but also the navigation, this was do it that way becase the app is not too complex, but to fix that we can add a Coordinator.

## Libraries

  - pod 'Moya/RxSwift',      '~> 10.0'
    It's network layer abstraction, that converts the API (in this case the JSONPlaceholder) in an Enum, 
    capable to make request in strong type way, with the posibility to add mocks
  - pod 'Then',              '~> 2.3'
    It's used to add sugar syntax to almost everything
  - pod 'RxSwift',           '~> 4.0'
    Add a functional reactive way to handle updates and events in the app
  - pod 'SnapKit',           '~> 4.2'
    Library to create constraints in a more readable way, all the views in this example are created by code.
  - pod 'RxDataSources',     '~> 3.0'
    This one is a library with a diff algorithm to handle updates in TableViews and CollectionViews
  - pod 'AlamofireImage',    '~> 3.4'
    Library to handle the download and cache of the images

note: There is few things that can be improved, but it requires more time, i will add them in a future version
