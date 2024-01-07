# Swinjector

> This package is not ready to be used in production yet. It's created for PoC purpose.

TODO

- [ ] Easify registering and resolving dependency syntax
- [ ] Add more annotations to register dependencies easily. Like @Singleton, @LazySingleton, @Factory (SwiftGen?)
- [ ] Support registering multiple instance of the same type?
- [ ] Add code documentation
- [ ] Unit test code coverage %100

## Register dependencies

```swift
// Lazy singleton is created when you access it
GetIt.I.registerLazySingleton(TestProtocol.self) { TestClass() }

// Singleton is already created by you
GetIt.I.registerSingleton(TestProtocol.self, instance: TestClass())

// New instance is created every time you access it
GetIt.I.registerFactory(TestProtocol.self) { TestClass() }
```

## Access dependencies

```swift
if let clazz = GetIt.I.resolve(TestProtocol.self) {}

// More swifty syntax
if let clazz = GetIt.I(TestProtocol.self) {}

// Access by annotation
@Injected(TestProtocol.self) var clazz
```

## Check if dependency is registered & unregister
```swift
let isRegister = GetIt.I.isRegistered(TestProtocol.self)

GetIt.I.unregister(TestProtocol.self)
```