//
//  ViewController.swift
//  Todoey
//
//  Created by sayali on 16/12/19.
//  Copyright © 2019 sayali. All rights reserved.
//

import UIKit

class TodoeyListController: UITableViewController{
   
     var todoArray = [String]()
    
    @IBOutlet var TodoTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       tableView.separatorColor = UIColor.red
        
      // tableView.allowsMultipleSelectionDuringEditing = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
       
    }

    //Mark : table view datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        cell.textLabel?.text = todoArray[indexPath.row]
       // cell.textLabel?.text = todomodel.itemName[]
        
        return cell
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
            }
            else{
                cell.accessoryType = .checkmark
            }
        }
        
        
    }
    
    @IBAction func addBtnClicked(_ sender: UIBarButtonItem) {
        var textfiled = UITextField()
        let alert = UIAlertController(title: "Add item", message: "Add new item in your todo list", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (newitemtext) in
            print("item \(textfiled.text ?? "")")
            if textfiled.text == "" as String?
            {
                let alert = UIAlertController(title: "Add item", message: "please write a item name", preferredStyle: .alert)
                
                let actio  = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(actio)
                
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                var todomodel = TodoItemModel()
                todomodel.itemName = textfiled.text!
                self.todoArray.append(todomodel.itemName)
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (text) in
            text.placeholder = "add new item"
            textfiled = text
        }
        
        var actio  = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actio)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
   
}

