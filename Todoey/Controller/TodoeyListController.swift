//
//  ViewController.swift
//  Todoey
//
//  Created by sayali on 16/12/19.
//  Copyright © 2019 sayali. All rights reserved.
//

import UIKit
import RealmSwift
class TodoeyListController: UITableViewController{
    
    //selected particular catagiry
    var realm = try! Realm()
    var selectedCategory : Category?
    {
        didSet {
            
            loadData()
        }
    }
    @IBOutlet var TodoSearchbar: UISearchBar!
    var searchActive : Bool = false
    var filtered:Results<Item>?
    
    var todoArray  : Results<Item>?
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
            return filtered?.count ?? 1
        }
        return todoArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        if(searchActive){
            cell.textLabel?.text = filtered?[indexPath.row].title ?? "Not found";
            cell.accessoryType = filtered?[indexPath.row].done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = todoArray?[indexPath.row].title ?? "no item added yet";
            cell.accessoryType = todoArray?[indexPath.row].done == true ? .checkmark : .none
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            print("row \(indexPath.row)")
            
            if let item = todoArray?[indexPath.row]
            {
                do
                {
                    try realm.write {
                        item.done = !item.done
                    }
                }
                catch
                {
                    print(error)
                }
            }
            tableView.reloadData()
            
            if(!searchActive){
                if let item = todoArray?[indexPath.row]
                {
                    do
                    {
                        try realm.write {
                            item.done = !item.done
                        }
                    }
                    catch
                    {
                        print(error)
                    }
                }
                
            }
            else
            {
                if let item = filtered?[indexPath.row]
                {
                    do
                    {
                        try realm.write {
                            item.done = !item.done
                        }
                    }
                    catch
                    {
                        print(error)
                    }
                }
                
            }
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
            }
            else{
                cell.accessoryType = .checkmark
            }
            tableView.reloadData()
            // }
        }
    }
    
    //delete row
    
    // this method handles row deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // remove the item from the data model
            if(!searchActive){
                do{
                    try realm.write {
                        realm.delete(todoArray![indexPath.row])
                    }
                }
                catch
                {
                    print(error)
                }
            }else{
                do{
                    try realm.write {
                        realm.delete(filtered![indexPath.row])
                    }
                }
                catch
                {
                    print(error)
                }
            }
            // saveData()
            
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Not used in our example, but if you were adding a new row, this is where you would do it.
        }
    }
    @IBAction func addBtnClicked(_ sender: UIBarButtonItem) {
        
        var textfiled = UITextField()
        TodoSearchbar.endEditing(true)
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
                
                if let curentitem = self.selectedCategory
                {
                    do
                    {
                        try self.realm.write() {
                            let newItem = Item()
                            newItem.title = textfiled.text!
                            newItem.done = false
                            curentitem.item.append(newItem)
                        }
                    }
                    catch
                    {
                        print(error)
                    }
                }
                self.searchActive = false;
                print("searchActive \(self.searchActive)")
                self.tableView.reloadData()
                
                
                
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
    //    func save(item : Item) {
    //
    //        do
    //        {
    //            try realm.write() {
    //                todoArray = realm.add(item)
    //            }
    //        }catch
    //        {
    //            print(error)
    //        }
    //
    //    }
    
    func loadData() {
        
        todoArray = selectedCategory?.item.sorted(byKeyPath: "title", ascending: true)
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
        filtered = todoArray?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "title", ascending: true)
        self.tableView.reloadData()
    }
    
}
