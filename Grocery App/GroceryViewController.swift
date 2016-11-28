//
//  ViewController.swift
//  Grocery App
//
//  Created by Tulga Narmandakh on 11/27/16.
//  Copyright © 2016 Tulga Narmandakh. All rights reserved.
//

import UIKit

class GroceryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var groceryTable: UITableView!
    
    var manager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        manager.loadGroceries()
        groceryTable?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.groceryCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gListCell", for: indexPath)
        
        let grocery = manager.getGrocery(from: indexPath)
        cell.textLabel?.text = grocery?.name
        cell.detailTextLabel?.text = "Items: \(grocery?.itemCount ?? 0)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: UIView.areAnimationsEnabled)
        
        manager.selectedGroceryIndex = indexPath.row
    }

}

