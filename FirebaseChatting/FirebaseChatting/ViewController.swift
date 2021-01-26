//
//  ViewController.swift
//  FirebaseChatting
//
//  Created by 송종근 on 2021/01/24.
//

import UIKit
import FirebaseUI

class ViewController: UIViewController, FUIAuthDelegate {
    let authUI = FUIAuth.defaultAuthUI()
    // 1. 로그인
    // 2. 채팅방 목록
    // 3. 채팅 화면
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        
        authUI!.delegate = self
        
        let providers: [FUIAuthProvider] = [
          FUIEmailAuth()
        ]
        authUI!.providers = providers
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "chatlistVC") {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true) {
                    print("presenting complete")
                }
            }
        } else {
            print("로그인 안된 상태")
            let authViewController = authUI!.authViewController()
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true, completion: nil)
        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
      // handle user and error as necessary
        print("로그인 후처리")
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "chatlistVC") {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}

