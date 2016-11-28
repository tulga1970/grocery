//
//  AddItemViewController.swift
//  Grocery App
//
//  Created by Tulga Narmandakh on 11/27/16.
//  Copyright © 2016 Tulga Narmandakh. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var quantityTxtField: UITextField!
    
    @IBOutlet weak var quantityTypeField: UITextField!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    var manager = DataManager.shared
    var item: (name: String?, quantityType: String?, quantity: Int16, isComplete: Bool)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        item = manager.getItem(from: manager.selectedItemIndex)
        
        if (item != nil) {
            detailLabel?.text = "Edit Grocery Item"
            nameTxtField?.text = item?.name
            quantityTxtField?.text = "\(item?.quantity ?? 0)"
            quantityTypeField?.text = item?.quantityType
            deleteBtn?.isHidden = false
        }else {
            detailLabel?.text = "Add Grocery Item"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addItem(_ sender: AnyObject) {
        
        try? manager.createOrSave(data:
            (name: nameTxtField?.text,
             quantityType: quantityTypeField?.text,
             quantity: quantityTxtField?.text?.integer ?? 0
        ))
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func deleteItem(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Delete Item", message: "You are about to delete item '\(item?.name)'", preferredStyle: .actionSheet)
        
        let  deleteButton = UIAlertAction(title: "Delete forever", style: .destructive, handler: { (action) -> Void in
            try? self.manager.deleteItem()
            self.dismiss(animated: true, completion: nil)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)

    }
    @IBAction func cancel(_ sender: AnyObject) {
        manager.selectedItemIndex = -1
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
