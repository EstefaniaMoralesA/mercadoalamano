//
//  MyProductsListViewController.swift
//  
//
//  Created by Raul M on 25/06/17.
//
//

import UIKit

class MyProductsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ListCellDelegate {
    
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
        
        self.loadListPlist()
        
        self.addButton.isHidden = true
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.navigationItem.title = listName
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! MyProductsTableViewCell
        

        let key = productsList.allKeys[indexPath.row] as? String
        let index = Int((productsList.allKeys[indexPath.row] as? String)!)
        let stringCurrentPrice = NSString(format: "$%.2f", price[index!]) as String
        var quantity = 0
//        if wasEdited{
//            quantity = Int(cell.quantityTextField.text!)!
//            productsList.setValue(quantity, forKey: key!)
//            updateDict()
//            saveListPlist()
//        } else {
            quantity = productsList.value(forKey: key!) as! Int
//        }
        
        
        cell.delegate = self
        cell.index = key!
        cell.name.text = productName[index!]
        cell.price.text = stringCurrentPrice
        cell.imageP.image = UIImage(named: images[index!])
        cell.quantityTextField.text = "\(quantity)"
        

       
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
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.cellForRow(at: indexPath) as! MyProductsTableViewCell
    }
    
    // Function that enables Delete action when the user slides from right to left.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            self.productsList.removeObject(forKey: productsList.allKeys[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.saveListPlist()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myProductListTable.reloadData()
    }
    
    
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
    
    func saveListPlist() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        let path = documentsDirectory.appendingPathComponent("myList.plist")
        
        menuDictionary.write(toFile: path, atomically: false)
    }
    
    func updateDict() {
        // borrar y poner diccionario
        // remove,
        var path = ""
        for (k,v) in productsList {
            path = listName + "." + (k as! String)
            menuDictionary.setValue(v, forKeyPath: path)
        }
    }
    
    func updateProductListWithTextField(v: Any, k: String) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! FirstViewController
        
        destinationVC.isInAddMode = true
        destinationVC.listName = self.listName
        destinationVC.productList = self.productsList
        
    }
    
    
    func addToDict(key: String, value: Int) {
        print(productsList.description)
        productsList.setValue(value, forKey: key)
        print(productsList.description)
    }

    
    
    
}
