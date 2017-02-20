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
    
    init(listName: String) {
        self.name = listName
        super.init()
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
    }
    
    required init?(coder aDecoder: NSCoder){
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        super.init()
    }

}
