//
//  ContentView.swift
//  BackbaseAssignment
//
//  Created by Andrei Nevar on 17/04/2020.
//  Copyright © 2020 Andrei Nevar. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State private var searchTerm: String = ""
    @State var range: Range<Int> = 0..<20
    private let chunkSize = 20

    @EnvironmentObject var cityStore: CityStore

    var body: some View {
        NavigationView {
            Form {
                Section {

                    TextField("Search", text: $searchTerm, onCommit: fetch)
                        .keyboardType(.namePhonePad)
                        .disableAutocorrection(true)

                }

                Section(header: Text("Cities")) {

                    List {
                        if searchTerm.isEmpty {
                            ForEach(range, id: \.self) {
                                Text("\(self.cityStore.allCitiesArray[$0].name), \(self.cityStore.allCitiesArray[$0].country)")
                            }
                            Button(action: loadMore) {
                                Text("")
                            }
                            .onAppear {
                                DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 10)) {
                                    self.loadMore()
                                }
                            }

                        } else {
                            ForEach(cityStore.citiesFiltered) { city in
                                Text("\(city.name), \(city.country)")
                            }

                        }
                    }
                }

            }.navigationBarTitle("City list")
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            }
        }.onAppear(perform: fetch)
    }

    private func fetch() {
        cityStore.fetch(matching: searchTerm)
    }


    fileprivate func setNewRange(_ upperLimit: Int) {
        self.range = 0..<upperLimit
    }

    func loadMore() {
        let arrayDisplayedCount = (searchTerm.isEmpty) ? cityStore.allCitiesArray.count : cityStore.citiesFiltered.count
        let upperLimit = self.range.upperBound + self.chunkSize
        setNewRange(min(upperLimit, arrayDisplayedCount))
    }

    let debouncedFunction = SearchAlgorythm.debounce(interval: 200, queue: DispatchQueue.main, action: {
        
    })
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


