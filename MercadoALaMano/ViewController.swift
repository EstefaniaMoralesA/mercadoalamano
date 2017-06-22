//
//  ViewController.swift
//  MercadoALaMano
//
//  Created by Estefanía Morales Abud on 22/06/17.
//  Copyright © 2017 com.gueros. All rights reserved.
//

import UIKit

class ViewController: UIPageViewController, UIPageViewControllerDataSource {

    var arrPageTitle: NSArray = NSArray()
    var arrPagePhoto: NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrPageTitle = ["This is The App Guruz", "This is Table Tennis 3D", "This is Hide Secrets"];
        arrPagePhoto = ["bgfinal.png", "2.jpg", "3.jpg"];
        self.dataSource = self
        self.setViewControllers([getViewControllerAtIndex(index: 0)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        var index = pageContent.pageIndex
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        index -= 1;
        return getViewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        var index = pageContent.pageIndex
        if (index == NSNotFound)
        {
            return nil;
        }
        index += 1;
        if (index == arrPageTitle.count)
        {
            return nil;
        }
        return getViewControllerAtIndex(index: index)
    }
    
    func getViewControllerAtIndex(index: NSInteger) -> PageContentViewController
    {
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        pageContentViewController.strTitle = "\(arrPageTitle[index])"
        pageContentViewController.strPhotoName = "\(arrPagePhoto[index])"
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }
    
}
