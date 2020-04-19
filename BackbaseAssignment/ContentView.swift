//
//  ContentView.swift
//  BackbaseAssignment
//
//  Created by Andrei Nevar on 17/04/2020.
//  Copyright © 2020 Andrei Nevar. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State private var progressValue: Float = 0.0
    @State private var searchTerm: String = ""
    @State var range: Range<Int> = 0..<20
    private let chunkSize = 20

    @EnvironmentObject var cityStore: CityStore
    @EnvironmentObject var tree: Tree
    

    var body: some View {
        NavigationView {
            Form {
                Section {
                    if tree.progressValue > 0.99 {
                        TextField("Search", text: $searchTerm, onCommit: fetch)
                            .keyboardType(.namePhonePad)
                            .disableAutocorrection(true)
                    } else {
                        ProgressBar(value: $tree.progressValue).frame(height: 10)
                    }
                }

                Section(header: Text("Cities - \(arrayDisplayedCount) results")) {

                    if self.searchTerm.isEmpty {
                        List {
                            ForEach(range, id: \.self) {
//                                VStack {
                                    Text("\(self.cityStore.allCitiesArray[$0].name), \(self.cityStore.allCitiesArray[$0].country)").fontWeight(.bold)
//                                    Text("\(self.cityStore.allCitiesArray[$0].coord.lat) - \(self.cityStore.allCitiesArray[$0].coord.lon)").fontWeight(.regular)
//                                }
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
                    } else {
                        List {
                            ForEach(cityStore.citiesFiltered) { city in
//                                VStack {
                                    Text("\(city.name), \(city.country)").fontWeight(.bold)
//                                    Text("\(city.coord.lat) - \(city.coord.lon)").fontWeight(.regular)
//
//                                }
                            }
                        }
                    }

                }
            }.navigationBarTitle("City list")
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            }
        }
        .onAppear(perform: debouncedFetch)
    }

    private func fetch() {
        print("fetch: \(searchTerm)")
        cityStore.fetch(matching: searchTerm)
    }

    private func debouncedFetch () {
        debounce(interval: 200, queue: DispatchQueue.main, action: {
            self.fetch()
        })
    }

    private func debounce(interval: Int, queue: DispatchQueue, action: @escaping (() -> Void)) {
        var lastFireTime = DispatchTime.now()
        let dispatchDelay = DispatchTimeInterval.milliseconds(interval)
        lastFireTime = DispatchTime.now()
        let dispatchTime: DispatchTime = DispatchTime.now() + dispatchDelay

        queue.asyncAfter(deadline: dispatchTime) {
            let when: DispatchTime = lastFireTime + dispatchDelay
            let now = DispatchTime.now()
            if now.rawValue >= when.rawValue {
                action()
            }
        }
    }

    fileprivate func setNewRange(_ upperLimit: Int) {
        self.range = 0..<upperLimit
    }

    private var arrayDisplayedCount: Int {
        return (searchTerm.isEmpty) ? cityStore.allCitiesArray.count : cityStore.citiesFiltered.count
    }

    func loadMore() {
        let upperLimit = self.range.upperBound + self.chunkSize
        setNewRange(min(upperLimit, arrayDisplayedCount))
    }


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


