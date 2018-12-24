//
//  TrailerViewController.swift
//  Flix
//
//  Created by Stephon Fonrose on 11/26/18.
//  Copyright © 2018 Stephon Fonrose. All rights reserved.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController {

    @IBOutlet weak var trailerWebView: WKWebView!

    var youtubeURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
        let request = URLRequest(url: youtubeURL!)
        trailerWebView.load(request)
    }
    
    @objc func panGestureRecognizerAction(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        view.frame.origin = translation
        if gesture.state == .ended {
            let velocity = gesture.velocity(in: view)
            if velocity.y >= 500 {
                //dismiss the view
                self.dismiss(animated: true, completion: nil)
            } else {
                //return to original position
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = CGPoint(x: 0,y: 0)
                }
            }
        }
    }
    

    
}
