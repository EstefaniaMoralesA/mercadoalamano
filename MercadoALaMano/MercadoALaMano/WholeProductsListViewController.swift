//
//  WholeProductsListViewController.swift
//  MercadoALaMano
//
//  Created by Estefanía Morales Abud on 31/05/17.
//  Copyright © 2017 com.gueros. All rights reserved.
//

import UIKit

class WholeProductsListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ProductsCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var index = 0
    var isInAddMode = false
    var listName = ""
    var productList = NSMutableDictionary()
    var menuDictionary = NSMutableDictionary()
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // Action that saves the current product list into the plist of the user.
    // Only visible if the user isInAddMode (adding a product)
    @IBAction func saveList(_ sender: Any) {
        menuDictionary.removeObject(forKey: listName)
        menuDictionary.setValue(productList, forKey: listName)
        self.saveListPlist()
        dismiss(animated: true, completion: nil)
    }
    
    // Action that only dismiss the current view controller.
    @IBAction func cancelList(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var images = ["aguacuate", "manzana","platano","naranja","sandia"]
    var productName = ["aguacuate", "manzana","platano","naranja","sandia"]
    var price = [8.5,9.0,10.33,9.81,23.0]
    
    var currentImage : String = ""
    var currentName : String = ""
    var currentPrice : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // If the view comes from MyProductsListViewController then all the save and cancel buttons are going the be shown
        if isInAddMode {
            self.saveButton.isHidden = false
            self.cancelButton.isHidden = false
            self.cancelButton.backgroundColor = UIColor.flatGray()
            self.saveButton.backgroundColor = UIColor.flatGreenColorDark()
            self.loadListPlist()
        }
    }
    

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Images should be changed for the value in the dict
        return images.count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Create a custom cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell

        let stringCurrentPrice = NSString(format: "$%.2f", price[indexPath.row]) as String

        // Adding information to the cell
        cell.imageCell.image = UIImage(named: images[indexPath.row])
        cell.nameCell.text = productName[indexPath.row]
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.delegate = self
        
        // If the user is adding a product to their list then the buttons are shown and can be used to edit the cell values
        if isInAddMode {
            cell.priceCell.isHidden = true
            cell.addListButton.isHidden = false
            let index = "\(indexPath.row)"
            if ((productList.value(forKey: index)) != nil) {
                cell.addListButton.setTitle("-", for: .normal)
                cell.addListButton.backgroundColor = UIColor.flatRed()
                
            } else {
                cell.addListButton.setTitle("+", for: .normal)
                cell.addListButton.backgroundColor = UIColor.flatGreen()
            }

        } else {
            cell.priceCell.isHidden = false
            cell.addListButton.isHidden = true
            cell.priceCell.text = stringCurrentPrice
        }
        
        cell.index = "\(indexPath.row)"
        
        return cell
    }

    // When the user touches the cell then it is send to the DetailViewController
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        self.currentImage = images[indexPath.row]
        self.currentName = productName[indexPath.row]
        self.currentPrice = price[indexPath.row]
        self.index = indexPath.row
        
        return true
    }
    
    
    // Pass all the information that the DetailViewController need
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        let destinationVC = segue.destination as! DetailViewController
        
        destinationVC.index = self.index
        destinationVC.productName = self.currentName
        destinationVC.price = self.currentPrice
        destinationVC.image = self.currentImage
        destinationVC.isInAddMode = self.isInAddMode
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
    
    // Add the product to the dictionary and returns if it exist or not in the dictionary
    func addToDict(key: String) -> Bool {
        if ((productList.value(forKey: key)) != nil) {
            productList.removeObject(forKey: key)
            return true
        } else {
            productList.setValue(0, forKey: key)
            return false
        }
        
    }

    
}

