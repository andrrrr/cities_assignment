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

        if let windowScene = scene as? UIWindowScene {

            let window = UIWindow(windowScene: windowScene)
            let tree = Tree()
            let store = CityStore(tree: tree)
            window.rootViewController = UIHostingController(
                rootView: ContentView().environmentObject(store).environmentObject(tree)
            )
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
