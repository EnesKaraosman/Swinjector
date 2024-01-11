import XCTest
@testable import Swinjector

protocol TestProtocol {}

class TestClass: TestProtocol, Equatable {
    static func == (lhs: TestClass, rhs: TestClass) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

fileprivate let getIt = GetIt.I

final class SwinjectorTests: XCTestCase {
    override func setUp() {
        super.setUp()
        getIt.reset()
    }
    
    override func tearDown() {
        super.tearDown()
        getIt.reset()
    }
    
    func testRegisterLazySingletonIsReallyASingleton() throws {
        let instance = TestClass()
        
        getIt.registerLazySingleton(TestProtocol.self) { instance }
        
        guard let resolvedInstance = getIt(TestProtocol.self) as? TestClass
        else { return }
        
        XCTAssertEqual(instance, resolvedInstance)
    }
    
    func testLazySingletonByAnnotation() throws {
        let instance = TestClass()
        
        getIt.registerLazySingleton(TestProtocol.self) { instance }
        
        @Injected(TestProtocol.self) var test
        
        XCTAssertEqual(instance, test() as! TestClass)
    }
}

// MARK: resolve tests
extension SwinjectorTests {
    func testResolveFactoryInstance() throws {
        getIt.registerFactory(TestProtocol.self) { TestClass() }
        
        XCTAssertNotNil(getIt(TestProtocol.self))
    }
    
    func testResolveLazySingletonInstance() throws {
        getIt.registerLazySingleton(TestProtocol.self) { TestClass() }
        
        XCTAssertNotNil(getIt(TestProtocol.self))
    }
    
    func testResolveSingletonInstance() throws {
        getIt.registerSingleton(TestProtocol.self, instance: TestClass())
        
        XCTAssertNotNil(getIt(TestProtocol.self))
    }
    
    func testResolveShouldReturnNilForNonMatchingType() throws {
        getIt.registerSingleton(Int.self, instance: 1)
        
        XCTAssertNil(getIt(TestProtocol.self))
    }
}

// MARK: isRegistered tests
extension SwinjectorTests {
    func testRegisterFactoryIsRegistered() throws {
        getIt.registerFactory(TestProtocol.self) { TestClass() }
        
        XCTAssertTrue(getIt.isRegistered(TestProtocol.self))
    }
    
    func testRegisterSingletonIsRegistered() throws {
        getIt.registerSingleton(TestProtocol.self, instance: TestClass())
        
        XCTAssertTrue(getIt.isRegistered(TestProtocol.self))
    }
    
    func testRegisterLazySingletonIsRegistered() throws {
        getIt.registerLazySingleton(TestProtocol.self) { TestClass() }
        
        XCTAssertTrue(getIt.isRegistered(TestProtocol.self))
    }
}

// MARK: unregister tests
extension SwinjectorTests {
    func testUnregisterLazySingleton() throws {
        getIt.registerLazySingleton(TestProtocol.self) { TestClass() }
        
        XCTAssertTrue(getIt.isRegistered(TestProtocol.self))
        
        getIt.unregister(TestProtocol.self)
        
        XCTAssertFalse(getIt.isRegistered(TestProtocol.self))
    }
    
    func testUnregisterSingleton() throws {
        getIt.registerSingleton(TestProtocol.self, instance: TestClass())
        
        XCTAssertTrue(getIt.isRegistered(TestProtocol.self))
        
        getIt.unregister(TestProtocol.self)
        
        XCTAssertFalse(getIt.isRegistered(TestProtocol.self))
    }
}
