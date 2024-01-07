public protocol DependencyContainer {
    func registerFactory<T>(_ serviceType: T.Type, factory: @escaping () -> T)
    func registerSingleton<T>(_ serviceType: T.Type, instance: T)
    func registerLazySingleton<T>(_ serviceType: T.Type, factory: @escaping () -> T)

    func resolve<T>(_ serviceType: T.Type) -> T?
    func unregister<T>(_ serviceType: T.Type)
    func isRegistered<T>(_ serviceType: T.Type) -> Bool
    func reset()
}

public class GetIt: DependencyContainer {
    public static let I = GetIt()

    private init() {}

    private var factories: [String: () -> Any] = [:]
    private var singletons: [String: Any] = [:]
    private var lazySingletons: [String: () -> Any] = [:]
    
    public func registerFactory<T>(_ serviceType: T.Type, factory: @escaping () -> T) {
        let key = String(describing: serviceType)
        factories[key] = factory
    }

    public func registerSingleton<T>(_ serviceType: T.Type, instance: T) {
        let key = String(describing: serviceType)
        singletons[key] = instance
    }

    public func registerLazySingleton<T>(_ serviceType: T.Type, factory: @escaping () -> T) {
        let key = String(describing: serviceType)
        lazySingletons[key] = factory
    }

    public func resolve<T>(_ serviceType: T.Type) -> T? {
        let key = String(describing: serviceType)

        if let singleton = singletons[key] as? T {
            return singleton
        } else if let factory = factories[key] {
            let instance = factory() as! T
            return instance
        } else if let lazyFactory = lazySingletons[key] {
            let instance = lazyFactory() as! T
            singletons[key] = instance
            return instance
        }

        return nil
    }

    public func unregister<T>(_ serviceType: T.Type) {
        let key = String(describing: serviceType)
        factories.removeValue(forKey: key)
        singletons.removeValue(forKey: key)
        lazySingletons.removeValue(forKey: key)
    }

    public func reset() {
        factories.removeAll()
        singletons.removeAll()
        lazySingletons.removeAll()
    }
    
    public func isRegistered<T>(_ serviceType: T.Type) -> Bool {
           let key = String(describing: serviceType)
           return factories[key] != nil || singletons[key] != nil || lazySingletons[key] != nil
       }
    
    public func callAsFunction<T>(_ serviceType: T.Type) -> T? {
        resolve(serviceType)
    }
}
