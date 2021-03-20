# Change Log
All notable changes to this project will be documented in this file.
`APPropertyWrappers` adheres to [Semantic Versioning](http://semver.org/).

## [2.0.0](https://github.com/APUtils/APPropertyWrappers/releases/tag/2.0.0)
Released on 03/20/2021.

#### Added
- Ability to route logs
- RxSwift subspec

#### Added RxSwift simple property wrappers
- BehaviorRelayProjected
- EquatableFilter
- ObservableProjected

#### Added RxSwift complex property wrappers
- EquatableFilter_BehaviorRelayProjected
- EquatableFilter_ObservableObserverProjected
- EquatableFilter_ObservableObserverProjected_UserDefaultCodable
- EquatableFilter_ObservableProjected

#### Changed
- UserDefaultCodable can store simple codables from now on

#### Improved
- Performace for UserDefaultCodable

#### Renamed
- UserDefaultsBacked -> UserDefault
- UserDefaultsCodableBacked -> UserDefaultCodable


## [1.0.0](https://github.com/APUtils/APPropertyWrappers/releases/tag/1.0.0)
Released on 12/26/2019.

#### Added
- Initial release of APPropertyWrappers.
  - Added by [Anton Plebanovich](https://github.com/anton-plebanovich).
