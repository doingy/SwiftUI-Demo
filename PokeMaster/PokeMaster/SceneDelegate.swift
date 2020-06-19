//
//  SceneDelegate.swift
//  PokeMaster
//
//  Created by 杨冬青 on 2020/6/11.
//  Copyright © 2020 杨冬青. All rights reserved.
//

import UIKit
import SwiftUI

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private func showMainTab(scene: UIScene, with store: Store) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: MainTab().environmentObject(store))
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    private func createStore(_ URLContexts: Set<UIOpenURLContext>) -> Store {
        let store = Store()
        
        guard let url = URLContexts.first?.url, let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return store
        }
        
        switch (components.scheme, components.host) {
        case ("pokemaster", "showPanel"):
            guard let idQuery = (components.queryItems?.first { $0.name == "id" }), let idString = idQuery.value, let id = Int(idString), id >= 1 && id <= 30 else {
                break
            }
            
            store.appState.pokemonList.selectionsState = .init(expandingIndex: id, panelIndex: id, panelPresented: true)
        default:
            break
        }
        
        return store
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
//        let contentView = MainTab().environmentObject(Store())
        let contentView = CustomShape()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
        
//        let store = createStore(connectionOptions.urlContexts)
//        showMainTab(scene: scene, with: store)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let store = createStore(URLContexts)
        showMainTab(scene: scene, with: store)
    }

}

struct SceneDelegate_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
