//
//  ChecklistItem.swift
//  ChecklistTutorial2
//
//  Created by Paweł Liczmański on 18.02.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import Foundation
class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    
//MARK: User Notification variables
    
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int

    func toggleChecked() {
        checked = !checked
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        aCoder.encode(dueDate, forKey: "DueDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemaind")
        aCoder.encode(itemID, forKey: "ItemID")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemaind")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        super.init()
    }
    
    override init() {
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
}
