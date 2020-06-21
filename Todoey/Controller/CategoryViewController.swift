//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ankush Jindal on 26/04/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework
class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categoryArray: Results<Category>? //
    //var categoryArray = [Category]()
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //loadItems()
        loadcategory()
        tableView.rowHeight = 80.0
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "add item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "addd item", style: .default) { (action) in
            
            //let newitem = Category(context: self.context) for coredta
            let newitem = Category()
            newitem.name = textfield.text!
            newitem.color = UIColor.randomFlat().hexValue()
            //self.categoryArray.append(newitem) no need category is now autoupdating####
            //self.saveItems()
            self.saveItems(category: newitem)
        }
        alert.addTextField { (alerttf) in
            alerttf.placeholder = "create new item"
            textfield = alerttf
            
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    
    
    }
    
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! SwipeTableViewCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name
        cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].color ?? "1D9BF6")
        //cell.delegate = self
        // ternary operator
        // value = condition ? valueiftrue: valuenottri
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // to del data
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        performSegue(withIdentifier: "ToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TodolistViewController
        if let indexpath = tableView.indexPathForSelectedRow{
            destVC.selectedCategory = categoryArray?[indexpath.row]
        }
        
    }
    func saveItems(category: Category){
        
        do{
            //try context.save()
            try realm.write(){
                realm.add(category)
            }
        }catch{
            print(error)
        }
        
        tableView.reloadData()
    }
    //func loadItems(for request: NSFetchRequest<Category> = Category.fetchRequest()){
        //let request : NSFetchRequest<Category> = Category.fetchRequest()
        //do{
          //  categoryArray = try context.fetch(request)
     
      //  }catch{
      //      print(error)
      //  }
        //tableView.reloadData()
    
    func loadcategory(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    override func updateItem(at indexPath: IndexPath) {
        if let catdel = self.categoryArray?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(catdel)
                }
            }catch{
                print(error)
            }
            
        }
    }
}





