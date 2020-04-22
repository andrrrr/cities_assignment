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


        context("should find cities") {

            describe("insert + find") {

                it("should find") {
                    var rangeFound = 0..<1
                    waitUntil (timeout: 500) { done in
                        treeBuilder.buildTree(store.allCitiesArray, completed: { tree in
                            store.setTree(tree)
                            done()
                        })
                    }

                    store.search(matching: "New York", handler: { range in
                            rangeFound = range
                            expect((store.allCitiesArray[rangeFound]).contains(where: { $0.name == "New York"})).toEventually(beTrue())
                    })

                }
            }
        }
    }
}
