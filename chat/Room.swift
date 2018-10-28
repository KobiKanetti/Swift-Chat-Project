//
//  Room.swift
//  chat
//
//  Created by kobi on 13/08/2017.
//  Copyright © 2017 Kobi Kanetti. All rights reserved.
//

import Firebase

extension Date{
    var toString : String{
        get{
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            formatter.doesRelativeDateFormatting = true
            
            return formatter.string(from: self)
        }
    }
}

class Room{
    let id : String
    let name : String?
    let owner : String?
    let date : Date?
    

    
    init(key : String, value : [String:Any]) {
        self.id = key
        self.name = value["name"] as? String
        self.owner = value["owner"] as? String
        
        if let timestamp = value["date"] as? TimeInterval{
            self.date = Date(timeIntervalSince1970: timestamp)
        } else {
            self.date = nil
        }
    }
    
        
}
