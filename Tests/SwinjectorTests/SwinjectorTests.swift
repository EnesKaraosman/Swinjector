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
    func testRegisterFactoryIsRegistered() throws {
        GetIt.I.reset()
        
        GetIt.I.registerFactory(TestProtocol.self) {
            TestClass()
        }
        
        XCTAssertTrue(GetIt.I.isRegistered(TestProtocol.self))
    }
    
    func testRegisterSingletonIsRegistered() throws {
        GetIt.I.reset()
        
        GetIt.I.registerSingleton(TestProtocol.self, instance: TestClass())
        
        XCTAssertTrue(GetIt.I.isRegistered(TestProtocol.self))
    }
    
    func testRegisterLazySingletonIsRegistered() throws {
        GetIt.I.reset()
        
        GetIt.I.registerLazySingleton(TestProtocol.self) {
            TestClass()
        }
        
        XCTAssertTrue(GetIt.I.isRegistered(TestProtocol.self))
    }
    
    func testRegisterLazySingletonIsReallyASingleton() throws {
        GetIt.I.reset()
        
        let clazz = TestClass()
        
        GetIt.I.registerLazySingleton(TestProtocol.self) {
            clazz
        }
        
        print(clazz.hashValue)
        
        guard let getClazz = GetIt.I(TestProtocol.self) as? TestClass else { return }
        print(getClazz.hashValue)
        
        XCTAssertEqual(clazz, getClazz)
    }
}
