//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Regie Daquioag on 3/12/18.
//  Copyright © 2018 Regie Daquioag. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    
    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!
    
    @IBOutlet weak var arrowImage: UIImageView!
    
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
//    @IBOutlet var pinchGestureRecognizer: UIPinchGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        pinchGestureRecognizer.delegate = self
        trayDownOffset = 160
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    
    @objc func didTapTwice(_ sender: UITapGestureRecognizer){
        var imageView = sender.view as! UIImageView
        imageView.removeFromSuperview()
    }
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            print("Gesture began")
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            print("Gesture is changing")
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            print("Gesture ended")
            if velocity.y > 0 {
                UIView.animate(withDuration:0.004, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                        self.trayView.center = self.trayDown
                }, completion: nil)
                print("flipping time")
                arrowImage.transform = CGAffineTransform(scaleX: 1, y: -1)
            }else {
                UIView.animate(withDuration:0.004, delay: 0, usingSpringWithDamping: 0.09, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayUp
                }, completion: nil)
                arrowImage.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
        
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let imageView = sender.view as! UIImageView
        
        if sender.state == .began {
            print("Face Gesture began")
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
//            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(newlyCreatedFacePan(_:)))
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
//            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(sender:)))
//            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTwice(_:)))
            tapGestureRecognizer.numberOfTapsRequired = 2
            newlyCreatedFace.addGestureRecognizer(tapGestureRecognizer)
        } else if sender.state == .changed {
            print("Face Gesture is changing")
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            print("Face Gesture ended")
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
       
    }
    
    @objc func newlyCreatedFacePan(_ sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            print("Newly Created Face Gesture began")
            newlyCreatedFace = sender.view as! UIImageView // to get the face that we panned on.
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center // so we can offset by translation later.
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            print("Newly Creted Face Gesture ended")
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
//    @IBAction func didPinch(sender: UIPinchGestureRecognizer) {
//        let scale = sender.scale
//        newlyCreatedFace = sender.view as! UIImageView // to get the face that we panned on.
//         newlyCreatedFace.isUserInteractionEnabled = true
//        newlyCreatedFace.transform = CGAffineTransform(scaleX: scale.advanced(by: 1), y:1)
//        sender.scale = 1
//    }
    
}
