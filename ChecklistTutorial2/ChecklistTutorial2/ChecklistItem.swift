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

    func toggleChecked() {
        checked = !checked
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        super.init()
    }
    
    override init() {
        super.init()
    }
}
