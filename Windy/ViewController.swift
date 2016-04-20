//
//  ViewController.swift
//  Windy
//
//  Created by Kartik Mathpal on 18/04/16.
//  Copyright © 2016 Mathpal Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var img = UIImage()
    var imgArray = ["nyk.jpg","startrail.jpg","amirkabir_dam","sunset.jpg","river.jpg","lightning"]
    
    @IBOutlet weak var bgImage: UIImageView!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func findWeather(sender: AnyObject) {
        
        var flag = false
    //var image = UIImage(named: "bg2.jpg")
       
//        bgImage.image = randomImage()
        
        let attemptedURL = NSURL(string: "http://www.weather-forecast.com/locations/" + cityTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        if let url = attemptedURL {
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            if let urlContent = data{
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                // print(webContent)
                let websiteArray = webContent?.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                // print(websiteArray)
                if websiteArray!.count > 1 {
                    
                    let weatherArray  = websiteArray![1].componentsSeparatedByString("</span>")
                    if weatherArray.count > 1 {
                        
                        flag = true
                        
                        let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")// to replace &deg; with º
                        
                        //--------
                        if weatherSummary.containsString("dry"){
                            self.img = UIImage(named: "Dry.png")!
                        }else if weatherSummary.containsString("rain"){
                            self.img = UIImage(named: "Rain.png")!
                            }else if weatherSummary.containsString("hail"){
                              self.img = UIImage(named: "Hail.png")!
                            }
                        else if weatherSummary.containsString("snow"){
                            self.img = UIImage(named: "Snow.png")!
                        }
                        else if weatherSummary.containsString("storm"){
                            self.img = UIImage(named: "Storm.png")!
                        }else if weatherSummary.containsString("hot"){
                            self.img = UIImage(named: "Hot.png")!
                        }
                        else if weatherSummary.containsString("drizzle"){
                            self.img = UIImage(named: "Drizzle.png")!
                        }
                        //------
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.resultLabel.text = weatherSummary
                            self.image.image = self.img
                            self.bgImage.image = self.randomImage()
                        })
                        //since inside a closure we will use self
                        //self.resultLabel.text = weatherSummary
                    }
                }
            }
            if flag == false {
                self.resultLabel.text = "Couldn't find the weather for the city. Please try again"
                self.image.image = nil
                
            }
        }
        task.resume()
        }
        else {
            self.resultLabel.text = "Couldn't find the weather for the city. Please try again"
            
            self.image.image = nil 
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    func randomImage() -> UIImage{
        let unsignedArrayCount = UInt32(imgArray.count)
        let unsignedRandomNumber = arc4random_uniform(unsignedArrayCount)
        let randomNumber = Int(unsignedRandomNumber)
        
        return UIImage(named: imgArray[randomNumber])!
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

