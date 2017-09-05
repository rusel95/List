//
//  ViewController.swift
//  List
//
//  Created by Admin on 9/5/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CoreData

class tableViewController: UITableViewController {

    var listItems = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addItem))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let item = listItems[indexPath.row]
        cell.textLabel?.text = item.value(forKey: "item") as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let managedContext = CoreDataStack.managedObjectContext
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
        managedContext.delete(listItems[indexPath.row])
        listItems.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    func addItem() {
        let alertController = UIAlertController(title: "Type something:", message: "so...", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            let field = alertController.textFields![0] as UITextField
                self.saveItem(itemToSave: field.text!)
                self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "type in something"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func saveItem(itemToSave: String) {
        let managedContext = CoreDataStack.managedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ListEntity", in: managedContext)
        let item = NSManagedObject.init(entity: entity!, insertInto: managedContext)
        item.setValue(itemToSave, forKey: "item")
        
        do {
            try managedContext.save()
            listItems.append(item)
        } catch {
            print("error")
        }
        

    
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let managedContext = CoreDataStack.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ListEntity")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            listItems = results as! [NSManagedObject]
        } catch {
            print("error")
        }
    }

}

