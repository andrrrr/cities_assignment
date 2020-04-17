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


    var citiesSearched: [City] {
        let citiesSearched = (searchTerm.isEmpty) ? cities : cities.filter { $0.name.starts(with: searchTerm) }
        return citiesSearched
    }

    var body: some View {

        NavigationView {
            Form {
                Section {

                    TextField("Search", text: $searchTerm)
                        .keyboardType(.namePhonePad)
                        .disableAutocorrection(true)

                }

                Section(header: Text("Cities")) {
                    List {
                        ForEach(range, id: \.self) {
                            Text("\(self.citiesSearched[$0].name), \(self.citiesSearched[$0].country)")
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
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            }
        }
    }

    func loadMore() {
        var upperLimit = self.range.upperBound + self.chunkSize
        if citiesSearched.count < upperLimit {
            upperLimit = citiesSearched.count
        }
        self.range = 0..<upperLimit
    }

    func search(_ searchTerm: String) {
        print("searching \(searchTerm)")
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


