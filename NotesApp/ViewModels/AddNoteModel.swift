//
//  AddNoteModel.swift
//  NotesApp
//
//  Created by SIVA on 20/03/21.
//

import UIKit
import AVFoundation
import CoreData

class AddNoteModel: NSObject {

    var arrayOfNotesList : [NotesList_Base] = []
    var newNote : NotesList_Base?
    var stringPathProfilePicture : String = ""

    func getListFromDB() {
        let fetchRequest : NSFetchRequest<NotesAppApi> = NotesAppApi.fetchRequest()
        do {
            let result = try coreDataManager.sharedInstance.context().fetch(fetchRequest)
            print(result as [NSManagedObject])
            for data in result as [NSManagedObject] {
                if data.value(forKey: "notesAppApi") != nil {
                    let response : Data = data.value(forKey: "notesAppApi")! as! Data
                    self.arrayOfNotesList = try! JSONDecoder().decode([NotesList_Base].self,from: response)
                    
                }
            }
        }
        catch{}
    }
    
    func saveNote(_ title : String, body : String, completion:@escaping (Bool) -> Void) {
        
        var noteDetail : NotesList_Base = self.arrayOfNotesList[0]
        noteDetail.id = "\(self.arrayOfNotesList.count + 1)"
        noteDetail.title = title
        noteDetail.body = body
        noteDetail.time = "\(Date().millisecondsSince1970)"
        noteDetail.image = stringPathProfilePicture
        noteDetail.isLocal = true
        self.arrayOfNotesList.append(noteDetail)
        
        let encodedData = try? JSONEncoder().encode(arrayOfNotesList)
        let jsonString = String(data: encodedData!,
                                encoding: .utf8)
        if let data = jsonString!.data(using: String.Encoding.utf8) {
            self.saveReportListInDB(date: data) { (status) in
                if(status){
                    completion(true)
                }
            }
        }
//
    }
    func saveReportListInDB(date : Data, completion:@escaping (Bool) -> Void) {
        let fetchRequest : NSFetchRequest<NotesAppApi> = NotesAppApi.fetchRequest()
        do {
            let result = try coreDataManager.sharedInstance.context().fetch(fetchRequest)
            print(result as [NSManagedObject])
            // Fetching the Data From Api and saving in Core Data :-
            if(result.count != 0){
                result[0].setValue(date as NSData, forKey: "notesAppApi")
                coreDataManager.sharedInstance.saveContext()
                completion(true)
            }
            else {
                let person = NotesAppApi(context: coreDataManager.sharedInstance.context())
                person.setValue(date, forKey: "notesAppApi")
                coreDataManager.sharedInstance.saveContext()
                completion(true)
            }
        }catch{
            completion(false)
        }
    }
    
    func saveImage(croppedImage: UIImage) {
        let oeiginalimageData = croppedImage.pngData()
        let resizedImageData = self.resizeAttachmentImage(UIImage(data: oeiginalimageData!)!)
        let someDate = Date()
        let timeStamp : Int = Int(someDate.timeIntervalSince1970)
        let uploadPhoto : NSString = String(format:"note_pic_%d.png", timeStamp) as NSString
        let folderURL = createFolder(folderName: "note_pic",uploadPhoto: uploadPhoto as String)!
        try? resizedImageData.write(to: folderURL, options: .atomic)
        self.stringPathProfilePicture = folderURL.path
    }
    
    func resizeAttachmentImage(_ image: UIImage) -> NSData {
        let actualHeight: Float = Float(image.size.height)
        let actualWidth: Float = Float(image.size.width)
        let compressionQuality: Float = 0.4
        //50 percent compression
        let rect = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        let imageData: Data? = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return imageData! as NSData
    }

    func createFolder(folderName: String,uploadPhoto: String) -> URL? {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first {
            // Construct a URL with desired folder name
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            // If folder URL does not exist, create it
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    // Attempt to create folder
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    // Creation failed. Print error & return nil
                    print(error.localizedDescription)
                    return nil
                }
            }
            let fileURL = folderURL.appendingPathComponent(uploadPhoto)
            // Folder either exists, or was created. Return URL
            return fileURL
        }
        // Will only be called if document directory not found
        return nil
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
