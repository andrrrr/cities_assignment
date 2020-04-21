//
//  CityStoreTests.swift
//  BackbaseAssignment
//
//  Created by Andrei Nevar on 21/04/2020.
//  Copyright © 2020 Andrei Nevar. All rights reserved.
//

import Nimble
import Quick

@testable import BackbaseAssignment

class CityStoreTests: QuickSpec {

    override func spec() {
        let treeBuilder = Tree()
        let store = CityStore(tree: treeBuilder)
        var loadTreeFinished = false

        beforeEach {
            
            treeBuilder.buildTree(store.allCitiesArray, completed: { _ in
                loadTreeFinished = true
            })
        }


        context("running for the first time") {

            it("should not call the review request") {
                expect(loadTreeFinished).toEventually(beTrue())
                var rangeFound = 0..<1
                store.search(matching: "Moscow", handler: { range in
                    rangeFound = range

                })

                expect((store.allCitiesArray[rangeFound]).contains(where: { $0.name == "Moscow"})).toEventually(beTrue())
            }
        }
    }
}
