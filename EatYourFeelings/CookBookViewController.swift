//
//  CookBookViewController.swift
//  EatYourFeelings
//
//  Created by A. Lynn on 12/7/14.
//  Copyright (c) 2014 Lexie Lynn. All rights reserved.
//

import UIKit
import CoreData

class CookBookViewController: UITableViewController {
    
    var cookbook: CookBook!
    var recipes = [Recipe]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self-sizing table view cells
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        fetchRecipes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return recipes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as RecipeCell

        let currRecipe = recipes[indexPath.row] as Recipe
        
        cell.recipeTitleTextLabel.text = currRecipe.title
        

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let managedObjectContext = AppDelegate.sharedAppDelegate.managedObjectContext!
            managedObjectContext.deleteObject(recipes[indexPath.row])
            
            recipes.removeAtIndex(indexPath.row)
            AppDelegate.sharedAppDelegate.saveContext()
            
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions
    
    

    
    func fetchRecipes() {
        // Need managed object context to manipulate/fetch anything from core data
        let managedObjectContext = AppDelegate.sharedAppDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Recipe")
        
        fetchRequest.predicate = NSPredicate(format: "cookbook == %@", cookbook)    // %@ replaced with identifier of currrent notebook
        
        let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [Recipe]
        recipes = fetchResults!
        print(recipes)
        
        if recipes.count == 0 {
        
            let noRecipesAlert = UIAlertController(title: "No Recipes Yet", message: "Search for recipes to add to cookbook!", preferredStyle: .Alert)
            
            
            let okAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            noRecipesAlert.addAction(okAction)
            
            presentViewController(noRecipesAlert, animated: true, completion: nil)

            
        }
        
        
    }

    
    

}
