//
//  ViewController.swift
//  Todoey
//
//  Created by sayali on 16/12/19.
//  Copyright © 2019 sayali. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework


class TodoeyListController: SwipeTableViewController {
    
    @IBOutlet var addbtn: UIBarButtonItem!
    @IBOutlet var searchbar: UISearchBar!
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
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        let colour = selectedCategory?.randomColour
        addbtn.tintColor = ContrastColorOf(UIColor(hexString: colour!)!, returnFlat: true)
          tableView.rowHeight = 80
        //   let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        tableView.separatorColor = UIColor.red
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        //selected particular catagiry
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        if let colour = selectedCategory?.randomColour
        {
            navigationController?.navigationBar.barStyle = .default
            navigationController?.navigationBar.barTintColor = UIColor(hexString: colour)
            navigationController?.navigationBar.tintColor = ContrastColorOf(UIColor(hexString: colour)!, returnFlat: true)
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(UIColor(hexString: colour)!, returnFlat: true)]

            searchbar.barTintColor = UIColor(hexString: colour)

        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor.flatSkyBlue
        
       // navigationController?.navigationBar.barTintColor = UIColor.flatWhite
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.flatWhite]
        navigationController?.navigationBar.tintColor = ContrastColorOf(UIColor.flatWhite, returnFlat: true)
    }
    
    //Mark : table view datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered?.count ?? 1
        }
        return todoArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if(searchActive){
            cell.textLabel?.text = filtered?[indexPath.row].title ?? "Not found";
            
            if var colour = UIColor(hexString: (selectedCategory?.randomColour)!)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat((todoArray?.count)!))
            {
               // cell.backgroundColor = colour
               // cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                cell.tintColor = ContrastColorOf(colour, returnFlat: true)
            }
            cell.accessoryType = filtered?[indexPath.row].done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = todoArray?[indexPath.row].title ?? "no item added yet";
             if var colour = UIColor(hexString: (selectedCategory?.randomColour)!)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat((todoArray?.count)!))
            {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                cell.tintColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            cell.accessoryType = todoArray?[indexPath.row].done == true ? .checkmark : .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            
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
           if(searchActive)
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

            tableView.reloadData()
            
        }
    }
        
        override func update(at indexpath: IndexPath) {
            if(!searchActive){
                do{
                    try realm.write {
                        realm.delete(todoArray![indexpath.row])
                    }
                }
                catch
                {
                    print(error)
                }
            }
            else{
                do{
                    try realm.write {
                        realm.delete(filtered![indexpath.row])
                    }
                }
                catch
                {
                    print(error)
                }
            }
        }
    
    
    //delete row
    
    // this method handles row deletion
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//
//            // remove the item from the data model
//            if(!searchActive){
//                do{
//                    try realm.write {
//                        realm.delete(todoArray![indexPath.row])
//                    }
//                }
//                catch
//                {
//                    print(error)
//                }
//            }else{
//                do{
//                    try realm.write {
//                        realm.delete(filtered![indexPath.row])
//                    }
//                }
//                catch
//                {
//                    print(error)
//                }
//            }
//            // saveData()
//
//            // delete the table view row
//            tableView.deleteRows(at: [indexPath], with: .fade)
//
//        } else if editingStyle == .insert {
//            // Not used in our example, but if you were adding a new row, this is where you would do it.
//        }
//    }
    @IBAction func addBtnClicked(_ sender: UIBarButtonItem) {
        
        var textfiled = UITextField()
        TodoSearchbar.endEditing(true)
        let alert = UIAlertController(title: "Add item", message: "Add new item in your todo list", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (newitemtext) in
        
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
                            newItem.colour = UIColor.randomFlat.hexValue()
                            curentitem.item.append(newItem)
                        }
                    }
                    catch
                    {
                        print(error)
                    }
                }
                self.searchActive = false;
             
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
