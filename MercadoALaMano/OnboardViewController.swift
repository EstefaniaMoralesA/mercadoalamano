//
//  ViewController.swift
//  OnboardDemo
//
//

import UIKit
import Onboard

class OnboardViewController: OnboardingViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // MARK: Initializers
    
    required init?(coder aDecoder: NSCoder) {
        
        let welcomePage = OnboardingContentViewController(title: "PAY WHAT YOU WANT", body: "I made my app so you could have the best experience reading tech related news. That’s why I want you to value it based on your satisfaction.", image: UIImage(named: ""), buttonText: nil) {}
        let firstPurchasePage = OnboardingContentViewController(title: "MINT", body: "The app is great but there’s still a few places in room of improvement. If this is your feeling this is for you.", image: UIImage(named: ""), buttonText: nil) {}
        let secondPurchasePage = OnboardingContentViewController(title: "SWEET", body: "IThis is the suggested price where you value the time I spent on development and design. Feel free to pay more or less.", image: UIImage(named: ""), buttonText: nil) {}
        let thirdPurchasePage = OnboardingContentViewController(title: "GOLD", body: "Hello is it me your looking for, if this popped into your mind using the app then this is the price for you.", image: UIImage(named: ""), buttonText: nil) {}
        
        super.init(coder: aDecoder)
        
        self.viewControllers = [welcomePage, firstPurchasePage, secondPurchasePage, thirdPurchasePage]
        self.allowSkipping = true
        self.swipingEnabled = true
        
        skipHandler = { self.performSegue(withIdentifier: "SegueIdentifier", sender: nil) }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
