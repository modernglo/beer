//
//  Beer.swift
//  beers
//
//  Created by Los on 4/9/15.
//  Copyright (c) 2015 Los. All rights reserved.
//

import Foundation
import CoreData

class Beer: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var company: String
    @NSManaged var rating: NSNumber
    @NSManaged var numberRatings: NSNumber
    @NSManaged var type: String

}
