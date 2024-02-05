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

    


   class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
       
       
       
       //outlet textfield
       @IBOutlet var textField: UITextField!
       
       //outlet doneButton
       @IBOutlet var doneBarButton: UIBarButtonItem!
       
       //outlet iconimage
       @IBOutlet weak var iconImage: UIImageView!
       
       //chosen icon name
       var iconName = "Folder"
       
       weak var delegate: ListDetailViewControllerDelegate?
       var checklistToEdit: Checklist?
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           //update title, text and done button, icon name, icon image
           if let checklist = checklistToEdit {
               title = "Edit Checklist"
               textField.text = checklist.name
               doneBarButton.isEnabled = true
               iconName = checklist.iconName
           }
           iconImage.image = UIImage(named: iconName)
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
               checklist.iconName = iconName
               delegate?.listDetailViewController(self,didFinishEditing: checklist)
           } else {
               let checklist = Checklist(name: textField.text!)
               checklist.iconName = iconName
               delegate?.listDetailViewController(self,didFinishAdding: checklist)
           }
       }
       
       //user cannot edit textfield of cell or icon
       override func tableView(
         _ tableView: UITableView,
         willSelectRowAt indexPath: IndexPath) -> IndexPath? {
         return indexPath.section == 1 ? indexPath : nil
       }
       
       
       //replace textfield text with newText
       func textField(
         _ textField: UITextField,
         shouldChangeCharactersIn range: NSRange,
         replacementString string: String
       ) -> Bool {
           let oldText = textField.text!
           let stringRange = Range(range, in: oldText)!
           let newText = oldText.replacingCharacters(in: stringRange, with: string)
           doneBarButton.isEnabled = !newText.isEmpty
           return true
       }
       
       
       
       //disables done button after item text is cleared
       func textFieldShouldClear(_ textField: UITextField) -> Bool {
           doneBarButton.isEnabled = false
           return true
           
       }
       
       //puts name of chosen icon into iconName variable, updates image
       func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
         
         self.iconName = iconName
         iconImage.image = UIImage(named: iconName)
         navigationController?.popViewController(animated: true)
     }
       
       //prepare segue with identifier
       override func prepare(for segue: UIStoryboardSegue, sender: Any?)
       {
           if segue.identifier == "PickIcon" {
           let controller = segue.destination as!IconPickerViewController
           controller.delegate = self
         }
       }
       
   }
