//
//  ChatListViewController.swift
//  FirebaseChatting
//
//  Created by 송종근 on 2021/01/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatListViewController:UIViewController {
    var chat_room_list = [QueryDocumentSnapshot]()
    let db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        db.collection("chattings").getDocuments { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.chat_room_list = [QueryDocumentSnapshot]()
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    self.chat_room_list.append(document)
                }
                self.tableView.reloadData()
            }
        }
        
        db.collection("chattings").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            if let snapshot = snapshot {
                for change in snapshot.documentChanges {
                    let docID = change.document.documentID
                    let document = change.document
                    if self.isNews(document) {
                        self.chat_room_list.append(document)
                        self.tableView.insertRows(at: [IndexPath(row: self.chat_room_list.count-1, section: 0)], with: .left)
                    }
                }
            }
        }
    }
    
    func isNews(_ doc:QueryDocumentSnapshot) -> Bool {
        for chat_room in chat_room_list {
            if chat_room.documentID == doc.documentID {
                return false
            }
        }
        return true
    }
    
    @IBAction func signout(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            print("sign out")
            self.dismiss(animated: true, completion: nil)
        } catch {
            
        }
    }
    
    @IBAction func makeChatRoom(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(title: "New Chat", message: "Enter your chat room name", preferredStyle: .alert)
        
        alertVC.addTextField { (textfield) in
            textfield.placeholder = "room name"
        }
        
        let action_cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(action_cancel)
        
        let action_ok = UIAlertAction(title: "OK", style: .default) { (action) in
            if let textFields = alertVC.textFields, let textField = textFields.first {
                // Todo : 채팅룸이 새로 추가되면 파이어 스토어에 저장
                // 채팅방 이름 : textField.text
                // 채팅방 id
                print(textField.text)
                self.addChatRoom(textField.text!)
            }
        }
        alertVC.addAction(action_ok)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func addChatRoom(_ room_name:String) {
        var ref: DocumentReference? = nil
        ref = db.collection("chattings").document()
        ref?.setData(["name":room_name,"members":[]]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
}


extension ChatListViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.chat_room_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatRoomCell") as! UITableViewCell
        
        let document = chat_room_list[indexPath.row]
        let data = document.data()
        cell.textLabel!.text = data["name"] as! String

        return cell
    }
}

extension ChatListViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "chatRoomVC") as? ChattingViewController {
            print("enter room")
            vc.modalPresentationStyle = .fullScreen
            vc.chat_room_id = chat_room_list[indexPath.row].documentID
            self.present(vc, animated: true, completion: nil)
        }
    }
}
