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
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?

    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Functions for capturing image
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    
    // setting up capture session
    func setupCaptureSession() {
        
        // we  use  the session preset property on capture session to specificy image  quality and resolution we want
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
        
        do {

            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!); // capturting data from device to add to capture session
            captureSession.addInput(captureDeviceInput);
            photoOutput = AVCapturePhotoOutput();

            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil);
            captureSession.addOutput(photoOutput!);

        } catch {
            print(error);
        }
        
    }
    
    // configuring photo output object to process captured images
    // this is the camera  preview that shows on the screen
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    
    }
    
    // start running when we have finished configuration
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    // Linked to the camera/shutter button on maine view controller of Main.storyboard (like the initial screen you see when you open up the app
    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
        
        // capturing still image
        let settings = AVCapturePhotoSettings();
        photoOutput?.capturePhoto(with: settings, delegate: self);
        
        print("camera button pressed");
        
        // this opens up the PreviewVieweController when the camera/shutter button is tapped
        // performSegue(withIdentifier: "showPhotoSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotoSegue" {
            let previewVC = segue.destination as! PreviewViewController
            previewVC.image = self.image
            
            print("image in prepare function is ");
            print(image);
        }
    }
    
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            print(imageData);
            image = UIImage(data: imageData);
            
            print("image in ViewController is ");
            print(image);
            print(imageData);
            
            performSegue(withIdentifier: "showPhotoSegue", sender: nil);
            

        }
    }
}

