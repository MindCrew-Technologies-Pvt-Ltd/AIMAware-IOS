//
//  Dictionary.swift
//
//
//  Created by Suyog on 23/11/21.


import UIKit

// MARK: - Dictionary Supporting Extensions

extension Dictionary where Key == String {
    // MARK: To fetch string value from Dictionary
    
    func getStringValue(forkey key: String) -> String {
        if let value = self[key] as? String {
            return value
        } else if let value = self[key] as? Int {
            return "\(value)"
        } else if let value = self[key] as? Float {
            return "\(value)"
        } else if let value = self[key] as? Double {
            return "\(value)"
        } else if let value = self[key]{
            return "\(value)" == "<null>" ?"" :"\(value)"
        }
        return ""
    }
    
    // MARK: To fetch Array from Dictionary
    
    func getArrayValue(forkey key: String) -> [Any] {
        if let value = self[key] as? [Any] {
            return value
        }
        return []
    }
    
    func getArrayStringValue(forkey key: String) -> [String] {
        if let value = self[key] as? [String] {
            return value
        }
        return []
    }
    
    // MARK: To fetch int value from Dictionary
    
    func getIntValue(forkey key: String) -> Int {
        if let value = self[key] as? Int {
            return value
        }
        return 0
    }
    
    func getTimeIntervalValue(forkey key: String) -> TimeInterval {
        if let value = self[key] as? TimeInterval {
            return value
        }
        return 0
    }
    
    
    func getBoolValue(forkey key: String, defaultValue defVal: Bool = false) -> Bool {
        if let strVal: String = self[key] as? String {
            if strVal.lowercased() == "yes" || strVal.lowercased() == "true" {
                return true
            } else if strVal.lowercased() == "no" || strVal.lowercased() == "false" {
                return false
            } else if let intVal: Int = Int(strVal) {
                if intVal == 0 {
                    return false
                } else if intVal == 1 {
                    return true
                }
            }
        } else if let val = self[key] as? Bool {
            return val
        } else if let intVal: Int = self[key] as? Int {
            if intVal == 0 {
                return false
            } else if intVal == 1 {
                return true
            }
        }  else if let numVal: NSNumber = self[key] as? NSNumber {
            if Int(truncating: numVal) == 0 {
                return false
            } else if Int(truncating: numVal) == 1 {
                return true
            }
        }
        return defVal
    }
    
    // MARK: To fetch dictionary from dictionary
    
    func getDictionaryValue(forkey key: String) -> [String: Any] {
        if let value = self[key] as? [String: Any] {
            return value
        }
        return [:]
    }
}
