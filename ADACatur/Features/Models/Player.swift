//
//  Player.swift
//  ADACatur
//
//  Created by Ivan on 10/06/23.
//

import Foundation
import AuthenticationServices
import CloudKit

struct Player: Hashable, Equatable {
    var recordId: CKRecord.ID?
    var name: String
    var email: String
    let appleUserId: String?
    var eloScore: Double
//    let record: CKRecord?

    init(recordId: CKRecord.ID? = nil, name: String, email: String, eloScore: Double = 600.0) {
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
        self.eloScore = 600
    }
    
    mutating func updateElo(eloChange: Double){
        self.eloScore = self.eloScore - eloChange
    }
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        if let lhsRecordId = lhs.recordId, let rhsRecordId = rhs.recordId {
            return lhsRecordId.recordName == rhsRecordId.recordName
        }
        return false
    }
}
