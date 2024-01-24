//
//  Checklistitem.swift
//  Checklists
//
//  Created by Travis Burns on 1/25/24.
//

import Foundation

//CHECKLIST's Items OBJECT

class Checklistitem: NSObject, Codable {

    
    //Contains text for item
  var text = ""
    //contains bool for if checked
  var checked = false
}
