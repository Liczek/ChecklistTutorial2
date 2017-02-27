//
//  ChecklistItem.swift
//  ChecklistTutorial2
//
//  Created by Paweł Liczmański on 18.02.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import Foundation
import UserNotifications

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

//MARK: USER NOTIFICATION CREATING - STEPS
// 1. when execute method
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
// 2. Create content text configuration od Center(something like Alerts)
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default()

// 3. Because our trigger will be UN Calendar Notification Trigger, we need to extract data Components from dueData
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .hour, .minute] , from: dueDate)
            
// 4. We need to implement extracted data - named components
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
// 5. Most important Request ( something like Action)
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
// 6.
            let center = UNUserNotificationCenter.current()
            center.add(request)
            print("Notification with ID: \(itemID) created")
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
        print("Notification with ID: \(itemID) deleted")
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
    
//MARK: REMOVING NOTIFICATION WHEN ITEM IS DELATED
    // its executed a moment befor someone delate item by (swipe to delete)
    deinit {
        removeNotification()
    }
}
