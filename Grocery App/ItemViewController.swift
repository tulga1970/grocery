//
//  ViewController.swift
//  Grocery App
//
//  Created by Tulga Narmandakh on 11/27/16.
//  Copyright © 2016 Tulga Narmandakh. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var itemTable: UITableView!
    
    var manager = DataManager.shared
    
    var editingState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        manager.loadItems()
        itemTable?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gItemCell", for: indexPath)
        
        let gItem = manager.getItem(from: indexPath.row)
        
        cell.textLabel?.text = gItem?.name
        cell.detailTextLabel?.text = "\(gItem?.quantityType ?? "Quantity"): \(gItem?.quantity ?? 0)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: UIView.areAnimationsEnabled)
        
        manager.selectedItemIndex = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = manager.getItem(from: indexPath.row)
            manager.selectedItemIndex = indexPath.row
            
            let alertController = UIAlertController(title: "Delete Item", message: "You are about to delete item '\(item?.name)'", preferredStyle: .actionSheet)
            
            let  deleteButton = UIAlertAction(title: "Delete forever", style: .destructive, handler: { (action) -> Void in
                try? self.manager.deleteItem()
                self.itemTable?.reloadData()
                self.dismiss(animated: true, completion: nil)
            })
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                print("Cancel button tapped")
            })
            
            alertController.addAction(deleteButton)
            alertController.addAction(cancelButton)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func editHandler(_ sender: UIBarButtonItem) {
        editingState = !editingState;
        itemTable?.setEditing(editingState, animated: UIView.areAnimationsEnabled)
        if(editingState) {
            sender.title = "Done"
        }else {
            sender.title = "Edit"
        }
    }
    
}

