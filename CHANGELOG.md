# Change Log
All notable changes to this project will be documented in this file.
`APPropertyWrappers` adheres to [Semantic Versioning](http://semver.org/).


## [4.0.0](https://github.com/APUtils/APPropertyWrappers/releases/tag/4.0.0)
Released on `2025-04-03`

#### Added
- [FilePreservedCodable] New property wrapper

#### Changed
- [BoolPreserved] `reset` logic adjust to do not log error on missing file

#### Fixed
- [EquatableFilter_ObservableObserverProjected_UserDefaultCodable] Public inits


## [3.2.0](https://github.com/APUtils/APPropertyWrappers/releases/tag/3.2.0)
Released on 2024-03-25.

#### Added
- [Lazy] Conformance to `CustomStringConvertible` and `CustomDebugStringConvertible`
- [Lazy] `reset()`
- [UserDefault] and [UserDefaultCodable] log warning for '.' in key
- `PrivacyInfo.xcprivacy` resource

#### Changed
- iOS 13 deployment target for example project
- [UserDefault] Behavior change for optional type. Preserve `nil` values instead of removing existing from user defaults

#### Fixed
- [UserDefault] Optional with non-optional default value support fix

#### Improved
- [Lazy] Better multithreading


## [3.1.6](https://github.com/APUtils/APPropertyWrappers/releases/tag/3.1.6)
Released on 2023-05-25.

#### Fixed
- `ObservableObserver` ambiguity


## [3.1.5](https://github.com/APUtils/APPropertyWrappers/releases/tag/3.1.5)
Released on 2023-05-25.

#### Removed
- `EquatableFilter_BehaviorRelayProjected`, please use `EquatableFilter_ObservableObserverProjected` instead


## [3.1.4](https://github.com/APUtils/APPropertyWrappers/releases/tag/3.1.4)
Released on 2023-05-03.

#### Added
- [Lazy] `initialized`


## [3.1.0](https://github.com/APUtils/APPropertyWrappers/releases/tag/3.1.0)
Released on 2023-04-10.

#### Added
- SPM support
- [Atomic]
- [EquatableFilter_BehaviorRelayProjected] init(projectedValue:compare:)
- [EventsProcessor_EquatableFilter_ObservableObserverProjected]
- [EventsProcessor_ObservableObserverProjected]
- [EventsProcessor_ObservableProjected]
- [FilePreserved]
- [UserDefaultCodable] reset()
- [UserDefaultCodable] suit value set fix
- [UserDefaultCodable] `useStorage` init param
- [UserDefault] reset()

#### Fixed
- [Lazy] multithreading fix


## [3.0.0](https://github.com/APUtils/APPropertyWrappers/releases/tag/3.0.0)
Released on 11/18/2021.

#### Added
- BoolPreserved property wrapper

#### Changed
- Lazy .lazyValue -> .projectedValue
- Migrated to RoutableLogger
- Use storage for UserDefault to speedup save/load

#### Fixed
- Fixed UserDefault and UserDefaultCodable suit usage with storage
- Handle UserDefault optional types


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
