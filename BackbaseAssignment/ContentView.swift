//
//  ContentView.swift
//  BackbaseAssignment
//
//  Created by Andrei Nevar on 17/04/2020.
//  Copyright © 2020 Andrei Nevar. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State private var cities = Bundle.main.decode([City].self, from: "cities.json").sorted(by: { $0.name < $1.name })
    @State private var searchTerm = ""

    private let chunkSize = 20
    @State var range: Range<Int> = 0..<20

    var body: some View {

        NavigationView {
            Form {
                Section {

                    TextField("Search", text: $searchTerm)
                        .keyboardType(.alphabet)
                }

                Section(header: Text("Cities")) {
                    List {
                        ForEach(range, id: \.self) {
                            Text("\(self.cities[$0].name), \(self.cities[$0].country)")
                        }
                        Button(action: loadMore) {
                            Text("")
                            }
                            .onAppear {
                                DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 10)) {
                                    self.loadMore()
                                }
                        }
                    }
                }

            }.navigationBarTitle("City list")
        }
    }

    func loadMore() {
        self.range = 0..<self.range.upperBound + self.chunkSize
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
