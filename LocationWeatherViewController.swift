//
//  LocationWeatherViewController.swift
//  WeatherTracker
//
//  Created by Eric Dockery.
//  Copyright © 2016 Eric Dockery. All rights reserved.
//

import UIKit

class LocationWeatherViewController: UITableViewController{
    var locationStore: LocationStore!
    var imageStore: ImageStore!
    var newLocation: Location!
    var createLocation: CreateLocation!
    var tempFahrenheit :Bool = true
    var locationCreated : NSMutableArray = NSMutableArray( array: ["Test", 0, 0.0, 0.0 , 0.0])
    @IBAction func addNewLocation(sender: AnyObject){
        
    }
    @IBAction func setBoolF(sender: UIBarButtonItem) {
        tempFahrenheit = true
        updateTemp()
    }
    @IBAction func setBoolC(sender: UIBarButtonItem) {
        tempFahrenheit = false
        updateTemp()
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let location = locationStore.allLocations[indexPath.row]
            
            let title = "Remove \(location.locationName)?"
            let message = "Are you sure you want to remove this Location?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            ac.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Remove", style: .Destructive, handler: {(action) -> Void in
                    self.locationStore.removeLocation(location)
                    self.imageStore.deleteImageForKey(location.itemKey)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)})
            ac.addAction(deleteAction)
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        let storeCount = locationStore.allLocations.count
        if proposedDestinationIndexPath.row < storeCount {
            return proposedDestinationIndexPath
        }
        return NSIndexPath(forRow: storeCount - 1, inSection: 0)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var canEdit: Bool
        if (indexPath.row != locationStore.allLocations.count) {
            canEdit = true
        }
        else {
            canEdit = false
        }
        return canEdit
    }

    
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        locationStore.moveLocationAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    
    // MARK: update temps for everything in table view if you are not adding a new one.
    func updateTempFromZip(zipCode: Int64) -> Int{
        var updatedTemp = 0
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
                      
                        if let main = json["main"]{
                            if let temp = main["temp"]{
                                updatedTemp = Int(temp as! NSNumber)
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
        while updatedTemp == 0{
            
        }
        
        return updatedTemp
    }
    //MARK: - Convert Kelvin value to Fahrenheit
    private func ConvertToFahrenheit(temp: Int) -> Int{
        print (temp)
        let Ftemp =  Int(round(( 1.8 * (Double(temp) - 273.15) + 32 )))
        return Ftemp
    }
    
    //MARK: - Convert Kelvin value to celsius
    private func ConvertToCelsius(temp: Int) -> Int{
        let Ctemp = Int(round((Double(temp)  - 273.15)))
        return Ctemp
    }

    
    func updateTemp(){
        for locationCell in locationStore.allLocations{
            if tempFahrenheit {
                locationCell.currentTemperature = ConvertToFahrenheit( updateTempFromZip(locationCell.locationZipCode))
            }
            else {
                locationCell.currentTemperature = ConvertToCelsius( updateTempFromZip(locationCell.locationZipCode))
            }
        }
        
    }
    //MARK: - pulls out the data of new locations added in CreateLocation and updates all values of temp in table view on load
    override func viewDidLoad() {
        super.viewDidLoad()
        if let locationName = locationCreated[0] as? String {
            if locationName != "Test" {
                if let currentTemp = locationCreated[2] as? Int{
                    if let zip32 = (locationCreated[1] as? Int){
                        let zip = Int64(zip32)
                        if let xCrd = locationCreated[3] as? Double{
                            if let yCrd = locationCreated[4] as? Double{
                                newLocation = locationStore.createLocation(false, location: locationName, currentTemp: currentTemp, zipCode: zip, xCord: xCrd, yCord: yCrd)
                                if let index =  locationStore.allLocations.indexOf(newLocation){
                                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                                    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                                }
                            
                            }
                        }
                    }
                }
            }
        }
        
        updateTemp()
   
        tableView.backgroundView = UIImageView(image: UIImage(named: "weatherdog"))
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func tableView( tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return locationStore.allLocations.count
    }
    
    //MARK: - Colors the temperatures a nice color to go with the temperature feel
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell", forIndexPath: indexPath) as! LocationCell
        cell.updateLabels()
        if ( locationStore.allLocations.count != indexPath.row){
            let location = locationStore.allLocations[indexPath.row]
            cell.locationNameLabel.text = location.locationName
            cell.locationZipLabel.text = "\(location.locationZipCode)"
            
            cell.temperatureLabel.text = "\(location.currentTemperature)"
            
            if location.currentTemperature < 50{
                cell.temperatureLabel.textColor = UIColor.blueColor()
            }
            else if 50 <= location.currentTemperature && location.currentTemperature < 80{
                cell.temperatureLabel.textColor = UIColor.yellowColor()
                
            }
            else{
                cell.temperatureLabel.textColor = UIColor.redColor()
            }
            
        }
       
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat
        height = 60.0
        return height
    }
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowLocation"{
            if let row = tableView.indexPathForSelectedRow?.row{
                let location = locationStore.allLocations[row]
                let findLocationInformationViewController = segue.destinationViewController as! FindLocationInformationViewController
                findLocationInformationViewController.location = location
                findLocationInformationViewController.imageStore = imageStore
            }
        }
        if segue.identifier == "AddNewLocation" {
            let locStore = locationStore
            let addView = segue.destinationViewController as! CreateLocation
            addView.locationStore = locStore
            addView.imageStore = imageStore
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        navigationItem.leftBarButtonItem = editButtonItem()
    }
}
