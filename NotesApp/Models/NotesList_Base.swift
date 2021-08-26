//
//  NotesList_Base.swift
//  NotesApp
//
//  Created by SIVA on 20/03/21.
//

import Foundation
struct NotesList_Base : Codable {
    var id : String?
    var title : String?
    var body : String?
    var time : String?
	var image : String!
    var isLocal : Bool!

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case title = "title"
		case body = "body"
		case time = "time"
		case image = "image"
        case isLocal = "isLocal"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		body = try values.decodeIfPresent(String.self, forKey: .body)
		time = try values.decodeIfPresent(String.self, forKey: .time)
		image = try values.decodeIfPresent(String.self, forKey: .image)
        if(image == nil){
            image = ""
        }
        isLocal = try values.decodeIfPresent(Bool.self, forKey: .isLocal)
        if(isLocal == nil){
            isLocal = false
        }
	}

}
