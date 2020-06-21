//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework
class TodolistViewController: SwipeTableViewController,UISearchBarDelegate{

    
    
    var itemArray: Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category?{
        didSet{
            loadItems1()
        }
    }
    
    
    //let dataFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    
    }
    @IBAction func seachPress(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "add item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "addd item", style: .default) { (action) in
            
            /*let newitem = Item(context: context)
            newitem.title = textfield.text!
            newitem.done = false
            newitem.parentCategory = self.selectedCategory
            
            self.saveItems()*/
            if let currCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                        let newitem = Item()
                        newitem.title = textfield.text!
                        currCategory.items.append(newitem)
                    }
                }catch{
                    print(error)
                }
            }
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alerttf) in
            alerttf.placeholder = "create new item"
            textfield = alerttf
            
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //cell.textLabel?.text = itemArray?[indexPath.row].title
        // ternary operator
        // value = condition ? valueiftrue: valuenottri
        //cell.accessoryType = (itemArray?[indexPath.row].done)! ? .checkmark : .none
        
        if let i = itemArray?[indexPath.row]{
            cell.textLabel?.text = i.title
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(itemArray!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            }
            
            
            
            
            cell.accessoryType = i.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "no item sdded"
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // to del data
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        //itemArray?[indexPath.row].done = !itemArray?[indexPath.row].done
        //self.saveItems()
        if let item = itemArray?[indexPath.row]{
            do{
                try self.realm.write{
                    //realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print(error)
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    /*func saveItems(){
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        
        tableView.reloadData()
    }
    func loadItems(for request: NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addpredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [addpredicate,categoryPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
     
        }catch{
            print(error)
        }
        tableView.reloadData()
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(for: request,predicate: predicate)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems1()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }*/
    func loadItems1(){
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title",ascending: true)
        tableView.reloadData()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0{
            loadItems1()
            DispatchQueue.main.async {
            
                searchBar.resignFirstResponder()
            }
        }
    }
    override func updateItem(at indexPath: IndexPath) {
        if let catdel = self.itemArray?[indexPath.row]{
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
