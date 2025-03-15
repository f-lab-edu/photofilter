//
//  cameraFilterApp.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/8/25.
//

import SwiftUI

@main
struct cameraFilterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            let loginHubViewModel = LoginHubViewModel(userLoginUseCase: UserLoginUseCase(repository: UserLoginRepository()))
            LoginHubView(viewModel: loginHubViewModel)
        }
    }
}
