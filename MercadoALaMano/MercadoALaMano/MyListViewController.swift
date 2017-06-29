//
//  MyListViewController.swift
//  MercadoALaMano
//
//  Created by Estefanía Morales Abud on 31/05/17.
//  Copyright © 2017 com.gueros. All rights reserved.
//

import UIKit

class MyListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var menuDictionary = NSMutableDictionary()
    var productsList = NSMutableArray()
        
    var listName = ""
    
    @IBOutlet weak var myListTableView: UITableView!
    
    // This action shows an alert so the user could select the new name of their new list
    @IBAction func addList(_ sender: Any) {
        let alert = UIAlertController(title: "Mis Listas", message: "Crea una nueva lista", preferredStyle: .alert)
        alert.addTextField { textField -> Void in
            textField.placeholder = "Nombre de la lista"
        }
        alert.addAction(UIAlertAction(title: "Agregar", style: .default, handler: {
            (UIAlertAction) in
            if let list = alert.textFields![0].text {
                self.menuDictionary[list] = NSMutableDictionary()
                self.saveListPlist()
                self.myListTableView.reloadData()
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadListPlist()
        self.navigationItem.title = "Mis Listas"
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuDictionary.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! MyListTableViewCell
        cell.listNameLabel.text = menuDictionary.allKeys[indexPath.row] as? String
        return cell
    }
    
    // Function that gets the number of the row in the table and pass data to the MyProductsListViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        let currentCell = tableView.cellForRow(at: indexPath!) as! MyListTableViewCell
        listName = currentCell.listNameLabel!.text!
        performSegue(withIdentifier: "listToProducts", sender: self)
    }
    
    // Pass data to the MyProductsListViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MyProductsListViewController
        destinationVC.listName = self.listName
    }
    
    // Function that enables Delete action when the user slides from right to left.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            self.menuDictionary.removeObject(forKey: menuDictionary.allKeys[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.saveListPlist()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myListTableView.reloadData()
    }
    
    // Loads the user configuration
    func loadListPlist() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        let path = documentsDirectory.appendingPathComponent("myList.plist")
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: path){
            if let bundlePath = Bundle.main.path(forResource: "myList", ofType: "plist"){
                do {
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                }
                catch {
                    print("Error: failed loading plist")
                }
            }
        }
        
        menuDictionary = NSMutableDictionary(contentsOfFile: path)!
        
    }
    
    // Saves the menuDictionary into the plist
    func saveListPlist() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        let path = documentsDirectory.appendingPathComponent("myList.plist")
        menuDictionary.write(toFile: path, atomically: false)
    }
        
    
    


}

