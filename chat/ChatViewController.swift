//
//  ChatViewController.swift
//  chat
//
//  Created by kobi on 16/08/2017.
//  Copyright © 2017 Kobi Kanetti. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class ChatViewController: JSQMessagesViewController {
    
    var room : Room!
    let outgoingBbble : JSQMessagesBubbleImage
    let incomingBubble : JSQMessagesBubbleImage
    
    required init?(coder aDecoder: NSCoder) {
        
        let factory = JSQMessagesBubbleImageFactory()!
        outgoingBbble = factory.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        incomingBubble = factory.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        
        super.init(coder: aDecoder)
        
    }
    
    deinit {
        DBManager.manager.messageRef.child(room.id).removeAllObservers()
    }
    
    var messages : [JSQMessage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = Auth.auth().currentUser?.uid
        self.senderDisplayName = Auth.auth().currentUser?.displayName ?? "foo"
        
        self.title = room.name
        
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = .zero
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = .zero
        
        
        DBManager.manager.observeNewMassage(by: room) { (msg) in
            // add new message to array
            self.messages.append(msg)
            
            let isOutgoing = msg.senderId == self.senderId
            
            if isOutgoing{
            // refresh ui
            self.finishSendingMessage()
                
            // make sound
            JSQSystemSoundPlayer.jsq_playMessageSentSound()
                
            } else {
                // refresh ui
                self.finishReceivingMessage()
                
                //make sound
                JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
            }
            
            
        }

    }
    

    // MARK: = Messages Maintenance
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        guard let text = text, !text.isEmpty else {
            return
        }
        
        DBManager.manager.createMessage(with: text, room: room)
        
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        // TODO : - implement send image
    }
    
    // MARK: - CollectionsView Maintaince
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        if messages[indexPath.item].senderId == self.senderId{
            return outgoingBbble
        } else {
            return incomingBubble
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        guard let name = messages[indexPath.item].senderDisplayName, !name.isEmpty else{
            return nil
        }
        
        return NSAttributedString(string: name)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        
        guard let name = messages[indexPath.item].senderDisplayName, !name.isEmpty else {
            return 0
        }
        
        return 17
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        let msg = messages[indexPath.item]
        let date = msg.date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let str = formatter.string(from: date!)
        
        return NSAttributedString(string: str)
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        
        return 17
    }

}
