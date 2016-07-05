//
//  Location.swift
//  WeatherTracker
//
//  Created by Eric Dockery.
//  Copyright © 2016 Eric Dockery. All rights reserved.
//

import UIKit

class Location: NSObject{
    var locationName: String
    var currentTemperature: Int
    var locationZipCode: Int64
    let itemKey: String
    var xCord: Double
    var yCord: Double

    init( locationName: String, currentTemperature: Int, locationZipCode: Int64, xCord: Double, yCord: Double){
        self.locationName = locationName
        self.currentTemperature = currentTemperature
        self.locationZipCode = Int64(locationZipCode)
        self.xCord = xCord
        self.yCord = yCord
        self.itemKey = NSUUID().UUIDString
        
        
        super.init()
        
    }

    convenience init( random:Bool = false, locationNme: String, currentTmperature: Int, locationZpCode: Int64, xCrd: Double, yCrd: Double ){
        if random {
            let locations = ["Louisville", "Gainesville", "Austin", "San Francisco"]
            //38.2527, 85.7585
            //29.6516, 82.3248
            // 30.2672, -97.7431
            // 37.7749, -122.4194
            let xCords = [38.2527, 29.6516, 30.2672, 37.7749 ]
            let yCords = [-85.7585, -82.3248, -97.7431, -122.4194 ]
            let zips = [40217, 32608, 77878, 46454]
            let temps = [76, 101, 95, 68]
            var idx = arc4random_uniform(UInt32(locations.count))
            let randomLocation = locations[Int(idx)]
            let randomLocationxCord = xCords[Int(idx)]
            let randomLocationyCord = yCords[Int(idx)]
            let randomZip = zips[Int(idx)]
            idx = arc4random_uniform(UInt32(temps.count))
            let randomTemp = Int(temps[Int(idx)])
            
            self.init ( locationName: randomLocation, currentTemperature: randomTemp, locationZipCode: Int64(randomZip), xCord: randomLocationxCord, yCord: randomLocationyCord)
            
        }
        else{
            
            self.init( locationName: locationNme, currentTemperature: currentTmperature, locationZipCode: locationZpCode, xCord: xCrd, yCord: yCrd)
        }
    }
    
    
     func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(locationName, forKey: "locationName")
        aCoder.encodeObject(currentTemperature, forKey: "currentTemperature")
        aCoder.encodeInt64( locationZipCode, forKey: "locationZip")
        aCoder.encodeObject(itemKey, forKey: "locationImage")
        aCoder.encodeObject(xCord, forKey: "xCord")
        aCoder.encodeObject(yCord, forKey: "yCord")
        
    }
    required init(coder aDecoder: NSCoder){
        locationZipCode = aDecoder.decodeInt64ForKey("locationZip")
        locationName = aDecoder.decodeObjectForKey("locationName") as! String
        currentTemperature = aDecoder.decodeObjectForKey("currentTemperature") as! Int
        itemKey = aDecoder.decodeObjectForKey("locationImage") as! String
        xCord = aDecoder.decodeObjectForKey("xCord") as! Double
        yCord = aDecoder.decodeObjectForKey("yCord") as! Double
        
        super.init()
        
        
    }
    
}
