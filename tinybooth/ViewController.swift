//
//  ViewController.swift
//  tinybooth
//
//  Created by Camrynn Dilley on 6/2/20.
//  Copyright © 2020 codesquad. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?            //  represents back camera
    var frontCamera: AVCaptureDevice?           // represents front camera
    var currentCamera: AVCaptureDevice?         // represents current camera - should be set to front camera for photobooth
    var photoOutput: AVCapturePhotoOutput?      // the output/photo
    
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
        
        // we  use  the session preset property on caprute session to specificy image  quality and resolution we want
        captureSession.sessionPreset  =  AVCaptureSession.Preset.photo // we use this to get a  full resolution photo
        
    }
    
    // configuring necesary capture devices (camera)
    func setupDevice() {
        
        //we  create this to represent the iOS decive's  camerea
        let deviceDiscoverySession =  AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let  devices = deviceDiscoverySession.devices
        
        // figuring out if the camera is currently set to front or back facing camera
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device;
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device;
            }
        }
        
        // setting the camera view to the front facing camera
        currentCamera = frontCamera;
        
    }
    
    // creating input using capture devices
    func setupInputOutput() {
        // take  capeture devices and connect to cpature session
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!); // capturting data from device to add to capture session
            captureSession.addInput(captureDeviceInput);
            photoOutput = AVCapturePhotoOutput();
            
//            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil);
//            captureSession.addOutput(photoOutput!);
            
        } catch {
            print(error);
        }
        
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

