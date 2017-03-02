//
//  ViewController.swift
//  ChecklistTutorial2
//
//  Created by Paweł Liczmański on 13.02.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var checklist: Checklist!
    
    
    
    
//MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(red: 202/255, green: 211/255, blue: 226/255, alpha: 1)
        //self.tableView.sectionHeaderHeight = 10
        title = checklist.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checklist.sortChecklistItems()
        tableView.reloadData()
    }
    
//MARK: Outlest and Actions
    

    
        
//MARK: Delegate Methods
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        checklist.sortChecklistItems()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
        
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if !item.checked {
            if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
                }
            }
        } else {
//            let newRowIndex = checklist.items.count
//            checklist.items.append(item)
//            let indexPath = IndexPath(row: newRowIndex, section: 0)
//            let indexPaths = [indexPath]
//            tableView.insertRows(at: indexPaths, with: .automatic)
            if let index = checklist.doneItems.index(of: item)
            {
                let indexPath = IndexPath(row: index, section: 1)
                checklist.doneItems.remove(at: indexPath.row)
                checklist.items.append(item)
            }
        }
            
        checklist.sortChecklistItems()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
        
    }
    
//MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                var allItems = [checklist.items, checklist.doneItems]
                let item = allItems[indexPath.section][indexPath.row]
                if item.checked {
                    item.toggleChecked()
                    checklist.doneItems.remove(at: indexPath.row)
                    checklist.items.append(item)
//                    checklist.sortChecklistItems()
//                    tableView.reloadData()
                }
                controller.itemToEdit = item
            }
        }
    }
    
//MARK: Table View Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let allItems = [checklist.items, checklist.doneItems]
        return allItems.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 16, y: 8, width: 237, height: 12)
        myLabel.font = UIFont.italicSystemFont(ofSize: 10)
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        myLabel.textColor = UIColor(red: 0/255, green: 0/255, blue: 70/255, alpha: 1)
        myLabel.textAlignment = .center
        
        let headerView = UIView()
        headerView.addSubview(myLabel)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionName: String?
        
        if checklist.items.count == 0 && checklist.doneItems.count == 0 {
            if section == 0 {
                sectionName = "No tasks here, tap + button on top right corrner"
            }
        } else if checklist.items.count != 0 && checklist.doneItems.count == 0 {
            if section == 0 {
               sectionName = "Tasks to do:"
            }
        } else if checklist.items.count == 0 && checklist.doneItems.count != 0 {
            if section == 1 {
                sectionName = "Finished tasks:"
            }
        } else if checklist.items.count != 0 && checklist.doneItems.count != 0 {
            if section == 0 {
                sectionName = "Tasks to do:"
            }
            if section == 1 {
                sectionName = "Finished tasks:"
            }
        }        

        return sectionName
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows = 0
        if section == 0 {
            numberOfRows = checklist.items.count
        } else if section == 1 {
            numberOfRows = checklist.doneItems.count
        }
        
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let allItems = [checklist.items, checklist.doneItems]
        
        let item = allItems[indexPath.section][indexPath.row]
        
        configureText(for: cell, with: item)
        
        cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.25)
        cell.textLabel?.textColor = UIColor(red: 0/255, green: 40/255, blue: 70/255, alpha: 1)
        cell.detailTextLabel?.textColor = UIColor(red: 128/255, green: 170/255, blue: 220/255, alpha: 1)
        //selection bgcolor
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 190/255, green: 215/255, blue: 255/255, alpha: 1)
        cell.selectedBackgroundView = bgColorView
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var allItems = [checklist.items, checklist.doneItems]
        let item = allItems[indexPath.section][indexPath.row]
        if !item.checked {
            item.toggleChecked()
            checklist.items.remove(at: indexPath.row)
            checklist.doneItems.append(item)
            checklist.sortChecklistItems()
            tableView.reloadData()
            //print("number of doneItems in array:\(checklist.doneItems.count)")
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            item.toggleChecked()
            checklist.doneItems.remove(at: indexPath.row)
            checklist.items.append(item)
            checklist.sortChecklistItems()
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        var allItems = [checklist.items, checklist.doneItems]
        let item = allItems[indexPath.section][indexPath.row]
        if !item.checked  {
            checklist.items.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        } else {
            checklist.doneItems.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
        
    }
    
//MARK: Random methods
    
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: item.text)
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
        
        if item.checked {
            label.attributedText = attributeString
            label.textColor = UIColor(red: 128/255, green: 170/255, blue: 220/255, alpha: 1)
        } else {
            label.text = item.text
            label.textColor = UIColor(red: 0/255, green: 0/255, blue: 70/255, alpha: 1)
        }
    }
    
//MARK: Save and Load
    
    func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(checklist.items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadChecklistItems() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            checklist.items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
            unarchiver.finishDecoding()
        }
    }
    


    

}

