//
//  SceneDelegate.swift
//  BackbaseAssignment
//
//  Created by Andrei Nevar on 17/04/2020.
//  Copyright © 2020 Andrei Nevar. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let store = CityStore(service: .init())
        window.rootViewController = UIHostingController(
            rootView: ContentView().environmentObject(store)
        )
        self.window = window
        window.makeKeyAndVisible()
    }
}
