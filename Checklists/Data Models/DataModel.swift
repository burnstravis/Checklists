//
//  DataModel.swift
//  Checklists
//
//  Created by Travis Burns on 1/31/24.
//

import Foundation

class DataModel {
    
    
    class func nextChecklistItemID() -> Int {
      let userDefaults = UserDefaults.standard
      let itemID = userDefaults.integer(forKey: "ChecklistItemID")
      userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
      return itemID
    }
    

    var lists = [Checklist]()
    
    //
    var indexOfSelectedChecklist: Int {
      get {
        return UserDefaults.standard.integer(
          forKey: "ChecklistIndex")
    } set {
        UserDefaults.standard.set(
          newValue,
          forKey: "ChecklistIndex")
    } }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    //creates file path
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        return paths[0]
    }
    
    //adds new file to file path
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    
    //saves checklists
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding list array: \(error.localizedDescription)")
        }
    }
    
    //loads previous checklists into new build
    func loadChecklists() {
        //print("Documents folder is \(documentsDirectory())")
        //print("Data file path is \(dataFilePath())")
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([Checklist].self,from: data)
                //sort checklist on load
                sortChecklists()
            } catch {
                print("Error decoding list array: \(error.localizedDescription)")
                
            }
        }
    }
    
    //set default value for checkListIndex key
    func registerDefaults() {
      let dictionary = [
        "ChecklistIndex": -1,
        "FirstTime": true
      ] as [String: Any]
      UserDefaults.standard.register(defaults: dictionary)
    }
    
    //when first time opening app created a default list for user
    func handleFirstTime() {
      let userDefaults = UserDefaults.standard
      let firstTime = userDefaults.bool(forKey: "FirstTime")
      if firstTime {
        let checklist = Checklist(name: "List")
        lists.append(checklist)
        indexOfSelectedChecklist = 0
        userDefaults.set(false, forKey: "FirstTime")
      }
    }
    
    //sorts list by name ascending order
    func sortChecklists() {
        lists.sort {
            list1, list2 in
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        }
    }
    
}
