//
//  CategoryViewController.swift
//  FamilyTalk
//
//  Created by Ohad Brunner on 04/03/2018.
//  Copyright © 2018 Ohad Brunner. All rights reserved.
//


import UIKit
import CoreData
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var ListTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()
        
        //ListTableView.separatorStyle = .none
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(ListTableView, cellForRowAt: indexPath)
    
        cell.textLabel?.text = categories[indexPath.row].name
        
        cell.backgroundColor = UIColor.flatSkyBlue().darken(byPercentage:
        
            CGFloat(indexPath.row) / CGFloat(categories.count)
            
        )
        cell.textLabel?.textColor = UIColor.flatWhite()
        cell.textLabel?.font = UIFont.init(name: "Euphemia UCAS", size: CGFloat(21.0))
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToItems" {
            
            let destinationVC = segue.destination as! ItemsViewController
            
            if let indexPath = ListTableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories[indexPath.row]
                
            }
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategory() {
        
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        ListTableView.reloadData()
    }
    
    func loadCategories() {
        
        //this is the request we are going to send in order to retrieve our data from the data base
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        
        ListTableView.reloadData()
    }
    
    //MARK: - Deleting Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        self.context.delete(self.categories[indexPath.row])
        self.categories.remove(at: indexPath.row)
    
    }
    
    //MARK: - Adding New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
            self.saveCategory()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            
            textField = field
            textField.placeholder = "Add a new category"
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func FamilyTalkPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "goToChat", sender: self)
    }
    
    @IBAction func LogOutPressed(_ sender: UIBarButtonItem) {

        self.dismiss(animated: true, completion: nil)
    }
    
}


