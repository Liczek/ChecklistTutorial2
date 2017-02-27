//
//  Checklist.swift
//  ChecklistTutorial2
//
//  Created by Paweł Liczmański on 19.02.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    var name = ""
    var items = [ChecklistItem]()
    var iconName: String
//MARK: ??? - po co jest ten convinience init?
    convenience init(listName: String) {
        self.init(listName: listName, iconName: "No Icon")
    }
    
    init(listName: String, iconName: String) {
        self.name = listName
        self.iconName = iconName
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder){
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: "iconName") as! String
        super.init()
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "iconName")
    }
    
    func countNotStrikeThroughtItems() -> Int {
        var count = 0
        
        for item in items where !item.checked{
            count += 1
        }
        return count
    }
    
//    func sortChecklistItems() {
//        items.sort(by: {item1, item2 in
//        return item1.checked && !item2.checked})
//        }
    
    func sortChecklisItemByCheckedAndAscending() {
        var checked = [ChecklistItem]()
        var unchecked = [ChecklistItem]()
        
//        for item in items where item.checked {
//            checked.append(item)
//        }
//        for item in items where !item.checked {
//            unchecked.append(item)
//        }
        
        for item in items {
        if item.checked {
            checked.append(item)
        } else {
            unchecked.append(item)
            }
        }
        
        checked.sort(by: {(checklistItem1, checklistItem2) in
            return checklistItem1.text.localizedStandardCompare(checklistItem2.text) == .orderedAscending})
        unchecked.sort(by: {(checklistItem1, checklistItem2) in
            return checklistItem1.text.localizedStandardCompare(checklistItem2.text) == .orderedAscending})
        
        self.items = unchecked + checked
        
        
    }
    

}
