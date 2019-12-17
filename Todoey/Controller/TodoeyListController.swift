//
//  ViewController.swift
//  Todoey
//
//  Created by sayali on 16/12/19.
//  Copyright © 2019 sayali. All rights reserved.
//

import UIKit

class TodoeyListController: UITableViewController{
    
    var todoArray = [TodoItemModel]()
    var userdefault = UserDefaults.standard
    @IBOutlet var TodoTableView: UITableView!
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItem.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(dataFilePath)\n\n\n")
        tableView.separatorColor = UIColor.red
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        //create own .pilst to save data
        
        //find path where we have to create our plist
      
        
        loadData()
    }
    
    //Mark : table view datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        cell.textLabel?.text = todoArray[indexPath.row].itemName
        cell.accessoryType = todoArray[indexPath.row].Done == true ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            
            todoArray[indexPath.row].Done = !todoArray[indexPath.row].Done
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
            }
            else{
                cell.accessoryType = .checkmark
            }
            saveData()
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
                let itemmodel = TodoItemModel()
                itemmodel.itemName = textfiled.text!
                self.todoArray.append(itemmodel)
                self.tableView.reloadData()
                self.saveData()
            }
        }
        alert.addTextField { (text) in
            text.placeholder = "add new item"
            textfiled = text
        }
        let actio  = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actio)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //save data to our own plist we have to encode the data
    func saveData() {
        let encoder = PropertyListEncoder()
        do
        {
            let data = try encoder.encode(todoArray)
            try data.write(to: dataFilePath!)
        }catch
        {
            print(error)
        }
        print("\(String(describing: dataFilePath))\n\n\n")
    }
    
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!)
       {
        let decoder = PropertyListDecoder()
        do {
            todoArray = try decoder.decode([TodoItemModel].self, from: data)
        }catch
        {
            print(error)
        }
        }
    }
}

