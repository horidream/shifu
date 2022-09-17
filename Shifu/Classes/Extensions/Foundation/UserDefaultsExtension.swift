//
//  UserDefaultsExtension.swift
//  Shifu
//
//  Created by Baoli Zhai on 2020/2/8.
//

import Foundation

public extension UserDefaults {
    func clearAll(){
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    
    func set<T: Codable>(object: T, forKey: String) {
        if let jsonData = try? JSONEncoder().encode(object)
        {
            set(jsonData, forKey: forKey)
        }
    }


    func get<T: Codable>(_ objectType: T.Type, forKey: String) -> T? {
        guard let result = value(forKey: forKey) as? Data else {
            return nil
        }
        return try? JSONDecoder().decode(objectType, from: result)
    }
}
