//
//  TestingSceneDelegate.swift
//  BackbaseAssignment
//
//  Created by Andrei Nevar on 21/04/2020.
//  Copyright © 2020 Andrei Nevar. All rights reserved.
//

import UIKit
import SwiftUI

class TestingSceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        if let windowScene = scene as? UIWindowScene {

            let window = UIWindow(windowScene: windowScene)
//            let tree = Tree()
//            let store = CityStore(tree: tree)
            window.rootViewController = UIHostingController(
                rootView: TestingRootViewController()//.environmentObject(store).environmentObject(tree)
            )
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
