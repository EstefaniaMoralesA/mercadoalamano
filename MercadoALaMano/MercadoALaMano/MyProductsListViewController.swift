//
//  MyProductsListViewController.swift
//  
//
//  Created by Raul M on 25/06/17.
//
//

import UIKit

class MyProductsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ListCellDelegate {
    
    
    // Variables for saving the plist information
    var menuDictionary = NSMutableDictionary()
    var productsList = NSMutableDictionary()
    
    var listName = ""
    var isEditingList = false
    var wasEdited = false
    
    var images = ["aguacuate", "apple","banana"]
    var productName = ["aguacuate", "apple","banana"]
    var price = [8.5,9.0,10.33]
    var currentItems = 0.0
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var myProductListTable: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    /* Actioin that changes the user interaction, in this the user
       can edit its order, the number of products that want to have 
       in its list. It changes the button to Save, this updates the plist
       and reloads the data */
    @IBAction func editList(_ sender: Any) {
        if !isEditingList {
            print(productsList.description)
            isEditingList = true
            self.addButton.isHidden = false
            myProductListTable.reloadData()
            editButton.title = "Save"
            wasEdited = true
        } else {
            isEditingList = false
            self.addButton.isHidden = true
            self.saveListPlist()
            myProductListTable.reloadData()
            editButton.title = "Edit"
            wasEdited = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButton.isHidden = true
        self.navigationItem.title = listName
        self.loadProductsList()
    }
    
    // Function that loads the plist of the user, reads the list and return a dictionary with the Key: Id and the Value: quantity
    func loadProductsList() {
        self.loadListPlist()
        if ((menuDictionary.value(forKey: listName)) != nil) {
            productsList = menuDictionary.value(forKey: listName) as! NSMutableDictionary
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsList.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Creates a custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! MyProductsTableViewCell
        let key = productsList.allKeys[indexPath.row] as? String
        let index = Int(key!)
        let stringCurrentPrice = NSString(format: "$%.2f", price[index!]) as String
        var quantity = 0
        
        quantity = productsList.value(forKey: key!) as! Int // Gets the value from the current product cell
        // Asign info to the cell
        cell.delegate = self
        cell.index = key!
        cell.name.text = productName[index!]
        cell.price.text = stringCurrentPrice
        cell.imageP.image = UIImage(named: images[index!])
        cell.quantityTextField.text = "\(quantity)"
        

       // If the user is in editting mode then it shows the necessary buttons to edit the list
        if isEditingList {
            cell.removeButton.isHidden = false
            cell.addButton.isHidden = false
            cell.quantityTextField.isUserInteractionEnabled = true
        } else {
            cell.removeButton.isHidden = true
            cell.addButton.isHidden = true
            cell.quantityTextField.isUserInteractionEnabled = false
        }

        return cell
    }
    
    
    // Function that enables Delete action when the user slides from right to left.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            self.productsList.removeObject(forKey: productsList.allKeys[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.saveListPlist()
        }
    }
    
    // When the view appear will load again the products and the table
    override func viewDidAppear(_ animated: Bool) {
        self.loadProductsList()
        myProductListTable.reloadData()
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
    
    // Function that updates the whole menuDictionary so it can be saved later
    func updateDict() {
        menuDictionary.removeObject(forKey: listName)
        menuDictionary.setValue(productsList, forKey: listName)
    }
    
    // Prepares the view to pass the data to the WholeProductsList
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! WholeProductsListViewController
        
        destinationVC.isInAddMode = true
        destinationVC.listName = self.listName
        destinationVC.productList = self.productsList
        
    }
    
    // Add a new value to the current productList dictionary
    func addToDict(key: String, value: Int) {
        productsList.setValue(value, forKey: key)
    }

    
    
    
}
