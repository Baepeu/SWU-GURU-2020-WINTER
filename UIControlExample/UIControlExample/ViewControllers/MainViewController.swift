//
//  MainViewController.swift
//  UIControlExample
//
//  Created by 송종근 on 2021/01/10.
//

import UIKit
import FMDB
class MainViewController:UIViewController {
    var selectedIndex:Int = 0
    var previousIndex:Int = 0
    
    @IBOutlet var tabBtns: [UIImageView]!
    
    var viewControllers = [UIViewController]()
    
    @IBOutlet weak var btnStackView: UIStackView!
    
    static let firstTabViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "firstTabViewController")
    static let secondTabViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "secondTabViewController")
    static let thirdTabViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "thirdTabViewController")
    static let testViewController = UIStoryboard(name: "WebtoonView", bundle: nil).instantiateViewController(withIdentifier: "testViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for btn in tabBtns {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tabTapped(_:)))
            btn.isUserInteractionEnabled = true
            btn.addGestureRecognizer(tap)
        }
        
        viewControllers.append(MainViewController.firstTabViewController)
        viewControllers.append(MainViewController.secondTabViewController)
        //viewControllers.append(MainViewController.thirdTabViewController)
        viewControllers.append(MainViewController.testViewController)
        
        tabTapped(tabBtns[0].gestureRecognizers![0] as! UITapGestureRecognizer)
    }
    
    @objc func tabTapped(_ sender:UITapGestureRecognizer) {
        print("tapped")
        if let tag = sender.view?.tag {
            previousIndex = selectedIndex
            selectedIndex = tag
            
            // 화면 갈아끼기
            let previousVC = viewControllers[previousIndex]
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
            
            let currentVC = viewControllers[selectedIndex]
            currentVC.view.frame = UIApplication.shared.windows[0].frame
            currentVC.didMove(toParent: self)
            self.addChild(currentVC)
            self.view.addSubview(currentVC.view)
            self.view.bringSubviewToFront(btnStackView)
        }
    }
    
    
}
