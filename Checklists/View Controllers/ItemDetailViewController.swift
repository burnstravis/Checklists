//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Travis Burns on 1/25/24.
//

import UIKit

protocol ItemDetailViewControllerDelegate: AnyObject {
    
    //canceled
  func itemDetailViewControllerDidCancel(
    _ controller: ItemDetailViewController)
    
        //added
  func itemDetailViewController(
    _ controller: ItemDetailViewController,
    didFinishAdding item: Checklistitem)
    
    //edited
  func itemDetailViewController(
    _ controller: ItemDetailViewController,
    didFinishEditing item: Checklistitem)

}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    //outlet for done button
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    //outlet of item textfield
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //delegate
    weak var delegate: ItemDetailViewControllerDelegate?
    
    //var contains if item is checked
    var itemToEdit: Checklistitem?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        //update title, text and done button
        if let itemToEdit = itemToEdit {
            title = "Edit Item"
            
            textField.text = itemToEdit.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = itemToEdit.shouldRemind
            datePicker.date = itemToEdit.dueDate
        }
    }
    
    
    //cancel button
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)    }
    
    //done button
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.itemDetailViewController(
                self,
                didFinishEditing: item)
        }
        else {
            
            let item = Checklistitem()
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
      textField.resignFirstResponder()
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {_, _
                in
                //nothing
            }
        }
    }
    
    //disallows user to select the text in row, forces user to use edit button
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
    }
    
    //Brings keyboard on screen automatically
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      textField.becomeFirstResponder()
    }
    
    //
    //replace textfield text with new Text
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String
    ) -> Bool {
      let oldText = textField.text!
      let stringRange = Range(range, in: oldText)!
      let newText = oldText.replacingCharacters(
        in: stringRange,
        with: string)
        
        //done bar on or off 
      if newText.isEmpty {
        doneBarButton.isEnabled = false
      } else {
        doneBarButton.isEnabled = true
      }
        return true
    }
    
    
}
