//
//  ViewModel.swift
//  NotesApp
//
//  Created by SIVA on 20/03/21.
//

import UIKit
import AVFoundation
import CoreData

class ViewModel: NSObject {

    var arrayOfNotesList : [NotesList_Base] = []
    var arrayOfColor : [UIColor] = [#colorLiteral(red: 0.9869286418, green: 0.6550518274, blue: 0.5444437861, alpha: 1), #colorLiteral(red: 0.9917448163, green: 0.7972089648, blue: 0.4477511048, alpha: 1), #colorLiteral(red: 0.889524281, green: 0.9411302209, blue: 0.559184432, alpha: 1), #colorLiteral(red: 0.3574823737, green: 0.8837739229, blue: 0.9239861369, alpha: 1), #colorLiteral(red: 0.8544386029, green: 0.5569131374, blue: 0.8719087243, alpha: 1), #colorLiteral(red: 0.4014897048, green: 0.8068051934, blue: 0.767375052, alpha: 1), #colorLiteral(red: 0.9836465716, green: 0.5346537232, blue: 0.6988064647, alpha: 1)]
    var index : Int = 0
    
    func fetchNotesList(_ completion:@escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            APIManager.shared.fetchAPIDetails { [weak self] (response, error) in
                if(error == nil){
                    DispatchQueue.main.async {
                        self!.saveReportListInDB(date: response) { (status) in
                            self!.getListFromDB { (status) in
                                completion(true)
                            }
                        }
                    }
                }
            }
        }
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
    
    func getListFromDB(completion:@escaping (Bool) -> Void) {
        let fetchRequest : NSFetchRequest<NotesAppApi> = NotesAppApi.fetchRequest()
        do {
            let result = try coreDataManager.sharedInstance.context().fetch(fetchRequest)
            print(result as [NSManagedObject])
            for data in result as [NSManagedObject] {
                if data.value(forKey: "notesAppApi") != nil {
                    let response : Data = data.value(forKey: "notesAppApi")! as! Data
                    self.arrayOfNotesList = try! JSONDecoder().decode([NotesList_Base].self,from: response)
                    self.index = 0
                    DispatchQueue.main.async {
                        completion(true)
                    }
                }
            }
        }
        catch{
            completion(false)
        }
    }

    func getHeight(label : UILabel)-> CGFloat {
      let font = label.font ?? UIFont.preferredFont(forTextStyle: .body)
      let text = label.text ?? ""
      let width = (((UIScreen.main.bounds.width - 50) / 2) - 20)//self.view.bounds.size.width - 35
      let size = CGSize(width: width, height: .greatestFiniteMagnitude)
      let options: NSStringDrawingOptions = label.numberOfLines == 1 ? [.usesFontLeading]
          : [.usesLineFragmentOrigin, .usesFontLeading]
      let height = text.boundingRect(with: size, options: options,
                                     attributes: [.font: font], context: nil).height
      return height
    }

}
