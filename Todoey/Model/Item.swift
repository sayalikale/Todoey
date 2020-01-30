//
//  item.swift
//  Todoey
//
//  Created by sayali on 28/01/20.
//  Copyright © 2020 sayali. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var colour : String = ""
    var parentCtegory = LinkingObjects(fromType: Category.self, property: "item")
    
}
