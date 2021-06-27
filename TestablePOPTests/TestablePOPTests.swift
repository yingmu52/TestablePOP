//
//  TestablePOPTests.swift
//  TestablePOPTests
//
//  Created by Xinyi Zhuang on 2021-06-27.
//

import XCTest
@testable import TestablePOP

class TestablePOPTests: XCTestCase {

    let mockService = MockService()

    func testViewControllerNotNil() {
        let viewController = ViewController.makeInstance(with: mockService)
        XCTAssertNotNil(viewController)
    }
    
    func testFetchItems() {
        let viewController = ViewController.makeInstance(with: mockService)
        viewController?.viewDidLoad()
        XCTAssertEqual(viewController?.items, [
            .init(userId: 1, id: 1, title: "1", completed: true),
            .init(userId: 2, id: 2, title: "2", completed: false),
        ])
    }
}

final class MockService: ServiceProtocol {
    func fetchItems(completion: @escaping ((Result<[Item], ServiceError>) -> Void)) {
        completion(.success([
            .init(userId: 1, id: 1, title: "1", completed: true),
            .init(userId: 2, id: 2, title: "2", completed: false),
        ]))
    }
}
