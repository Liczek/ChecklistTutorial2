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
        self.tableView.backgroundColor = UIColor(red: 202/255, green: 211/255, blue: 226/255, alpha: 1)
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
        cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.25)
        cell.textLabel?.textColor = UIColor(red: 0/255, green: 40/255, blue: 70/255, alpha: 1)
        cell.detailTextLabel?.textColor = UIColor(red: 128/255, green: 170/255, blue: 220/255, alpha: 1)
        //selection bgcolor
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 190/255, green: 215/255, blue: 255/255, alpha: 1)
        cell.selectedBackgroundView = bgColorView
        
        return cell
    }
    
//MARK: TABLE VIEW METHODS
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//MARK: ??? - po co unwrapować delegate?
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPick: iconName)
        }
    }
}
