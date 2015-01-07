//
//  FirstViewController.swift
//  EatYourFeelings
//
//  Created by A. Lynn on 12/6/14.
//  Copyright (c) 2014 Lexie Lynn. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {

    let moods = ["Happy", "Sad", "Angry", "Adventurous", "Hungry", "Romantic", "Stressed"]
    var currentMood: String!
    
    @IBOutlet weak var moodPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        moodPickerView.dataSource = self
        moodPickerView.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return moods.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return moods[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentMood = moods[row]
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {

        //color  and center the label's background
        //based on tutorial: http://codewithchris.com/uipickerview-example/
        var pickerLabel = view as UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            //color the label's background
            let hue = CGFloat(row)/CGFloat(moods.count)
            pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            pickerLabel.textAlignment = .Center
        }
        let titleData = moods[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 26.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle
        
        return pickerLabel
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "GetRecipeSegue" {
        
            let destinationViewController = segue.destinationViewController as RecipeViewController
            //let destinationViewController = (segue.destinationViewController as UINavigationController).topViewController as RecipeViewController
            
            if (currentMood == nil) {
                currentMood = "Happy"
            }
            
            destinationViewController.currentMood = currentMood
            print (destinationViewController.currentMood)
            destinationViewController.navigationItem.leftItemsSupplementBackButton = true
        
    }

 
    }

}

