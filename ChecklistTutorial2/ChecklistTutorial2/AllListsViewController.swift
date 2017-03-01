//
//  AllListsViewController.swift
//  ChecklistTutorial2
//
//  Created by Paweł Liczmański on 19.02.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    var dataModel: DataModel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.backgroundColor = UIColor(red: 194/255, green: 246/255, blue: 157/255, alpha: 1)
        //self.tableView.backgroundColor = UIColor(red: 170/255, green: 206/255, blue: 226/255, alpha: 1)
        self.tableView.backgroundColor = UIColor(red: 202/255, green: 211/255, blue: 226/255, alpha: 1)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
            print("odczytano row nr \(index)")
        }
    }

//MARK: TABLE VIEW METHODS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.25)
        cell.textLabel?.textColor = UIColor(red: 0/255, green: 0/255, blue: 70/255, alpha: 1)
        cell.detailTextLabel?.textColor = UIColor(red: 128/255, green: 170/255, blue: 220/255, alpha: 1)
        //selection bgcolor
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 190/255, green: 215/255, blue: 255/255, alpha: 1)
        cell.selectedBackgroundView = bgColorView

        cell.accessoryType = .detailDisclosureButton
            // if your not sure that setailTextLabel is not nil
        if let label = cell.detailTextLabel {
            
//            let uncheckedCount = checklist.countUncheckedItems()
            let itemsCount = checklist.items.count
            let doneItemsCount = checklist.doneItems.count
            
            if doneItemsCount != 0 && itemsCount == 0 {
                label.text = "All of \(doneItemsCount) tasks are done !!"
            } else if doneItemsCount != 0 && itemsCount != 0 {
                label.text = "\(itemsCount) of \(doneItemsCount) task remaining !!"
            } else if itemsCount == 0 && doneItemsCount == 0 {
                label.text = "You did not add any task yet"
            }
        }
        
        cell.imageView!.image = UIImage(named: checklist.iconName)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        print("zapisano na row numer \(indexPath.row)")
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        present(navigationController, animated: true, completion: nil)
    }
    
    
//MARK: RANDOM METHODS
    
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    
//MARK: SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }

//MARK: DELEGATES
    
    //ListDetail Delegates
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    // UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // Was the back button tapped?
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
            print("zapisano na -1")
        }
    }
    
}













