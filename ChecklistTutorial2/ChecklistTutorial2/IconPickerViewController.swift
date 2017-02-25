//
//  IconPickerViewController.swift
//  ChecklistTutorial2
//
//  Created by Paweł Liczmański on 25.02.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import Foundation
import UIKit

protocol IconPickerViewControllerDelegate: class {
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
 
    
//MARK: OUTLETS
    let icons = ["No Icon", "Appointments", "Birthdays", "Chores", "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips"]

//MARK: VIEWS
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose Icon"
    }
    
//MARK: SET DELEGATE
    weak var delegate: IconPickerViewControllerDelegate?
    
//MARK: TABLE VIEW METHODS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "iconCell", for: indexPath)
        
        let iconName = icons[indexPath.row]
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named: iconName)
        
        return cell
    }
    
//MARK: TABLE VIEW METHODS
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let iconName = icons[indexPath.row]
        delegate?.iconPicker(self, didPick: iconName)
    }
}
