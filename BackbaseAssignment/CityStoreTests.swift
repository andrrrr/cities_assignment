//
//  CityStoreTests.swift
//  BackbaseAssignment
//
//  Created by Andrei Nevar on 21/04/2020.
//  Copyright © 2020 Andrei Nevar. All rights reserved.
//

import XCTest

@testable import BackbaseAssignment

class CityStoreTests: XCTestCase {


    func testFetching() throws {

        let expectation = self.expectation(description: "Building tree")

        let treeBuilder = Tree()
        let store = CityStore(tree: treeBuilder)


        treeBuilder.buildTree(store.allCitiesArray, completed: { newTree in

            expectation.fulfill()

        })

        waitForExpectations(timeout: 500, handler: nil)


        store.search(matching: "Moscow", handler: { range in
            XCTAssertTrue((store.allCitiesArray[range]).contains(where: { $0.name == "Moscow"}))
        })

        store.search(matching: "New York", handler: { range in
            XCTAssertTrue((store.allCitiesArray[range]).contains(where: { $0.name == "New York"}))
        })

        store.search(matching: "kaluGA", handler: { range in
            XCTAssertTrue((store.allCitiesArray[range]).contains(where: { $0.name == "Kaluga"}))
        })



    }
}
