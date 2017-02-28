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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionName: String?
        
        if checklist.items.count == 0 && checklist.doneItems.count == 0 {
            sectionName = nil
        } else {
            if section == 0 {
               sectionName = "Tasks to do:"
            } else if section == 1 {
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
            label.textColor = UIColor.lightGray
        } else {
            label.text = item.text
            label.textColor = UIColor.black
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

