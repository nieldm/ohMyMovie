# ohMyPost

## Installation

```
pod install & xed .
```

## Architecture

MVVM with Repositories and combined with RxSwift

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
  - pod 'CSV.swift',         '~> 2.2.1'
    Read CSV files
  - pod 'AlamofireImage',    '~> 3.4'
    Library to handle the download and cache of the images

note: There is few things that can be improved, but it requires more time, i will add them in a future version
