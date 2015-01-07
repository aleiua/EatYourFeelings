//
//  RecipeViewController.swift
//  EatYourFeelings
//
//  Created by A. Lynn on 12/6/14.
//  Copyright (c) 2014 Lexie Lynn. All rights reserved.
//

import UIKit
import CoreData

class RecipeViewController: UITableViewController {
    
    var currentMood: String!
    var urlSession: NSURLSession!
    var secondUrlSession: NSURLSession!
    var initialRecipeData: NSDictionary!
    var recipeDetails: NSDictionary!
    var ingredients: [String]!
    var recipeUrl: NSURL!
    var imageUrl: String!

    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
//    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        urlSession = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        secondUrlSession = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let saveButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "saveRecipeButtonTap:")
        self.navigationItem.rightBarButtonItem = saveButton
        
        if currentMood != nil {
            findRecipe()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        ingredientsTextView.text = ingredients[0]
//
//        self.recipeTitle.text = title
//        
//        let time = recipeDetails["totalTime"] as String
//        self.timeLabel.text = time
//        
//        let servings = recipeDetails["yield"] as String
//        self.servingsLabel.text = servings
//        
//        let sourceDict = recipeDetails["source"] as NSDictionary
//        let recipeUrl = sourceDict["sourceRecipeUrl"] as String
//
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 1
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 6
//    }
//    
    
    //////////////////////////////////////////
    // "Algorithm" that returns food corresponding to each each mood
    //////////////////////////////////////////

    
    func convertMoodtoFood(currentMood: String) -> String {
        
        let food = "chocolate"
        
        return food
    }
    
    
    //////////////////////////////////////////
    // Parse response and assign attributes    
    //////////////////////////////////////////
    
    func parseRecipe() {
        
        if self.recipeDetails != nil {
            if let imageDict = self.recipeDetails["images"] as? [NSDictionary] {
                imageUrl = imageDict[0]["hostedLargeUrl"] as String
                let image = UIImage(data: NSData(contentsOfURL: NSURL(string:imageUrl)!)!)
                self.recipeImageView.image = image
                
            }
            
            
            ingredients = recipeDetails["ingredientLines"] as [String]
            var ingredString: String = ""

            for ingredient in ingredients {
                
                ingredString = ingredString + ingredient + "\n"
            }
            
            self.ingredientsTextView.text = ingredString
            
            let title = recipeDetails["name"] as String
            self.recipeTitle.text = title
            
            if let time = recipeDetails["totalTime"] as? String {
                self.timeLabel.text = time
            } else {
                self.timeLabel.text = "Unknown"
            }
            
            if let servings = recipeDetails["yield"] as? String {
                self.servingsLabel.text = servings
            } else {
                self.servingsLabel.text = "Unknown"
            }
                
            let sourceDict = recipeDetails["source"] as NSDictionary
            let recipeUrlString = sourceDict["sourceRecipeUrl"] as String
            recipeUrl = NSURL(string: recipeUrlString)
            
            
        }
    }
    
    
    //////////////////////////////////////////
    // Look up details of chosen recipe
    //////////////////////////////////////////
    func getRecipe() {
        
        if let matchDict = initialRecipeData["matches"] as? [NSDictionary] {
        
            let recipeID = matchDict[0]["id"] as String
            
            print(matchDict[0]["id"])
            let escapedID = recipeID.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)

            
           // http://api.yummly.com/v1/api/recipe/recipe-id?_app_id=YOUR_ID&_app_key=YOUR_APP_KEY
            
            let url = NSURL(string: "http://api.yummly.com/v1/api/recipe/" + escapedID! + "?_app_id=0e24db70&_app_key=205297c4cf249101b322de02c993ceba")
            
            println(url)

            let dataTask = secondUrlSession.dataTaskWithURL(url!, completionHandler: {data, response, error in
                
                let responseStr = NSString(data: data, encoding: NSUTF8StringEncoding)

                println(responseStr)
                
                if let recipeDeets = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
                    println("got dem recipe deets")
                    self.recipeDetails = recipeDeets as NSDictionary
                }
                
                self.parseRecipe()
            })
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            dataTask.resume()

        }
        
    }



    //////////////////////////////////////////
    // Search for a recipe
    //////////////////////////////////////////
    
    func findRecipe() {
        
        var food = convertMoodtoFood(currentMood)
        var escapedFood = food.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        var pagination = String(arc4random_uniform(50))
        print(pagination)
        
        var escapedPagination = pagination.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        
        let url = NSURL(string: "http://api.yummly.com/v1/api/recipes?_app_id=0e24db70&_app_key=c9c395f0c9b38a94d5f6deb2b69c674c&maxResult=1&start=" + escapedPagination! + "&allowedIngredient[]=" + escapedFood!)
        
        print(url)
        
        let dataTask = urlSession.dataTaskWithURL(url!, completionHandler: {data, response, error in
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            print(responseString)
            
            if let recipeData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
                print("in da if")
                self.initialRecipeData = recipeData as NSDictionary
            } else {
                
                print("uh-oh")
            }
            
            self.getRecipe()
            
            
        })
        dataTask.resume()
        
    }
    
    
    func saveRecipeButtonTap(sender: UIBarButtonItem) {
        
        
        let whichCookbookAlert = UIAlertController(title: "Which cookbook?", message: "Enter the name of the already existing cookbook you'd like to save this recipe to.", preferredStyle: .Alert)
        
        whichCookbookAlert.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "Exact cookbook name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        whichCookbookAlert.addAction(cancelAction)
        
        let createAction = UIAlertAction(title: "Save", style: .Default) { action in
            
            let textField = whichCookbookAlert.textFields!.first! as UITextField
            self.createRecipeWithContent(textField.text)
            
            self.tableView.reloadData()
        }
        
        whichCookbookAlert.addAction(createAction)
        
        presentViewController(whichCookbookAlert, animated: true, completion: nil)
        
    }
    
    

    func createRecipeWithContent(cookbookName: String) {
    
        let managedObjectContext = AppDelegate.sharedAppDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Recipe", inManagedObjectContext: managedObjectContext)
        
        let recipe = Recipe(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        let stringUrl = String(contentsOfURL: recipeUrl)
        
        let fetchRequest = NSFetchRequest(entityName: "CookBook")
        println(cookbookName)
        
        fetchRequest.predicate = NSPredicate(format: "title = %@", cookbookName)
        let fetchResult = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as [CookBook]
        
        let cookbook = fetchResult
        
        recipe.cookbook = fetchResult[0] as CookBook
        
        recipe.title = title! as String
        recipe.servings = self.servingsLabel.text! as String
        recipe.imageURL = self.imageUrl as String
        recipe.recipeURL = stringUrl!
        recipe.time = self.timeLabel.text! as String
        recipe.ingredients = self.ingredients as [String]

        
        
        AppDelegate.sharedAppDelegate.saveContext()
        
        
    }
    


/*

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "webSegue" {
            
            let destinationViewController = segue.destinationViewController as WebViewController
            //let destinationViewController = (segue.destinationViewController as UINavigationController).topViewController as RecipeViewController
            
            if (recipeUrl != nil) {
                destinationViewController.url = recipeUrl
                print(destinationViewController.url)
                
            }
            
            destinationViewController.navigationItem.leftItemsSupplementBackButton = true
        
        }
    }
    
    
}

