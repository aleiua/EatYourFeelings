//
//  Recipe.swift
//  EatYourFeelings
//
//  Created by A. Lynn on 12/13/14.
//  Copyright (c) 2014 Lexie Lynn. All rights reserved.
//

import Foundation
import CoreData

class Recipe: NSManagedObject {
    
    @NSManaged var title: String
    @NSManaged var imageURL: String
    @NSManaged var recipeURL: String
    @NSManaged var time: String
    @NSManaged var servings: String
    @NSManaged var ingredients: [String]
    
    @NSManaged var cookbook: CookBook
    
    
}