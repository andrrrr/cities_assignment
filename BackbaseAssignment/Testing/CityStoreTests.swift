//
//  CityStoreTests.swift
//  BackbaseAssignment
//
//  Created by Andrei Nevar on 21/04/2020.
//  Copyright © 2020 Andrei Nevar. All rights reserved.
//

import Nimble
import Quick
import SwiftUI

@testable import BackbaseAssignment

class CityStoreTests: QuickSpec {

    override func spec() {
        let treeBuilder = Tree()
        let store = CityStore(treeBuilder: treeBuilder, halt: true)
        var loadTreeFinished = false

        beforeEach {
            

        }

        // test doesn't work, and requires more time to fix. I tried a bunch of stuff:
        // XCTest with XCTestExpectation, then imported Qcuik and Nimble
        // ended up having to inject SceneDelegate, still no luck:
        // it doesn't go inside the closure that searches for some reason.
        // for SceneDelegate to start test app you need to reset content and settings

        context("should find cities") {



            it("should find") {
                var rangeFound = 0..<1
                waitUntil (timeout: 500) { done in
                    treeBuilder.buildTree(store.allCitiesArray, completed: { tree in
                        store.setTree(tree)

                    })
                }

                waitUntil (timeout: 500) { done in
                    store.search(matching: "New York", handler: { range in
                                           rangeFound = range
                            expect((store.allCitiesArray[rangeFound]).contains(where: { $0.name == "New York"})).toEventually(beTrue())
                    })
                }
            }
        }
    }
}
