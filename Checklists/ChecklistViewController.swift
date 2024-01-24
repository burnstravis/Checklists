//
//  ViewController.swift
//  Checklists
//
//  Created by Travis Burns on 1/24/24.
//

import UIKit

class ChecklistViewController: UITableViewController,ItemDetailViewControllerDelegate {
    
    //cancel checklistitem
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    //add new checklist item
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: Checklistitem) {
        
        //new row index is = to the amount of rows in checklist
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated:true)
    }
    
    //edits checklist item
    func itemDetailViewController(
      _ controller: ItemDetailViewController,
      didFinishEditing item: Checklistitem
    ){
        if let index = checklist.items.firstIndex(of: item) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) {
          configureText(for: cell, with: item)
        }
    }
        navigationController?.popViewController(animated: true)

    }
        
    //checklist
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        title = checklist.name
        
    }
    
    //number of items(rows) in checklist
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return checklist.items.count
    }
    
    
    //returns cell with cell data to table
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Checklistitem",
            for: indexPath)
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    //Row Selection (toggle checkmark)
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ){
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //toggles checkmark label
    func configureCheckmark(
        for cell: UITableViewCell,
        with item: Checklistitem
    ){
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    //Set label to item text
    func configureText(
        for cell: UITableViewCell,
        with item: Checklistitem
    ){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    
    
    //swipe to delete section
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ){
        
        checklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    //prepares other view controller
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
        
        //changes titles
    ){if segue.identifier == "AddItem" {
        // 2
        let controller = segue.destination as! ItemDetailViewController
        // 3
        controller.delegate = self
    }
        else if segue.identifier == "EditItem" {
        let controller = segue.destination as! ItemDetailViewController
        controller.delegate = self
            
            //set delegate to self
            if let indexPath = tableView.indexPath(
            for: sender as! UITableViewCell) {
            controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
  
    
}
