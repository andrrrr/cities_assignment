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
    @State private var searchTerm: String = ""
    @State var range: Range<Int> = 0..<20
    private let chunkSize = 20

    @EnvironmentObject var cityStore: CityStore

    //@State private var citiesSearched: [City] = Bundle.main.decode([City].self, from: "cities.json").sorted(by: { $0.name < $1.name })


//    func search() {
//        citiesSearched = (searchTerm.isEmpty) ? cities : cities.filter { $0.name.starts(with: searchTerm) }
//        if !searchTerm.isEmpty {
//            setNewRange(citiesSearched.count)
//        }
//        //return filteredArray
//    }


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

                        } else {
                            ForEach(cityStore.cities) { city in
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
        print(cityStore.cities.count)
        cityStore.fetch(matching: searchTerm)
    }


    fileprivate func setNewRange(_ upperLimit: Int) {
        self.range = 0..<upperLimit
    }

    func loadMore() {
        if searchTerm.isEmpty {
            var upperLimit = self.range.upperBound + self.chunkSize
            if cityStore.cities.count < upperLimit {
                upperLimit = cityStore.cities.count
            }
            setNewRange(upperLimit)
        }
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


