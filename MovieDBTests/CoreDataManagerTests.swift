//
//  CoreDataManagerTests.swift
//  CoreDataManagerTests
//
//  Created by Damir Yackupov on 01.03.2022.
//

import XCTest
@testable import MovieDB

class CoreDataManagerTests: XCTestCase {

    var coreDataManager: CoreDataManagerProtocol?

    override func setUpWithError() throws {
        coreDataManager = CoreDataManager()
    }

    override func tearDownWithError() throws {
        coreDataManager = nil
    }

    func testCRManagerRequest() throws {
        // GIVEN
        let expectation = XCTestExpectation(description: "Get all models from CoreData")
        // WHEN
        do {
            let models = try coreDataManager?.requestModels()
            guard let model = models else {return}
            print(model)
            expectation.fulfill()
            // THEN
            wait(for: [expectation], timeout: 2.0)
        } catch {
            wait(for: [expectation], timeout: 2.0)
        }
    }
    
    func testCRManagerRequestID() throws {
        // GIVEN
        let id = 550
        let expectation = XCTestExpectation(description: "Get model with given ID from CoreData")
        // WHEN
        do {
            let models = try coreDataManager?.requestModels(withId: id)
            guard let model = models else {return}
            print(model)
            expectation.fulfill()
            // THEN
            wait(for: [expectation], timeout: 2.0)
        } catch {
            wait(for: [expectation], timeout: 2.0)
        }
    }

}
