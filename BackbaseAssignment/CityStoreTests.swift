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
            

        }


        context("should find cities") {

//            it("should not call the review request") {
//                expect(loadTreeFinished).toEventually(beTrue(), timeout: 5000, pollInterval: 1.0)
//                var rangeFound = 0..<1
//                store.search(matching: "Moscow", handler: { range in
//                    rangeFound = range
//
//                })
//                expect((store.allCitiesArray[rangeFound]).contains(where: { $0.name == "Moscow"})).toEventually(beTrue(), timeout: 5000, pollInterval: 1.0)
//            }

            it("should find") {
                var rangeFound = 0..<1
                waitUntil (timeout: 500) { done in
                    treeBuilder.buildTree(store.allCitiesArray, completed: { tree in
                        store.setTree(tree)

                        store.search(matching: "New York", handler: { range in
                                               rangeFound = range
                                expect((store.allCitiesArray[rangeFound]).contains(where: { $0.name == "New York"})).toEventually(beTrue())
                        })
                    })
                }


//                waitUntil (timeout: 500) { done in
//                    store.search(matching: "New York", handler: { range in
//                        rangeFound = range
//                        expect((store.allCitiesArray[rangeFound]).contains(where: { $0.name == "New York"})).toEventually(beTrue())
//                    })
//
//                }

            }
        }
    }
}
