//
//  FirstViewController.swift
//  MercadoALaMano
//
//  Created by Estefanía Morales Abud on 31/05/17.
//  Copyright © 2017 com.gueros. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ProductsCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var index = 0
    var isInAddMode = false
    var listName = ""
    var productList = NSMutableDictionary()
    var menuDictionary = NSMutableDictionary()
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func saveList(_ sender: Any) {
        menuDictionary.removeObject(forKey: listName)
        menuDictionary.setValue(productList, forKey: listName)
        self.saveListPlist()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelList(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    let fruits = "{" +
        "\"id\": 1," +
    "\"name\": \"apple\"" +
    "\"price\": 10," +
    "\"image\": \"apple\"" +
    "}," +
    "{" +
    "\"id\": 2," +
    "\"name\": \"banana\"" +
    "\"price\": 10," +
    "\"image\": \"banana\"" +
    "}," +
    "{" +
    "\"id\": 3," +
    "\"name\": \"orange\"" +
    "\"price\": 10," +
    "\"image\": \"orange\"" +
    "}," +
    "{" +
    "\"id\": 4," +
    "\"name\": \"aguacate\"" +
    "\"price\": 10," +
    "\"image\": \"aguacate\"" +
    "}"
    

//    var dict = [String: Any]()
    
    var images = ["aguacuate", "apple","banana"]
    var productName = ["aguacuate", "apple","banana"]
    var price = [8.5,9.0,10.33]
    
    var currentImage : String = ""
    var currentName : String = ""
    var currentPrice : Double = 0.0


//    func convertToDictionary(text: String) -> [String: Any]? {
//        if let data = text.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        return nil
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if isInAddMode {
            self.saveButton.isHidden = false
            self.cancelButton.isHidden = false
            self.loadListPlist()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Images should be changed for the value in the dict
        return images.count
    }
    
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell

        let stringCurrentPrice = NSString(format: "$%.2f", price[indexPath.row]) as String

        
        cell.imageCell.image = UIImage(named: images[indexPath.row])
        cell.nameCell.text = productName[indexPath.row]
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        cell.delegate = self
        
        if isInAddMode {
            cell.priceCell.isHidden = true
            cell.addListButton.isHidden = false
            let index = "\(indexPath.row)"
            if ((productList.value(forKey: index)) != nil) {
                cell.addListButton.setTitle("-", for: .normal)
            } else {
                cell.addListButton.setTitle("+", for: .normal)
            }

        } else {
            cell.priceCell.isHidden = false
            cell.addListButton.isHidden = true
            cell.priceCell.text = stringCurrentPrice
        }
        
        cell.index = "\(indexPath.row)"
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        self.currentImage = images[indexPath.row]
        self.currentName = productName[indexPath.row]
        self.currentPrice = price[indexPath.row]
        self.index = indexPath.row
        
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        let destinationVC = segue.destination as! DetailViewController
        
        destinationVC.index = self.index
        destinationVC.productName = self.currentName
        destinationVC.price = self.currentPrice
        destinationVC.image = self.currentImage
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

