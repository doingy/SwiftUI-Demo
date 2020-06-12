//
//  SettingsRootView.swift
//  PokeMaster
//
//  Created by 杨冬青 on 2020/6/12.
//  Copyright © 2020 杨冬青. All rights reserved.
//

import SwiftUI

struct SettingsRootView: View {
    var body: some View {
        NavigationView {
            SettingView().navigationBarTitle("设置")
        }
    }
}

struct SettingsRootView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRootView()
    }
}
