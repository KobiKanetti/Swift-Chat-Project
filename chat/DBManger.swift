//
//  DBManger.swift
//  chat
//
//  Created by kobi on 13/08/2017.
//  Copyright © 2017 Kobi Kanetti. All rights reserved.
//

import Firebase
import JSQMessagesViewController

class DBManager{
    static let manager = DBManager()
    
    let rootRef : DatabaseReference
    let roomsRef : DatabaseReference
    let messageRef : DatabaseReference
    
    init() {
        rootRef = Database.database().reference()
        roomsRef = Database.database().reference().child("rooms")
        messageRef = Database.database().reference().child("messages")
        
    }
    
    func createRoom(with name : String){
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let dict : [String:Any] = [
            "name":name,
            "owner":uid,
            "date":Date().timeIntervalSince1970
        ]
        
        roomsRef.childByAutoId().setValue(dict)
        
    }
    
    func deleteRoom(_ room : Room){
        roomsRef.child(room.id).setValue(nil)
    }
    
    func observeRommAdded(_ completion : @escaping (Room) ->Void){
        roomsRef.observe(.childAdded) { (snapshot : DataSnapshot) in
            guard let value = snapshot.value as? [String:Any] else{
                return
            }
            
            let r = Room(key: snapshot.key, value: value)
            completion(r)

        }
    }
    
    func observeRoomremoved(_ completion : @escaping (String) -> Void){
        roomsRef.observe(.childRemoved) { (snapshot : DataSnapshot) in
            completion(snapshot.key)
        }
        
    }
    
    
    //MARK: - Messages
    
    func createMessage(with text : String, room : Room){
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        let dict : [String:Any] = [
            "sender":uid,
            "date":Date().timeIntervalSince1970,
            "text":text,
            "name":Auth.auth().currentUser?.displayName ?? ""
        ]
        
        messageRef.child(room.id).childByAutoId().setValue(dict)
        
    }
    
    func observeNewMassage(by room : Room, completion : @escaping (JSQMessage) -> Void){
        
        messageRef.child(room.id).observe(.childAdded, with: { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else{
                return
            }
            
            let senderId = dict["sender"] as? String ?? ""
            let name = dict["name"] as? String ?? ""
            let timestamp = dict["date"] as? TimeInterval ?? 0
            let date = Date(timeIntervalSince1970: timestamp)
            let text = dict["text"] as? String ?? ""
            
            guard let msg = JSQMessage(senderId: senderId, senderDisplayName: name, date: date, text: text) else{
                return
            }
            
            completion(msg)
        })
    }
    
}



















