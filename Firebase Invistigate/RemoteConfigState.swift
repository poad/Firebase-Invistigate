//
//  RemoteConfigState.swift
//  Firebase Invistigate
//
//  Created by 齊藤健司 on 2022/06/08.
//

import SwiftUI
import FirebaseRemoteConfig
import os.log


class RemoteConfigState: ObservableObject {

    private let logger = Logger()
    
    /// fetchAndActivateを実施中ならtrue
    @Published var isFetchAndActivating = false

    private let remoteConfig: RemoteConfig
    private let remoteConfigParameter: RemoteConfigParameter

    // Remote Configの最小フェッチ間隔
    private let minimumFetchInterval: TimeInterval = {
    #if DEBUG
        return 0
    #else
        // デフォルト値 12時間(推奨)
        return 43200
    #endif
    }()

    init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = minimumFetchInterval
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(RemoteConfigParameter.defaultConfigValues)
        remoteConfigParameter = RemoteConfigParameter(with: remoteConfig)

        fetchAndActive()
        logger.debug("Config: group is \(self.group)")
    }

    var group: String {
        return remoteConfigParameter.group
    }

    /// RemoteConfigの値をfetchしてactivateする
    private func fetchAndActive() {
        isFetchAndActivating = true

        Task {
            do {
                let _ = try await remoteConfig.fetchAndActivate()
                DispatchQueue.main.async {
                    self.isFetchAndActivating = false
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
