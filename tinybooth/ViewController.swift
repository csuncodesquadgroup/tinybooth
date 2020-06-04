//
//  ViewController.swift
//  tinybooth
//
//  Created by Camrynn Dilley on 6/2/20.
//  Copyright © 2020 codesquad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Functions for capturing image
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPrevieLayer()
        startRunningCaptureSession()
    }
    
    // setting up capture session
    func setupCaptureSession() {
        
    }
    
    // configuring necesary capture devices (camera)
    func setupDevice() {
        
    }
    
    // creating input using capture devices
    func setupInputOutput() {
        
    }
    
    // configuring photo output object to process captured images
    func setupPrevieLayer() {
        
    }
    
    // start running when we have finished configuration
    func startRunningCaptureSession() {
        
    }
    
    // Linked to the camera/shutter button on maine view controller of Main.storyboard (like the initial screen you see when you open up the app
    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
        
        // this opens up the PreviewVieweController when the camera/shutter button is tapped
        performSegue(withIdentifier: "showPhotoSegue", sender: nil)
    }
    
}

