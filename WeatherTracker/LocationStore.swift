//
//  LocationStore.swift
//  WeatherTracker
//
//  Created by Eric Dockery.
//  Copyright © 2016 Eric Dockery. All rights reserved.
//

import UIKit

class LocationStore{
    var allLocations = [Location]()
    init() {
        if let archivedLocations = NSKeyedUnarchiver.unarchiveObjectWithFile(itemArchiveURL.path!) as? [Location]{
            allLocations += archivedLocations
        }
    }
    let itemArchiveURL: NSURL = {
        let documentDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.URLByAppendingPathComponent("locations.archive")
    }()
    
     func saveChanges() -> Bool{
        return NSKeyedArchiver.archiveRootObject(allLocations, toFile: itemArchiveURL.path!)
    }
    
     func createLocation(random: Bool, location: String, currentTemp: Int, zipCode: Int64, xCord: Double, yCord: Double ) -> Location{
        if !random{
            
            let newLocation = Location(random: false, locationNme: location, currentTmperature: currentTemp, locationZpCode: zipCode, xCrd: xCord, yCrd: yCord)
            allLocations.append(newLocation)
            return newLocation
            
        }
        
        
        let newLocation = Location(random: true, locationNme: location, currentTmperature: currentTemp, locationZpCode: zipCode, xCrd: xCord, yCrd: yCord)
        allLocations.append(newLocation)
        
        return newLocation
    }
    
     func removeLocation(location: Location){
        if let index = allLocations.indexOf(location){
            allLocations.removeAtIndex(index)
        }
    }
    func moveLocationAtIndex(fromIndex: Int, toIndex: Int){
        if fromIndex == toIndex{
            return
        }
        let movedLocation = allLocations[fromIndex]
        allLocations.removeAtIndex(fromIndex)
        allLocations.insert(movedLocation, atIndex: toIndex)
    }
    
    
}
