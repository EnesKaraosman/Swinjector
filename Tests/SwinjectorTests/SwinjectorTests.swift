import XCTest
@testable import Swinjector

protocol TestProtocol {
    func test() -> Void
}

class TestClass: TestProtocol, Hashable {
    static func == (lhs: TestClass, rhs: TestClass) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    func test() {
        debugPrint("Tested")
    }
}

final class SwinjectorTests: XCTestCase {
    override func setUp() {
        super.setUp()
        GetIt.I.reset()
    }
    
    override func tearDown() {
        super.tearDown()
        GetIt.I.reset()
    }
    
    func testRegisterLazySingletonIsReallyASingleton() throws {
        let clazz = TestClass()
        
        GetIt.I.registerLazySingleton(TestProtocol.self) {
            clazz
        }
        
        print(clazz.hashValue)
        
        guard let getClazz = GetIt.I(TestProtocol.self) as? TestClass else { return }
        
        XCTAssertEqual(clazz, getClazz)
    }
    
    func testLazySingletonByAnnotation() throws {
        let clazz = TestClass()
        
        GetIt.I.registerLazySingleton(TestProtocol.self) {
            clazz
        }
        
        @Injected(TestProtocol.self) var test
        
        XCTAssertEqual(clazz, test as! TestClass)
    }
}

// `isRegistered` tests
extension SwinjectorTests {
    func testRegisterFactoryIsRegistered() throws {
        GetIt.I.registerFactory(TestProtocol.self) {
            TestClass()
        }
        
        XCTAssertTrue(GetIt.I.isRegistered(TestProtocol.self))
    }
    
    func testRegisterSingletonIsRegistered() throws {
        GetIt.I.registerSingleton(TestProtocol.self, instance: TestClass())
        
        XCTAssertTrue(GetIt.I.isRegistered(TestProtocol.self))
    }
    
    func testRegisterLazySingletonIsRegistered() throws {
        GetIt.I.registerLazySingleton(TestProtocol.self) {
            TestClass()
        }
        
        XCTAssertTrue(GetIt.I.isRegistered(TestProtocol.self))
    }
}

// `unregister` tests
extension SwinjectorTests {
    func testUnregisterLazySingleton() throws {
        let clazz = TestClass()
        
        GetIt.I.registerLazySingleton(TestProtocol.self) {
            clazz
        }
        
        XCTAssertTrue(GetIt.I.isRegistered(TestProtocol.self))
        
        GetIt.I.unregister(TestProtocol.self)
        
        XCTAssertFalse(GetIt.I.isRegistered(TestProtocol.self))
    }
    
    func testUnregisterSingleton() throws {
        let clazz = TestClass()
        
        GetIt.I.registerSingleton(TestProtocol.self, instance: clazz)
        
        XCTAssertTrue(GetIt.I.isRegistered(TestProtocol.self))
        
        GetIt.I.unregister(TestProtocol.self)
        
        XCTAssertFalse(GetIt.I.isRegistered(TestProtocol.self))
    }
}
