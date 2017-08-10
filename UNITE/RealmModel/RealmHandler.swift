//
//  RealmHandler.swift
//  UNITE Server
//
//  Created by Zack Snyder on 3/11/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import RealmSwift


struct UNITERealm {
    
    // Location of Realm Object Server
    static let realmObjectServerURL = URL(string: "http://68.179.162.156:9080")
    
    // Sync login information
    static let realmURL = URL(string: "realm://68.179.162.156:9080/~/testData")
    
    
    // Current user
    static var user : SyncUser?
    
    // Guest User Credentials
    static let userCredentials = SyncCredentials.usernamePassword(username: "unitecubesatguest@gmail.com", password: "usiuniteguest")
    
    // The main thread instance of current synced realm
    static var activeRealm : Realm!
    
    static let serverTimeout = 10.0
}

// MARK: Connection


func logInToRealm(with userCredentials: SyncCredentials) {
    
    Realm.Configuration.defaultConfiguration = Realm.Configuration(
        
        fileURL: Realm.Configuration().fileURL?.deletingLastPathComponent().appendingPathComponent("testData.realm"),
        
        schemaVersion: 0,
        
        migrationBlock: { migration, oldSchemaVersion in
            
            if oldSchemaVersion < 0 {
                
            }
            
    })
    
    SyncUser.logIn(with: userCredentials, server: UNITERealm.realmObjectServerURL!, timeout: UNITERealm.serverTimeout, onCompletion: { user, error in
        if let user = user {
            
            DispatchQueue.main.async {

                UNITERealm.user = user
                
                if !user.isAdmin {
                
                    let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user, realmURL: UNITERealm.realmURL!))
                    UNITERealm.activeRealm = try! Realm(configuration: config)
                    
                    
                } else {
                    
                    let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user, realmURL: URL(string: "realm://68.179.162.156:9080/94aff1531162371d90eb4a04a9e5fcb8/testData")!))
                    UNITERealm.activeRealm = try! Realm(configuration: config)
                    
                }
                
                let realm = try! Realm()
                
                try! realm.write {
                    realm.deleteAll()
                    
                    for object in UNITERealm.activeRealm.objects(TemperatureSet.self) {
                        realm.create(TemperatureSet.self, value: object, update: false)
                    }
                }
            }
            
            
        }
        
        if let error = error {
            
            print(error.localizedDescription)
            
        }
    })
    
    if UNITERealm.activeRealm == nil { UNITERealm.activeRealm = try! Realm() }
}


