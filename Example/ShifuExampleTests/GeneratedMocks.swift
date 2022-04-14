// MARK: - Mocks generated from file: Shifu/Test.swift at 2022-04-13 16:20:57 +0000

//
//  Test.swift
//  ShifuExampleTests
//
//  Created by Baoli Zhai on 2022/4/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Cuckoo
@testable import ShifuExample


 class MockTest: Test, Cuckoo.ClassMock {
    
     typealias MocksType = Test
    
     typealias Stubbing = __StubbingProxy_Test
     typealias Verification = __VerificationProxy_Test

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: Test?

     func enableDefaultImplementation(_ stub: Test) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func say() -> String {
        
    return cuckoo_manager.call("say() -> String",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.say()
                ,
            defaultCall: __defaultImplStub!.say())
        
    }
    

	 struct __StubbingProxy_Test: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func say() -> Cuckoo.ClassStubFunction<(), String> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTest.self, method: "say() -> String", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_Test: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func say() -> Cuckoo.__DoNotUse<(), String> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("say() -> String", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class TestStub: Test {
    

    

    
    
    
     override func say() -> String  {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
}

