//
//  CreateLocation.swift
//  WeatherTracker
//
//  Created by Eric Dockery .
//  Copyright © 2016 Eric Dockery. All rights reserved.
//   This parses the data correctly, but will not store the values... not sure what I have done wrong or why it wont store them into the locationStore


import UIKit

class CreateLocation: UIViewController {
    var locationStore : LocationStore!
    var newLocation: Location!
    var imageStore: ImageStore!

    var locationArray = NSMutableArray()
    private var locationNamejson = ""
    private var locationTempjson = 0.0
    private var locationXcordjson = 0.0
    private var locationYcordjson = 0.0
    

   
    
    @IBOutlet var enteredZipCode: UITextField!
     override func viewDidLoad() {
        locationArray = [" ", 0, 0.0, 0.0 , 0.0]
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let zip = verifyZip()
        useAPI(zip)
        
        while locationArray[2] as! NSObject == 0 {
            
        }
        
        
        let locationViewController = segue.destinationViewController as! LocationWeatherViewController
        locationViewController.locationCreated = locationArray
        locationViewController.locationStore = locationStore
        locationViewController.imageStore = imageStore
    }
        //MARK: - Verify Useful zipCode Value
    private func verifyZip()-> Int{
        if var zipCode = Int(enteredZipCode.text!){
            if zipCode > 99950{
                zipCode = 99950
            }
            else if zipCode < 00501{
                zipCode = 00501
     
            }
            //display the new zipCode on the text screen in case there was a change.
            enteredZipCode.text = String(zipCode)
            return zipCode
        }
        return 0
     
     }
    //MARK: Parsing JASON for Weather API

     private func useAPI(zipCode: Int) -> NSArray{
     
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
     
        let locationURL = NSURL( string: "http://api.openweathermap.org/data/2.5/weather?zip=\(zipCode),us&APPID=74b78f4effe729b2a841cb35e3862d85")
        let request = NSURLRequest(URL: locationURL!)
        let task = session.dataTaskWithRequest(request) {
            (data,response, error) -> Void in
     
            if let locationData = data {
                if let jsonString = NSString( data:locationData,encoding: NSUTF8StringEncoding){
                    let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String: AnyObject]
                        if let name = json["name"]{
                            self.locationArray[0] = name
                            self.locationArray[1] = zipCode
                                
                        }
                        if let coord = json["coord"]{
                            if let xCord = coord["lat"]{
                                self.locationArray[3] = xCord!
                            }
                            if let yCord = coord["lon"]{
                                self.locationArray[4] = yCord!
                            }
                        }
                            
                        
                        if let main = json["main"]{
                            if let temp = main["temp"]{
                                self.locationArray[2] = temp!
                            }
                        }
                        
          
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
     
                }
            }
            else if let requestError = error {
                print("Error fetching weather data: \(requestError)")
            }
            else {
                print("Unexpected error with request")
            }
     
     
        }
        task.resume()
     
        return locationArray
     
     
    }
        
    


}