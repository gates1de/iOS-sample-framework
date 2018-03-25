//
//  RealmManager.swift
//  SampleFramework
//
//  Created by Yu Kadowaki on 2018/03/25.
//
//

import Foundation
import RealmSwift

/// Realm manager struct
internal struct RealmManager {

    // MARK: - Static properties
    static private var realm: Realm? {
        do {
            return try Realm()
        } catch let error as NSError {
            print("Cannot get realm instance!: \(error.description)")
        }

        return nil
    }


    // MARK: - Static functions

    /// Read realm object
    ///
    /// - Parameters:
    ///   - object    : Target object
    ///   - predicate : Filtering query
    /// - Returns: Realm results
    static func read<T: Object> (object: T.Type, predicate: NSPredicate?) -> Results<T>? {
        guard let realm = self.realm else {
            return nil
        }

        guard let predicate = predicate else {
            // If predicate is nil, return all objects
            return realm.objects(T.self)
        }

        return realm.objects(T.self).filter(predicate)
    }

    /// Write realm object
    ///
    /// - Parameter writeClosure: Processing for writing realm object to Realm DB
    static func write(writeClosure: (_ realm: Realm) -> Void) -> Bool {
        guard let realm = self.realm else {
            return false
        }

        do {
            try realm.write {
                writeClosure(realm)
            }
            return true
        } catch let error as NSError {
            print("Cannot write realm object!: \(error.description)")
            return false
        }
    }
}
