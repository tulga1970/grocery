//
//  AddGroceryController.swift
//  Grocery App
//
//  Created by Tulga Narmandakh on 11/27/16.
//  Copyright © 2016 Tulga Narmandakh. All rights reserved.
//

import UIKit

class AddGroceryController: UIViewController {

    @IBOutlet weak var nameTxtField: UITextField!
    
    var manager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addAction(_ sender: AnyObject) {
        do {
            try manager.create(grocery: nameTxtField?.text)
        }
        catch {
             print(error)
        }
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
