//
//  Player.swift
//  ADACatur
//
//  Created by Ivan on 10/06/23.
//

import Foundation
import AuthenticationServices
import CloudKit

struct Player {
    var recordId: CKRecord.ID?
    let name: String
    let email: String
    let appleUserId: String?
    let eloScore: Double

    init(recordId: CKRecord.ID? = nil, name: String, email: String, eloScore: Double = 0.0) {
        self.recordId = recordId
        self.name = name
        self.email = email
        self.eloScore = eloScore
        self.appleUserId = nil
    }
    
    /** Create player using AppleID credentials */
    init?(recordId: CKRecord.ID? = nil, credentials: ASAuthorizationAppleIDCredential) {
        guard
            let firstName = credentials.fullName?.givenName,
            let lastName = credentials.fullName?.familyName,
            let email = credentials.email
        else { return nil }
            
        self.recordId = recordId
        self.name = "\(firstName) \(lastName)"
        self.email = email
        self.appleUserId = credentials.user
        self.eloScore = 0.0
    }
}
