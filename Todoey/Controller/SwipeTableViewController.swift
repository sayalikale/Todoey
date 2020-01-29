//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by sayali on 29/01/20.
//  Copyright © 2020 sayali. All rights reserved.
//

import UIKit
import SwipeCellKit
class SwipeTableViewController: UITableViewController ,SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SwipeTableViewCell
        cell?.delegate = self
        return cell!
    }
    
    
   
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.update(at: indexPath)
        }
        //tableView.reloadData()
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func update(at indexpath : IndexPath)  {
        
    }
}




