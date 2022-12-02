// 
//  WebAuthnError.swift
//  FRAuth
//
//  Copyright (c) 2021 ForgeRock. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//


import Foundation
import FRCore

///
/// WebAuthnError represents an error captured by FRAuth SDK for WebAuthn related operation
///

public struct WebAuthnError: FRError {
    public enum WebAuthnErrorCases: FRError {
        case badData
        case badOperation
        case invalidState
        case constraint
        case cancelled
        case timeout
        case notAllowed
        case unsupported
        case unknown
    }

    public let webAuthnErrorCase: WebAuthnErrorCases
    public let platformError: Error?
    public let message: String?
}

extension WebAuthnError {
    
    /// Converts WebAuthnError to matching type of AM's Error enum
    /// - Returns: String value of matching error type in AM
    func convertToAMErrorType() -> String {
        switch self.webAuthnErrorCase {
        case .badData:
            return "DataError"
        case .badOperation:
            return "UnknownError"
        case .invalidState:
            return "InvalidStateError"
        case .constraint:
            return "ConstraintError"
        case .cancelled:
            return "UnknownError"
        case .timeout:
            return "TimeoutError"
        case .notAllowed:
            return "NotAllowedError"
        case .unsupported:
            return "NotSupportedError"
        case .unknown:
            return "UnknownError"
        }
    }
    
    func extractErrorDescription() -> String? {
        if let nsError = self.platformError as? NSError {
            return (nsError.userInfo["NSDebugDescription"] as? String) ?? nsError.localizedDescription
        } else if let errorDescription = self.message {
            return errorDescription
        } else {
            return nil
        }
    }
}


public extension WebAuthnError {
    
    /// Unique error code for given error
    var code: Int {
        return self.parseErrorCode()
    }
    
    /// Parses WebAuthnError value into integer error code
    ///
    /// - Returns: Int value of unique error code
    func parseErrorCode() -> Int {
        switch self.webAuthnErrorCase {
        case .badData:
            return 1600001
        case .badOperation:
            return 1600002
        case .invalidState:
            return 1600003
        case .constraint:
            return 1600004
        case .cancelled:
            return 1600005
        case .timeout:
            return 1600006
        case .notAllowed:
            return 1600007
        case .unsupported:
            return 1600008
        case .unknown:
            return 1600099
        }
    }
    
    /// Converts WebAuthnError into String representation of error that can be used as WebAuthn outcome in WebAuthn HiddenValueCallback
    /// - Returns: String value of WebAuthn error outcome
    func convertToWebAuthnOutcome() -> String {
        switch self.webAuthnErrorCase {
        case .unsupported:
            return "unsupported"
        default:
            return "ERROR::" + self.convertToAMErrorType() + ":" + (self.extractErrorDescription() ?? "")
        }
    }
}


// MARK: - CustomNSError protocols
extension WebAuthnError: CustomNSError {
    
    /// An error domain for WebAuthnError
    public static var errorDomain: String { return "com.forgerock.ios.frauth.webauthn" }
    
    /// Error codes for each error enum
    public var errorCode: Int {
        return self.parseErrorCode()
    }
    
    /// Error UserInfo
    public var errorUserInfo: [String : Any] {
        switch self.webAuthnErrorCase {
        case .badData:
            return [NSLocalizedDescriptionKey: "Provided data is inadequate"]
        case .badOperation:
            return [NSLocalizedDescriptionKey: "The operation failed for operation-specific reason"]
        case .invalidState:
            return [NSLocalizedDescriptionKey: "The object is in an invalid state"]
        case .constraint:
            return [NSLocalizedDescriptionKey: "A mutation operation in a transaction failed because a constraint was not satisfied"]
        case .cancelled:
            return [NSLocalizedDescriptionKey: "The operation is cancelled"]
        case .timeout:
            return [NSLocalizedDescriptionKey: "The operation timed out"]
        case .notAllowed:
            return [NSLocalizedDescriptionKey: "The request is not allowed by the user agent or the platform in the current context"]
        case .unsupported:
            return [NSLocalizedDescriptionKey: "The operation is not supported"]
        case .unknown:
            return [NSLocalizedDescriptionKey: "The operation failed for an unknown reason"]
        }
    }
}

extension FRWAKError {
    func convert() -> WebAuthnError {
        switch self.error {
        case .badData:
            return WebAuthnError(webAuthnErrorCase: .badData, platformError: self.platformError, message: self.message)
        case .badOperation:
            return WebAuthnError(webAuthnErrorCase: .badOperation, platformError: self.platformError, message: self.message)
        case .invalidState:
            return WebAuthnError(webAuthnErrorCase: .invalidState, platformError: self.platformError, message: self.message)
        case .constraint:
            return WebAuthnError(webAuthnErrorCase: .constraint, platformError: self.platformError, message: self.message)
        case .cancelled:
            return WebAuthnError(webAuthnErrorCase: .cancelled, platformError: self.platformError, message: self.message)
        case .timeout:
            return WebAuthnError(webAuthnErrorCase: .timeout, platformError: self.platformError, message: self.message)
        case .notAllowed:
            return WebAuthnError(webAuthnErrorCase: .notAllowed, platformError: self.platformError, message: self.message)
        case .unsupported:
            return WebAuthnError(webAuthnErrorCase: .unsupported, platformError: self.platformError, message: self.message)
        case .unknown:
            return WebAuthnError(webAuthnErrorCase: .unknown, platformError: self.platformError, message: self.message)
        }
    }
}
