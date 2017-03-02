//
//  ListDetailViewController.swift
//  ChecklistTutorial2
//
//  Created by Paweł Liczmański on 19.02.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import Foundation
import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {

//MARK: OUTLETS
    var checklistToEdit: Checklist?
    var iconName = "No Icon"
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconNameLabel: UILabel!
    
    
//MARK: DELEGATE
    weak var delegate: ListDetailViewControllerDelegate?
    
    
//MARK: VIEWS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(red: 202/255, green: 211/255, blue: 226/255, alpha: 1)
        
        if let checklist = checklistToEdit {
            title = "Edit checklist name"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
            iconName = checklist.iconName
            iconNameLabel.text = "Curent icon: \(iconName)"
            iconNameLabel.textColor = UIColor(red: 0, green: 0, blue: 70/255, alpha: 1)
            iconImageView.image = UIImage(named: iconName)
        } else {
            title = "Add new checklist"
            doneBarButton.isEnabled = false
            iconNameLabel.text = "Tap here to chose icon"
            iconNameLabel.textColor = UIColor(red: 0, green: 0, blue: 70/255, alpha: 1)
            iconImageView.image = UIImage(named: "No Icon")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        textField.placeholder = "Enter name of new checklist"
        textField.becomeFirstResponder()
        textField.autocapitalizationType = .sentences
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.clearButtonMode = .always
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8.0
        textField.layer.borderColor = UIColor(red: 0, green: 0, blue: 70/255, alpha: 1).cgColor
        textField.layer.borderWidth = 1.0
        textField.textColor = UIColor(red: 0, green: 0, blue: 70/255, alpha: 1)        
        
    }
    
//MARK: ACTIONS
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        } else {
            let checklist = Checklist(listName: "\(textField.text!)", iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
    
//MARK: TABLE VIEW METHODS
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
//MARK: SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
    
//MARK: DELEGATES METHODS
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButton.isEnabled = newText.length > 0
        return true
    }
    
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        iconNameLabel.text = "Curent icon: \(iconName)"
        iconImageView.image = UIImage(named: iconName)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    
    
}
