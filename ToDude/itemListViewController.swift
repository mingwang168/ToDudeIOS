//
//  itemListViewController.swift
//  ToDude
//
//  Created by Ming Wang on 2020-03-05.
//  Copyright © 2020 Ming Wang. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

class itemListViewController: UITableViewController, SwipeTableViewCellDelegate {
   
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  var items = [Item]()
  
  @IBAction func addItemButtonTapped(_ sender: UIBarButtonItem) {
    var tempTextField = UITextField()
    
    let alertController = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "Done", style: .default) {(action) in
      let newItem = Item(context: self.context)
      if let text = tempTextField.text {
        newItem.title = text
        newItem.completed = false
        self.items.append(newItem)
        self.saveItems()
      }
    }
    
    alertController.addTextField{(textField) in
      textField.placeholder = "Title"
      tempTextField = textField
    }
    
    alertController.addAction(alertAction)
    
    present(alertController, animated: true, completion: nil)
  }
  

  
  override func viewDidLoad() {
        super.viewDidLoad()
    tableView.rowHeight = 80.0
        loadItems()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! SwipeTableViewCell
      cell.delegate = self

        // Configure the cell...
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.completed ? .checkmark : .none
        return cell
    }
    
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    item.completed = !item.completed
    saveItems()
  }
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else {return nil}
    let deleteAction = SwipeAction(style: .destructive, title: "Delete"){_, indexPath in
      self.context.delete(self.items[indexPath.row])
      self.items.remove(at: indexPath.row)
      self.saveItems()
    }
    deleteAction.image = UIImage(named: "trash")
    return [deleteAction]
  }
  
  func saveItems(){
    do {
      try context.save()
    }catch{
      print("Error saving context \(error)")
    }
    tableView.reloadData()
  }
  
  func loadItems(){
    let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
    do{
      items = try context.fetch(fetchRequest)
    }catch{
      print("Error fetching items: \(error)")
    }
    tableView.reloadData()
  }
}
