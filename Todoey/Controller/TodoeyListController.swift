//
//  ViewController.swift
//  Todoey
//
//  Created by sayali on 16/12/19.
//  Copyright © 2019 sayali. All rights reserved.
//

import UIKit
import CoreData
class TodoeyListController: UITableViewController{
    
    //selected particular catagiry
    var selectedCategory : Category?
    {
        didSet {
            
            loadData(wherefrom: true)
        }
    }
    @IBOutlet var TodoSearchbar: UISearchBar!
    var searchActive : Bool = false
    var filtered:[Item] = []
    
    var todoArray = [Item]()
    var userdefault = UserDefaults.standard
    @IBOutlet var TodoTableView: UITableView!
    
    
    //core data
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //   let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))\n\n\n")
        tableView.separatorColor = UIColor.red
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        //selected particular catagiry
        
        
        
    }
    
    //Mark : table view datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return todoArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row].title;
            cell.accessoryType = filtered[indexPath.row].done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = todoArray[indexPath.row].title;
            cell.accessoryType = todoArray[indexPath.row].done == true ? .checkmark : .none
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            print("row \(indexPath.row)")
            
            if(!searchActive){
                todoArray[indexPath.row].done = !todoArray[indexPath.row].done
            }
            else
            {
                filtered[indexPath.row].done = !filtered[indexPath.row].done
            }
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
            }
            else{
                cell.accessoryType = .checkmark
            }
            saveData()
        }
    }
    
    //delete row
    
    // this method handles row deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // remove the item from the data model
            if(!searchActive){
            context.delete(todoArray[indexPath.row])
            todoArray.remove(at: indexPath.row)
            }else{
                context.delete(filtered[indexPath.row])
                filtered.remove(at: indexPath.row)
            }
            saveData()
                
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Not used in our example, but if you were adding a new row, this is where you would do it.
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
                let newItem = Item(context: self.context)
                newItem.title = textfiled.text
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.todoArray.append(newItem)
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
        
        do
        {
            try context.save()
        }catch
        {
            print(error)
        }
        
    }
    
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil, wherefrom : Bool) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
        
        if let additionalCategory = predicate
        {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalCategory, categoryPredicate])
        }
        else
        {
            request.predicate = categoryPredicate
        }
        
        do
        {
            if (wherefrom == true)
            {
                todoArray = try context.fetch(request)
            }
            else
            {
                filtered = try context.fetch(request)
            }
            for item in todoArray
            {
                print("item \(item)")
            }
        }catch
        {
            print("error in feching the data \(error)")
        }
        tableView.reloadData()
    }
}


//MARK : searchbar implimentetion
extension TodoeyListController : UISearchBarDelegate
{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = false;
        searchBar.text = ""
        tableView.reloadData()
        print("sayalikale")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = false;
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchActive = false;
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                searchBar.resignFirstResponder()
                self.tableView.reloadData()
            }
        }
        // TodoSearchbar.showsCancelButton = true
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title contains[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadData(with: request,predicate: predicate, wherefrom: false)
        self.tableView.reloadData()
    }
    
}
