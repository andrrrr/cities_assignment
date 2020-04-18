//
//  SearchAlgorythm.swift
//  BackbaseAssignment
//
//  Created by Andrei Nevar on 18/04/2020.
//  Copyright © 2020 Andrei Nevar. All rights reserved.
//

import Foundation

class SearchAlgorythm {
     static func debounce(interval: Int, queue: DispatchQueue, action: @escaping (() -> Void)) -> () -> Void {
         var lastFireTime = DispatchTime.now()
         let dispatchDelay = DispatchTimeInterval.milliseconds(interval)

         return {
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
     }
}
