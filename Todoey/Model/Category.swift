//
//  Category.swift
//  Todoey
//
//  Created by Ankush Jindal on 26/04/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    let items = List<Item>()
    @objc dynamic var color:String = ""
}
