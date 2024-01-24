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
    
    //requires name when creating object
    init(name: String) {
    
        //sets name to name given
        self.name = name
        super.init()
    }
}
