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
    static let realmURL = URL(string: "realm://68.179.162.156:9080/testData")
    
    
    // Current user
    static var user : SyncUser?
    
    // Guest User Credentials
    static let userCredentials = SyncCredentials.usernamePassword(username: "unitecubesatguest@gmail.com", password: "usiuniteguest")
    
    // The main thread instance of current synced realm
    static var activeRealm : Realm!
    
    static let serverTimeout = 5.0
}

// MARK: Connection


func loginToRealm(with userCredentials: SyncCredentials) {
    
    SyncUser.logIn(with: userCredentials, server: UNITERealm.realmObjectServerURL!, timeout: UNITERealm.serverTimeout, onCompletion: { user, error in
        if let user = user {
            
            DispatchQueue.main.async {

                UNITERealm.user = user
                
                var config = Realm.Configuration.defaultConfiguration
                config.syncConfiguration = SyncConfiguration(user: user, realmURL: UNITERealm.realmURL!)
                Realm.Configuration.defaultConfiguration = config
                
                UNITERealm.activeRealm = try! Realm()
//                if !user.isAdmin {
//
//                    var config = Realm.Configuration.defaultConfiguration
//                    config.syncConfiguration = SyncConfiguration(user: user, realmURL: UNITERealm.realmURL!)
//                    Realm.Configuration.defaultConfiguration = config
//
//                    UNITERealm.activeRealm = try! Realm(configuration: config)
//
//
//                } else {
//
//                    let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user, realmURL: URL(string: "realm://68.179.162.156:9080/testData")!))
//                    UNITERealm.activeRealm = try! Realm(configuration: config)
//
//                }
            }
            
            
        }
        
        if let error = error {
            
            print(error.localizedDescription)
            
        }
    })
    
    if UNITERealm.activeRealm == nil { UNITERealm.activeRealm = try! Realm() }
}


