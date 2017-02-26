//
//  DataModel.swift
//  ChecklistTutorial2
//
//  Created by Paweł Liczmański on 20.02.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        } set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
//MARK: Load and Save
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklist.plist")
    }
    
    func saveChecklists(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadChecklists(){
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            unarchiver.finishDecoding()
            
            sortChecklists()
        }
    }
    
//MARK: USER DEFAULTS
    
    // Set vaues for UserDefaults
    
    func registerDefaults() {
        let dictionary: [String: Any] = ["ChecklistIndex": -1, "FirstTime": true, "ChecklistItemID": 0 ]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    // Creating new list and switch to List of items
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
    // reading boolian value from "FirstTime"
        let firstTime = userDefaults.bool(forKey: "FirstTime")
    //
        if firstTime {
    // creating List
            let checklist = Checklist(listName: "List")
            lists.append(checklist)
    // switch to created random Checklist - IndexPath.row == 0 (first row)
            indexOfSelectedChecklist = 0
    // change "FirstTime" boolian to false - every next launching will not be the first one
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
//MARK: ID CREATOR FOR USER NOTIFICATION
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
    
//MARK: SORT CHECKLISTS
    
    func sortChecklists() {
        lists.sort(by: {checklist1, checklist2 in
        return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending})
    }
    

    
    
}
