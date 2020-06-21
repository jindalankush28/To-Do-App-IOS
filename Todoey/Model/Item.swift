//
//  Item.swift
//  Todoey
//
//  Created by Ankush Jindal on 26/04/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title:String=""
    @objc dynamic var done:Bool=false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
