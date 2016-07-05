//
//  LocationCell.swift
//  WeatherTracker
//
//  Created by Eric Dockery.
//  Copyright © 2016 Eric Dockery. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell{
    @IBOutlet var locationNameLabel :UILabel!
    @IBOutlet var locationZipLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    
    func updateLabels(){
        let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        locationNameLabel.font = bodyFont
        temperatureLabel.font = bodyFont
        let caption1Font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        locationZipLabel.font = caption1Font
    }
    
}
