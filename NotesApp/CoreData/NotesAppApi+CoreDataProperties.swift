//
//  NotesAppApi+CoreDataProperties.swift
//  NotesApp
//
//  Created by SIVA on 20/03/21.
//

import Foundation
import CoreData


extension NotesAppApi {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotesAppApi> {
        return NSFetchRequest<NotesAppApi>(entityName: "NotesAppApi")
    }
    @NSManaged public var notesAppApi: NSData?
    
}
