//
//  ModelController.swift
//  pagetest
//
//  Created by Marcus thuvesen on 2019-03-09.
//  Copyright © 2019 Marcus thuvesen. All rights reserved.
//

import UIKit

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


class ModelController: NSObject, UIPageViewControllerDataSource {

    var pageData: [String] = []


    override init() {
        super.init()
        // Create the data model.
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        
        
        //Two Days Ago
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date())
        let twoDaysAgoToString = dateFormatter.string(from: twoDaysAgo!)
        pageData.append(twoDaysAgoToString)
        
        //One Day Ago
        let oneDayAgo = calendar.date(byAdding: .day, value: -1, to: Date())
        let oneDayAgoToString = dateFormatter.string(from: oneDayAgo!)
        pageData.append(oneDayAgoToString)
        
        //Current Date
        let dateInFormat = dateFormatter.string(from: Date())
        pageData.append(dateInFormat)
        
        //Tomorrow
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())
        let tomorrowToString = dateFormatter.string(from: tomorrow!)
        pageData.append(tomorrowToString)
        
        //Day After Tomorrow
        let dayAfterTomorrow = calendar.date(byAdding: .day, value: 2, to: Date())
        let dayAfterTomorrowToString = dateFormatter.string(from: dayAfterTomorrow!)
        pageData.append(dayAfterTomorrowToString)
        
        
        
        
        
    }

    func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> DataViewController? {
        // Return the data view controller for the given index.
        if (self.pageData.count == 0) || (index >= self.pageData.count) {
            return nil
        }

        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard.instantiateViewController(withIdentifier: "DataViewController") as! DataViewController
        dataViewController.dataObject = self.pageData[index]
        return dataViewController
    }

    func indexOfViewController(_ viewController: DataViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        return pageData.index(of: viewController.dataObject) ?? NSNotFound
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DataViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DataViewController)
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == self.pageData.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

}


