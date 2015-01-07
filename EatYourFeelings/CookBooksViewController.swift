//
//  CookBooksViewController.swift
//  EatYourFeelings
//
//  Created by A. Lynn on 12/7/14.
//  Copyright (c) 2014 Lexie Lynn. All rights reserved.
//

import UIKit
import CoreData

class CookBooksViewController: UITableViewController {
    
    var cookbooks = [CookBook]()
    var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = "My Cookbooks"
        
        let addButton = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "addCookbookButtonTap:")
        self.navigationItem.rightBarButtonItem = addButton
        
        createCookbookWithTitle("Favorites")
        createCookbookWithTitle("To Cook")
        
        fetchCookbooks()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return cookbooks.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cookbookCell", forIndexPath: indexPath) as UITableViewCell
        
        let cookbook = cookbooks[indexPath.row]
        let title = cookbook.title
        cell.textLabel?.text = title
        
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
        let context = self.appDel.managedObjectContext!
        
        // remove your object
        let currCookbook = cookbooks[indexPath.row]
        context.deleteObject(currCookbook)
        
        // save your changes 
        context.save(nil)
        
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
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    
    
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "showCookbook" {
            
            println("selected")
            
            let selectedIndex = tableView.indexPathForSelectedRow()!.row
            
            let selectedCookbook = cookbooks[selectedIndex]
            
            let cookbookViewController = segue.destinationViewController as CookBookViewController
            
            cookbookViewController.cookbook = selectedCookbook
            
        }
        
    }
    
    
    
    
    // MARK: - Actions
    
    @IBAction func addCookbookButtonTap(sender: UIBarButtonItem) {
        
        let createCookbookAlert = UIAlertController(title: "Create Cookbook", message: "Enter the title", preferredStyle: .Alert)
        
        createCookbookAlert.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "Cookbook title"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        createCookbookAlert.addAction(cancelAction)
        
        let createAction = UIAlertAction(title: "Create", style: .Default) { action in
            
            let textField = createCookbookAlert.textFields!.first! as UITextField
            self.createCookbookWithTitle(textField.text)
            
            self.tableView.reloadData()
        }
        
        createCookbookAlert.addAction(createAction)
        
        presentViewController(createCookbookAlert, animated: true, completion: nil)
        
        
    }
    

    func createCookbookWithTitle(title: String) {
        let managedObjectContext = AppDelegate.sharedAppDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("CookBook", inManagedObjectContext: managedObjectContext)
        
        let cookbook = CookBook(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        cookbook.title = title
        // cookbooks.append(cookbook)
        
        var error: NSError?
        let result = managedObjectContext.save(&error)
        if !result {
            println("Could not save \(error)")
        }
        
    }

    
    
    func fetchCookbooks() {
        let managedObjectContext = AppDelegate.sharedAppDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "CookBook")
        
        if let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [CookBook] {
            cookbooks = fetchResults
        }
        
    }
    
    
    




}
