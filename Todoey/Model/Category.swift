//
//  category.swift
//  Todoey
//
//  Created by sayali on 28/01/20.
//  Copyright © 2020 sayali. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var randomColour : String = ""
    let item = List<Item>()
}
