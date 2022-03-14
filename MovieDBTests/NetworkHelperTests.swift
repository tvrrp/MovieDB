//
//  NetworkHelperTests.swift
//  MovieDBTests
//
//  Created by Damir Yackupov on 14.03.2022.
//

import XCTest
@testable import MovieDB

class NetworkHelperTests: XCTestCase {

    var networkHelper: NetworkHelper?

    override func setUpWithError() throws {
        networkHelper = NetworkHelper()
    }

    override func tearDownWithError() throws {
        networkHelper = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testFetchMovies() throws {
        //Given
        let moviePageNumber = "1"
        let url = URLFactory(moviePageNumber: moviePageNumber).apiCallURL
        let expectation = XCTestExpectation(description: "Loading films with page 1")

        //When
        networkHelper?.requestMovies(with: url, and: { (result) in
            switch result {
            case .success(_):
                print("Data received")
                expectation.fulfill()
            case .failure(_):
                break
            }
        })

        //Then
        wait(for: [expectation], timeout: 3.0)
    }

    func testFetchMoviePost() throws {
        //Given
        let post = 81754
        let url = URLToPost(moviePostNumber: String(post))
        let expectation = XCTestExpectation(description: "Loading film post")

        //When
        networkHelper?.requestMoviePost(with: url.apiCallURL, and: { (result) in
            switch result {
            case .success(_):
                print("Data received")
                expectation.fulfill()
            case .failure(_):
                break
            }
        })
        //Then
        wait(for: [expectation], timeout: 3.0)
    }

}
