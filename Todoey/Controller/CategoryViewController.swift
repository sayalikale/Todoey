//
//  CategoryViewController.swift
//  Todoey
//
//  Created by sayali on 19/12/19.
//  Copyright © 2019 sayali. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    var mainItemArr = [Category]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        upload()
        
    }
    
    //table view delegate and data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainItemArr.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "maincell", for: indexPath)
        cell.textLabel?.text = mainItemArr[indexPath.row].name
        savemainData()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath as IndexPath) != nil {
            
            performSegue(withIdentifier: "goToToDoList", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let todolistVC = segue.destination as! TodoeyListController
        var indexpath = tableView.indexPathForSelectedRow
        todolistVC.selectedCategory = mainItemArr[(indexpath?.row)!]
    }
    
    //delete row
    
    // this method handles row deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // remove the item from the data model
        
            context.delete(mainItemArr[indexPath.row])
            mainItemArr.remove(at: indexPath.row)
            //   saveData()
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Not used in our example, but if you were adding a new row, this is where you would do it.
        }
    }
    
    
    
    @IBAction func addbtnPress(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "New Item", message: "Add new item in your list", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let add = UIAlertAction(title: "Add", style: .default) { (text) in
            let newItem = Category(context: self.context)
            newItem.name = textfield.text
            self.mainItemArr.append(newItem)
            self.tableView.reloadData()
        }
        alert.addTextField { (textval) in
            textval.placeholder = "add new item name"
            textfield = textval
        }
        alert.addAction(add)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        savemainData()
    }
    
    //save data in database using core data
    func savemainData()
    {
        do{
            try context.save()
        }catch
        {
            print("error in save data \(error)")
        }
    }
    
    // fetch/read data from database by using coredata
    
    func upload()  {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do
        {
            mainItemArr = try context.fetch(request)
        }
        catch
        {
            print("error in fech data \(error)")
        }
    }
}
