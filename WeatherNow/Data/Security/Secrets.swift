//  Secrets.swift
//  WeatherNow
//  Created by Vino_Swify on 26/08/25.
import Foundation

enum Secrets {
    // Save / clear
    static func saveWorkerClientToken(_ token: String) throws {
        try KeychainService.save(
            value: Data(token.utf8),
            service: SecretsConstants.service,
            account: SecretsConstants.account
        )
    }

    static func clearWorkerClientToken() throws {
        try KeychainService.delete(
            service: SecretsConstants.service,
            account: SecretsConstants.account
        )
    }

    /// Get the token for requests.
    /// 1) Try Keychain (runtime-overridable)
    /// 2) Fallback to Info.plist (from Debug.xcconfig)
    static func workerClientToken() -> String? {
        // 1) Keychain
        if let data = KeychainService.load(service: SecretsConstants.service,
                                           account: SecretsConstants.account),
           let s = String(data: data, encoding: .utf8)?
                        .trimmingCharacters(in: .whitespacesAndNewlines),
           !s.isEmpty {
            return s
        }
        // 2) Info.plist
        if let s = Bundle.main.object(forInfoDictionaryKey: SecretsConstants.gatewayKey) as? String,
           !s.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return s.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return nil
    }

    static func gatewayKey() -> String? {
        (Bundle.main.object(forInfoDictionaryKey: SecretsConstants.gatewayKey) as? String)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

