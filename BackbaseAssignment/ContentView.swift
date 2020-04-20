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

    private let chunkSize = 20

    @EnvironmentObject var cityStore: CityStore
    @EnvironmentObject var tree: Tree

    var body: some View {

        NavigationView {
            Form {
                Section {
                    if tree.progressValue > 0.99 {
                        TextField("Search", text: $cityStore.searchTerm, onCommit: debouncedFetch)
                            .keyboardType(.namePhonePad)
                            .disableAutocorrection(true)
                    } else {
                        HStack {
                            Text("Building search").font(.footnote).foregroundColor(.gray)
                            ProgressBar(value: $tree.progressValue).frame(height: 10)
                        }
                    }
                }

                Section(header: Text("Cities - \(cityStore.citiesFilteredFullRange.upperBound - cityStore.citiesFilteredFullRange.lowerBound) results")) {

                    List {
                        ForEach(cityStore.citiesFilteredReducedRange, id: \.self) { number in
                            NavigationLink(
                              destination: DetailView(city: self.cityStore.allCitiesArray[number])) {
                                VStack(alignment: .leading) {
                                    Text("\(self.cityStore.allCitiesArray[number].name), \(self.cityStore.allCitiesArray[number].country)")
                                    Text("lat:\(self.cityStore.allCitiesArray[number].coord.lat)  lon:\(self.cityStore.allCitiesArray[number].coord.lon)").font(.footnote).foregroundColor(.gray)
                                }
                            }

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
            }
            .navigationBarTitle("City list")
            .onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil) }
        }
        .onAppear(perform: fetch)

    }

    private func fetch() {
        cityStore.fetch(matching: cityStore.searchTerm)
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

    func loadMore() {
        cityStore.loadMore(chunkSize)
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


