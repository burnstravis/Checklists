//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Travis Burns on 1/27/24.
//

import UIKit



class AllListsViewController: UITableViewController,
ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    //identifier for cell name
    let cellIdentifier = "ChecklistCell"
    
    var dataModel: DataModel!
    
    
    //cancelled list
    func listDetailViewControllerDidCancel(
        _ controller: ListDetailViewController
    ){
        navigationController?.popViewController(animated: true)
    }
    
    //finished adding
    func listDetailViewController(
      _ controller: ListDetailViewController,
      didFinishAdding checklist: Checklist
    ){
    dataModel.lists.append(checklist)
    dataModel.sortChecklists()
    tableView.reloadData() 
    navigationController?.popViewController(animated: true)
    }
    
    //finished editing
    func listDetailViewController(
      _ controller: ListDetailViewController,
      didFinishEditing checklist: Checklist
    ){
    dataModel.sortChecklists()
    tableView.reloadData() 
    navigationController?.popViewController(animated: true)
    }
    
    
    func navigationController(
      _ navigationController: UINavigationController,
      willShow viewController: UIViewController,animated: Bool ){
          //button tapped
          if viewController === self {
              dataModel.indexOfSelectedChecklist = -1
          }
        }
    
    //launches app on last screen being viewed
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      navigationController?.delegate = self
        
      let index = dataModel.indexOfSelectedChecklist
      if index >= 0 && index < dataModel.lists.count {
        let checklist = dataModel.lists[index]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
      }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //large titles
        navigationController?.navigationBar.prefersLargeTitles = true
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    
    }
    
    
    //returns number of rows in lust
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return dataModel.lists.count }
    
    
    //returns cell with cell data to table
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        //get cell
        let cell: UITableViewCell!
        if let tmp = tableView.dequeueReusableCell(
          withIdentifier: cellIdentifier) {
          cell = tmp
        } else {
          cell = UITableViewCell(
            style: .subtitle,
            reuseIdentifier: cellIdentifier)
        }
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        //set count of items
        let count = checklist.countUncheckedItems()
        //if list is empty
        if checklist.items.count == 0 {
          cell.detailTextLabel!.text = "(No Items)"
            //if is finished or has remaining items
        } else {
          cell.detailTextLabel!.text = count == 0 ? "All Done" : "\(count) Remaining"
        }
        //add icon to list
        cell.imageView!.image = UIImage(named: checklist.iconName)
            
        return cell
    }
    
    
    //Row Selection
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ){
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    
    //prepares segue with checklist name for view
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ){
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as!
            ChecklistViewController
            controller.checklist = sender as? Checklist
        }
        else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as!
            ListDetailViewController
            controller.delegate = self
        }
    }
    
    //delete checklists
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ){
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    //sets up new viewcontroller using past info
    override func tableView(
        _ tableView: UITableView,
        accessoryButtonTappedForRowWith indexPath: IndexPath
    ){
        let controller = storyboard!.instantiateViewController(
            withIdentifier: "ListDetailViewController") as!
        ListDetailViewController
        controller.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        navigationController?.pushViewController(
            controller,
            animated: true)
    }
    
    //
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      tableView.reloadData()
    }
    
    
}
