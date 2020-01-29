//
//  CategoryViewController.swift
//  Todoey
//
//  Created by sayali on 19/12/19.
//  Copyright © 2019 sayali. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    //var data : Results<Category>!
    var mainItemArr : Results<Category>?
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        upload()
        
    }
    
    //table view delegate and data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainItemArr?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = mainItemArr?[indexPath.row].name ?? "no category added"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath as IndexPath) != nil {
            
            performSegue(withIdentifier: "goToToDoList", sender: self)
        }
    }
    
    
    override func update(at indexpath : IndexPath)
    {
        do{
            try self.realm.write {
                self.realm.delete(self.mainItemArr![indexpath.row])
            }
        }catch
        {
            print(error)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let todolistVC = segue.destination as! TodoeyListController
        var indexpath = tableView.indexPathForSelectedRow
        todolistVC.selectedCategory = mainItemArr?[(indexpath?.row)!]
    }
    
    //delete row
    
    // this method handles row deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
    }
    
    
    
    @IBAction func addbtnPress(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "New Item", message: "Add new item in your list", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let add = UIAlertAction(title: "Add", style: .default) { (text) in
            let newItem = Category()
            newItem.name = textfield.text!
            //  self.mainItemArr(newItem)
            self.tableView.reloadData()
            self.save(category: newItem)
        }
        alert.addTextField { (textval) in
            textval.placeholder = "add new item name"
            textfield = textval
        }
        alert.addAction(add)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        tableView.reloadData()
        
        
    }
    
    //save data in database using core data
    func save(category : Category)
    {
        do{
            try realm.write()
            {
                realm.add(category)
            }
        }catch
        {
            print("error in save data \(error)")
        }
        
        tableView.reloadData()
    }
    
    // fetch/read data from database by using coredata
    
    func upload()  {
        mainItemArr = realm.objects(Category.self)
    }
}




