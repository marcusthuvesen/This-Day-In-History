//
//  DataViewController.swift
//  pagetest
//
//  Created by Marcus thuvesen on 2019-03-09.
//  Copyright © 2019 Marcus thuvesen. All rights reserved.
//

import UIKit
import VACalendar
import Alamofire
import SwiftyJSON

class DataViewController: UIViewController {

   
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var showCalendarButton: UIButton!
    @IBOutlet weak var fadeView: UIView!
    @IBOutlet weak var dayDescriptionText: UITextView!
    
    
    var dataObject: String = ""
    var wikipediaURL = "https://en.wikipedia.org/w/api.php"

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    private lazy var calendarPopup: CalenderPopupView = {
        let frame = CGRect(
            x: 15,
            y: dayLabel.frame.maxY + 20,
            width: view.frame.width - 30,
            height: 365
        )
        let calendar = CalenderPopupView(frame: frame)
        calendar.backgroundColor = .clear
        calendar.layer.shadowColor = UIColor.black.cgColor
        calendar.layer.shadowOpacity = 0.4
        calendar.layer.shadowOffset = .zero
        calendar.layer.shadowRadius = 5
        calendar.didSelectDay = { [weak self] date in
            self?.setSelectedDate(date)
        }
        return calendar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardView.layer.cornerRadius = 15
        setSelectedDate(Date())
    }
    
    func requestWikiInfo(pickedDate : String){
        let parameters : [String:String] = [
            
            "format" : "json",
            "action" : "query",
            "prop" : "extracts",
            "rvprop" : "content",
            "rvsection" : "0",
            "exintro" : "2",
            "explaintext" : "",
            "titles" : pickedDate,
            "indexpageids" : "",
            
            
        ]

        Alamofire.request(wikipediaURL, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess{
                print("We got the wikipedia info")
                //print(response)
                
                let dateJSON : JSON = JSON(response.result.value!)
                print(JSON(response.result.value))
                let pageid = dateJSON["query"]["pageids"][0].stringValue
                
                let dateDescription = dateJSON["query"]["pages"][pageid]["extr"].stringValue
                
                self.dayDescriptionText.text = dateDescription
            }
        }
    }
    
    @IBAction func didTapSelectDay(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            view.addSubview(calendarPopup)
            print("Här")
            self.fadeView.isHidden = false
            self.view.bringSubviewToFront(showCalendarButton)
        } else {
            calendarPopup.removeFromSuperview()
            self.fadeView.isHidden = true
            requestWikiInfo(pickedDate: dayLabel.text!)
        }
    }
    
    private func setSelectedDate(_ date: Date) {
        dayLabel.text = formatter.string(from: date)
    }
    
}



