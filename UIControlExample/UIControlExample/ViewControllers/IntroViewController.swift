//
//  ViewController.swift
//  UIControlExample
//
//  Created by 송종근 on 2021/01/10.
//

import UIKit
import SwiftyGif

class IntroViewController: UIViewController {

    
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            let gif = try UIImage(gifName: "intro.gif")
            self.logoImageView.setGifImage(gif, loopCount: -1)
        } catch {
            print(error)
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainViewController") {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
            }
        }
    }

}

