public protocol DependencyContainer {
    @discardableResult func registerFactory<T>(_ serviceType: T.Type, factory: @escaping () -> T) -> Self
    @discardableResult func registerSingleton<T>(_ serviceType: T.Type, instance: T) -> Self
    @discardableResult func registerLazySingleton<T>(_ serviceType: T.Type, factory: @escaping () -> T) -> Self

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
    
    @discardableResult public func registerFactory<T>(_ serviceType: T.Type, factory: @escaping () -> T) -> Self {
        let key = String(describing: serviceType)
        factories[key] = factory
        
        return self
    }

    @discardableResult public func registerSingleton<T>(_ serviceType: T.Type, instance: T) -> Self {
        let key = String(describing: serviceType)
        singletons[key] = instance
        
        return self
    }

    @discardableResult public func registerLazySingleton<T>(_ serviceType: T.Type, factory: @escaping () -> T) -> Self {
        let key = String(describing: serviceType)
        lazySingletons[key] = factory
        
        return self
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
