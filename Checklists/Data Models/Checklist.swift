//
//  Checklist.swift
//  Checklists
//
//  Created by Travis Burns on 1/28/24.
//

import UIKit

//Checklist OBJECT

class Checklist: NSObject, Codable {
    
    //list name
    var name = ""
    
    //array of list items
    var items = [Checklistitem]()
    
    
    //name of icon for checklist
    var iconName = "No Icon"
    
    //requires name when creating object
    init(name: String) {
    
        //sets name to name given
        self.name = name
        self.iconName
        super.init()
    }
    
    //counts for unchecked items in list
    func countUncheckedItems() -> Int {
      var count = 0
        for item in items where !item.checked {
            count += 1
        }
      return count
    }
}
