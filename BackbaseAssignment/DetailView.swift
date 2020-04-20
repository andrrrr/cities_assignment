//
//  DetailView.swift
//  BackbaseAssignment
//
//  Created by Andrei Nevar on 21/04/2020.
//  Copyright © 2020 Andrei Nevar. All rights reserved.
//

import SwiftUI

struct DetailView: View {
  let city: City
  var body: some View {
    Text(city.name)
  }
}
