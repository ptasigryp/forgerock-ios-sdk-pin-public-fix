// 
//  FROptions.swift
//  FRAuth
//
//  Copyright (c) 2022 ForgeRock. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

import Foundation

@objc
public class FROptions: NSObject, Codable {
    public var url: String
    public var realm: String
    public var enableCookie: Bool
    public var cookieName: String
    public var timeout: String
    
    public var authenticateEndpoint: String?
    public var authorizeEndpoint: String?
    public var tokenEndpoint: String?
    public var revokeEndpoint: String?
    public var userinfoEndpoint: String?
    public var sessionEndpoint: String?
    
    public var authServiceName: String
    public var registrationServiceName: String
    
    public var oauthThreshold: String?
    public var oauthClientId: String?
    public var oauthRedirectUri: String?
    public var oauthScope: String?
    public var keychainAccessGroup: String?
    public var sslPinningPublicKeyHashes: [String]?
    
    enum CodingKeys: String, CodingKey {
        case url = "forgerock_url"
        case realm = "forgerock_realm"
        case enableCookie = "forgerock_enable_cookie"
        case cookieName = "forgerock_cookie_name"
        case timeout = "forgerock_timeout"
        case authenticateEndpoint = "forgerock_authenticate_endpoint"
        case authorizeEndpoint = "forgerock_authorize_endpoint"
        case tokenEndpoint = "forgerock_token_endpoint"
        case revokeEndpoint = "forgerock_revoke_endpoint"
        case userinfoEndpoint = "forgerock_userinfo_endpoint"
        case sessionEndpoint = "forgerock_session_endpoint"
        case authServiceName = "forgerock_auth_service_name"
        case registrationServiceName = "forgerock_registration_service_name"
        case oauthThreshold = "forgerock_oauth_threshold"
        case oauthClientId = "forgerock_oauth_client_id"
        case oauthRedirectUri = "forgerock_oauth_redirect_uri"
        case oauthScope = "forgerock_oauth_scope"
        case keychainAccessGroup = "forgerock_keychain_access_group"
        case sslPinningPublicKeyHashes = "forgerock_ssl_pinning_public_key_hashes"
    }
    
    public init(url: String,
                realm: String,
                enableCookie: Bool = true,
                cookieName: String? = nil,
                timeout: String = "60",
                authenticateEndpoint: String? = nil,
                authorizeEndpoint: String? = nil,
                tokenEndpoint: String? = nil,
                revokeEndpoint: String? = nil,
                userinfoEndpoint: String? = nil,
                sessionEndpoint: String? = nil,
                authServiceName: String = "Login",
                registrationServiceName: String = "Registration",
                oauthThreshold: String? = nil,
                oauthClientId: String? = nil,
                oauthRedirectUri: String? = nil,
                oauthScope: String? = nil,
                keychainAccessGroup: String? = nil,
                sslPinningPublicKeyHashes: [String]? = nil) {
        self.url = url
        self.realm = realm
        self.enableCookie = enableCookie
        self.cookieName = cookieName ?? "iPlanetDirectoryPro"
        self.timeout = timeout
        self.authenticateEndpoint = authenticateEndpoint
        self.authorizeEndpoint = authorizeEndpoint
        self.tokenEndpoint = tokenEndpoint
        self.revokeEndpoint = revokeEndpoint
        self.userinfoEndpoint = userinfoEndpoint
        self.sessionEndpoint = sessionEndpoint
        self.authServiceName = authServiceName
        self.registrationServiceName = registrationServiceName
        self.oauthClientId = oauthClientId
        self.oauthThreshold = oauthThreshold
        self.oauthRedirectUri = oauthRedirectUri
        self.oauthScope = oauthScope
        self.keychainAccessGroup = keychainAccessGroup
        self.sslPinningPublicKeyHashes = sslPinningPublicKeyHashes
        
        super.init()
    }
    
    public init(config: [String: Any]) {
        self.url = config[FROptions.CodingKeys.url.rawValue] as? String ?? ""
        self.realm = config[FROptions.CodingKeys.realm.rawValue] as? String ?? ""
        self.enableCookie = config[FROptions.CodingKeys.enableCookie.rawValue] as? Bool ?? true
        self.cookieName = config[FROptions.CodingKeys.cookieName.rawValue] as? String ?? "iPlanetDirectoryPro"
        self.timeout = config[FROptions.CodingKeys.timeout.rawValue] as? String ?? "60"
        self.authenticateEndpoint = config[FROptions.CodingKeys.authenticateEndpoint.rawValue] as? String
        self.authorizeEndpoint = config[FROptions.CodingKeys.authorizeEndpoint.rawValue] as? String
        self.tokenEndpoint = config[FROptions.CodingKeys.tokenEndpoint.rawValue] as? String
        self.revokeEndpoint = config[FROptions.CodingKeys.revokeEndpoint.rawValue] as? String
        self.userinfoEndpoint = config[FROptions.CodingKeys.userinfoEndpoint.rawValue] as? String
        self.sessionEndpoint = config[FROptions.CodingKeys.sessionEndpoint.rawValue] as? String
        self.authServiceName = config[FROptions.CodingKeys.authServiceName.rawValue] as? String ?? "Login"
        self.registrationServiceName = config[FROptions.CodingKeys.registrationServiceName.rawValue] as? String ?? "Registration"
        self.oauthClientId = config[FROptions.CodingKeys.oauthClientId.rawValue] as? String
        self.oauthThreshold = config[FROptions.CodingKeys.oauthThreshold.rawValue] as? String
        self.oauthRedirectUri = config[FROptions.CodingKeys.oauthRedirectUri.rawValue] as? String
        self.oauthScope = config[FROptions.CodingKeys.oauthScope.rawValue] as? String
        self.keychainAccessGroup = config[FROptions.CodingKeys.keychainAccessGroup.rawValue] as? String
        self.sslPinningPublicKeyHashes = config[FROptions.CodingKeys.sslPinningPublicKeyHashes.rawValue] as? [String]
        
        super.init()
    }
    
    public func optionsDictionary() -> [String: Any]? {
        return try? self.asDictionary()
    }
    
    static func == (lhs: FROptions, rhs: FROptions) -> Bool {
        return (lhs.url == rhs.url &&
        lhs.realm == rhs.realm &&
        lhs.cookieName == rhs.cookieName &&
        lhs.oauthClientId == rhs.oauthClientId)
    }
}

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
