//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Travis Burns on 1/28/24.
//

import UIKit
protocol ListDetailViewControllerDelegate: AnyObject {
    
    
    func listDetailViewControllerDidCancel(
    _ controller: ListDetailViewController)
    
    func listDetailViewController(
       _ controller: ListDetailViewController,
       didFinishAdding checklist: Checklist
     )
    func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishEditing checklist: Checklist
     )
   }


   class ListDetailViewController: UITableViewController, UITextFieldDelegate {
       
       //outlet textfield
       @IBOutlet var textField: UITextField!
       
       //outlet doneButton
       @IBOutlet var doneBarButton: UIBarButtonItem!
       weak var delegate: ListDetailViewControllerDelegate?
       var checklistToEdit: Checklist?
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           //update title, text and done button
           if let checklist = checklistToEdit {
               title = "Edit Checklist"
               textField.text = checklist.name
               doneBarButton.isEnabled = true
           }
       }

       //Brings keyboard on screen automatically
       override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         textField.becomeFirstResponder()
       }
       
       
       //cancel button
       @IBAction func cancel() {
         delegate?.listDetailViewControllerDidCancel(self)
       }
       
       //done button
       @IBAction func done() {
           if let checklist = checklistToEdit {
               checklist.name = textField.text!
               delegate?.listDetailViewController(
                self,
                didFinishEditing: checklist)
           } else {
               let checklist = Checklist(name: textField.text!)
               delegate?.listDetailViewController(
                self,
                didFinishAdding: checklist)
           }
       }
       
       //user cannot edit textfield of cell
       override func tableView(
         _ tableView: UITableView,
         willSelectRowAt indexPath: IndexPath
       ) -> IndexPath? {
       return nil
       }
       
       
       //replace textfield text with newText
       func textField(
         _ textField: UITextField,
         shouldChangeCharactersIn range: NSRange,
         replacementString string: String
       ) -> Bool {
           let oldText = textField.text!
           let stringRange = Range(range, in: oldText)!
           let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
           doneBarButton.isEnabled = !newText.isEmpty
           return true
       }
       
       
       
       //disables done button after item text is cleared
       func textFieldShouldClear(_ textField: UITextField) -> Bool {
           doneBarButton.isEnabled = false
           return true
           
       }
       
   }
