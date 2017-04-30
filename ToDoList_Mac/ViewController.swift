//
//  ViewController.swift
//  ToDoList_Mac
//
//  Created by B0nty on 29/04/2017.
//  Copyright © 2017 B0nty. All rights reserved.
//

import Cocoa


class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var importantCheckBox: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var deleteButton: NSButton!
    
    var toDoItems: [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getToDoItems()  // Get data from CoreData when program loads if there are any save data
    }
    
    func getToDoItems() {
        // Get ToDoItems items from CoreData
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            do{
                //Set them to the Class property
                toDoItems =  try context.fetch(ToDoItem.fetchRequest())
            } catch {}
            
        }
        //Update the table view
        
        tableView.reloadData()
        
    }
    
    @IBAction func addClicked(_ sender: Any) {
        
        if textField.stringValue != "" {
            if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext {
                
                let toDoItem = ToDoItem(context: context)
                
                toDoItem.name = textField.stringValue
                
                if importantCheckBox.state == 0 {
                    // Not important
                    toDoItem.important = false
                } else {
                    // Important
                    toDoItem.important = true
                }
                
                // Save context to CoreData
                (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
                
                //Clear text field and uncheck important
                textField.stringValue = ""
                importantCheckBox.state = 0
                
                getToDoItems()
            }
        }
        
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        
        let toItem = toDoItems[tableView.selectedRow]
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            context.delete(toItem)
            (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
            getToDoItems()
            
            deleteButton.isHidden = true
        }
    }
    
    // MARK: - TableView stuff
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let toDoItem = toDoItems[row]
        
        if tableColumn?.identifier == "importantColumn" {
            
            if let cell = tableView.make(withIdentifier: "importantCell", owner: self) as? NSTableCellView {
                
                if toDoItem.important {
                    cell.textField?.stringValue = "❗️"
                } else {
                    cell.textField?.stringValue = ""
                }
                return cell
            }
        } else {
            // ToDo Name
            if let cell = tableView.make(withIdentifier: "todoItems", owner: self) as? NSTableCellView {
                
                cell.textField?.stringValue = toDoItem.name!
                
                return cell
            }
        }
        return nil
    }
    
    //Show delete button when cell is selected
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        deleteButton.isHidden = false
    }
}
