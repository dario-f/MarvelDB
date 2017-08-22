//
//  MarvelClientTests.swift
//  MarvelDBTests
//
//  Created by Dario Fanjul on 21/08/2017.
//  Copyright © 2017 Dario Fanjul. All rights reserved.
//

@testable import MarvelDB
import XCTest

class MarvelClientTests: XCTestCase {
    
    var mockURLSession: MockURLSession!
    var sut: MarvelNetworkClient!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        sut = MarvelNetworkClient(session: mockURLSession)
    }
    
    override func tearDown() {
        sut = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    func testFetchHeroes_ShouldBuildURL() {
        _ = sut.fetchHeroes { (_, _) in }
        
        let request = mockURLSession.requestReceived
        XCTAssertEqual(request?.url?.absoluteString, "https://api.myjson.com/bins/bvyob")
    }
    
    func testFetchHeroes_ShouldCallResume() {
        _ = sut.fetchHeroes { (_, _) in }
        
        let dataTask = mockURLSession.dataTaskReturned
        XCTAssertTrue(dataTask!.resumeCalled)
    }
    
    func testFetchHeroes_ShouldReturnResponse() {
        let bundle = Bundle(for: MarvelClientTests.self)
        let jsonFile = bundle.url(forResource: "SuccessResponse", withExtension: "json")!
        let inputData = try! Data(contentsOf: jsonFile)
        
        let completionCalled = expectation(description: "completion called")
        
        _ = sut.fetchHeroes { (result, error) in
            XCTAssertEqual(result?.count, 6)
            XCTAssertNil(error)
            completionCalled.fulfill()
        }
        
        let requestResponse = HTTPURLResponse(url: URL(string: "https://api.myjson.com/bins/bvyob")!,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)
        
        mockURLSession.completionReceived?(inputData, requestResponse, nil)
        waitForExpectations(timeout: 3, handler: nil)
    }
    
}

extension MarvelClientTests {
    
    class MockURLSession: URLSession {
        
        var requestReceived: URLRequest?
        var completionReceived: ((Data?, URLResponse?, Error?) -> Void)?
        var dataTaskReturned: MockDataTask?
        
        override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            requestReceived = request
            completionReceived = completionHandler
            let dataTask = MockDataTask()
            dataTaskReturned = dataTask
            return dataTask
        }
    }
    
    class MockDataTask: URLSessionDataTask {
        var resumeCalled = false
        
        override func resume() {
            resumeCalled = true
        }
        
    }
}
