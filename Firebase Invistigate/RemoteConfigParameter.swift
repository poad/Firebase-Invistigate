//
//  RemoteConfigParameter.swift
//  Firebase Invistigate
//
//  Created by 齊藤健司 on 2022/06/08.
//

import FirebaseRemoteConfig
import FirebaseRemoteConfigSwift

struct RemoteConfigParameter {

    /// 初期値のディクショナリー
    static let defaultConfigValues: [String: NSObject] = {
        var defaultDictionary = [String: NSObject]()
        for parameter in ParameterType.allCases {
            defaultDictionary.updateValue(parameter.defaultValue, forKey: parameter.key)
        }
        return defaultDictionary
    }()

    private let remoteConfig: RemoteConfig

    init(with remoteConfig: RemoteConfig) {
        self.remoteConfig = remoteConfig
    }

    /// Remote Configのパラメータタイプ
    enum ParameterType: String, CaseIterable {
        case group

        var key: String {
            return self.rawValue
        }

        var defaultValue: NSObject {

            switch self {
            case .group:
                return "メンテナンス中" as NSObject
            }
        }
    }

    var group: String {
        do {
            return try decodedValue(.group)
        }
        catch {
            return ParameterType.group.defaultValue as! String
        }
    }

    // MARK: - Private func

    /// Remote Configで取得している値をデコードして返す
    /// - Parameter parameter: Remote Configパラメータタイプ
    /// - Returns: デコードされたRemote Configの値を返す
    private func decodedValue<T>(_ parameter: ParameterType) throws -> T {

        switch parameter {
        case .group:
            return try remoteConfig[parameter.key].decoded(asType: String.self) as! T
        }
    }
}

