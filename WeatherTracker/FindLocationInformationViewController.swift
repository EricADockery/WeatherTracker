//
//  FindLocationInformationViewController.swift
//  WeatherTracker
//
//  Created by Eric Dockery.
//  Copyright © 2016 Eric Dockery. All rights reserved.
//

import UIKit

class FindLocationInformationViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate{
    @IBOutlet weak var enteredZipCode: UILabel!
    @IBOutlet weak var locationField: UILabel!
    @IBOutlet weak var temperatureField: UILabel!
    @IBOutlet var imageView: UIImageView!
    var location: Location! {
        didSet {
            navigationItem.title = location.locationName
        }
    }
    var imageStore: ImageStore!
    

    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    //MARK: Image manipulation and usage
    @IBAction func takePhoto(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            imagePicker.sourceType = .Camera
        }
        else {
            imagePicker.sourceType = .PhotoLibrary
        }
        
        imagePicker.delegate = self
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageStore.setImage(image, forKey: location.itemKey)
        imageView.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
        
    //MARK: Formatting The Details of the view
    
    private let numberFormatterTemp: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    
    //MARK: editting the appearance and disappearnce of the view
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        
    }
    //MARK: - Configuring the views Appearance on Load
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        enteredZipCode.text = "\(location.locationZipCode)"
        locationField.text = location.locationName
        temperatureField.text = numberFormatterTemp.stringFromNumber(location.currentTemperature)
        let key = location.itemKey
        let imageToDisplay = imageStore.imageForKey(key)
        imageView.image = imageToDisplay
        
    }
    //MARK: resign the keyboard
    func textFieldShouldReturn( textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //MARK: mapView Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMap"{
            let mapView = segue.destinationViewController as! MapViewController
                mapView.location = location
            
        }
    }

}
