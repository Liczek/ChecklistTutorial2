//
//  ChecklistItem.swift
//  ChecklistTutorial2
//
//  Created by Paweł Liczmański on 18.02.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import Foundation
class ChecklistItem: NSObject {
    var text = ""
    var checked = false

    func toggleChecked() {
        checked = !checked
    }
}
