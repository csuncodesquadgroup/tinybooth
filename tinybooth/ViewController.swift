//
//  ViewController.swift
//  tinybooth
//
//  Created by Camrynn Dilley on 6/2/20.
//  Copyright © 2020 codesquad. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, PreviewDelegate {
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?            //  represents back camera
    var frontCamera: AVCaptureDevice?           // represents front camera
    var currentCamera: AVCaptureDevice?         // represents current camera - should be set to front camera for photobooth
    var photoOutput: AVCapturePhotoOutput?      // the output/photo
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer!
    public var sessionInProgress = false;
    
    
    @IBOutlet weak var bottomBorder_HeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var countDownBox: UIView!
    @IBOutlet weak var countDownText: UILabel!
    
    @IBOutlet weak var viewFinder: UIView!
    
    
    @IBOutlet weak var bottomBorder: UILabel!
    @IBOutlet weak var topBorder: UIView!
    
    
    var image: UIImage?
    var fileNames: [String] = [];
    
    var sound: AVAudioPlayer?                   // timer sound
    var takingPhotos = false;                   // for button display
    var photoStripImage:  UIImage?
    let sillyMessages =  ["Smile!", "Cheese!", "Work it!", "Cute!", "Perfect!", "Pose!", "Adorable!", "That's  Great!", "\u{1F60E}"];
    


    @IBOutlet weak var startButton: UIButton!;  // part of camera button, going to be used to turn button into timer
    var timer = Timer()                         // timer variable for timer
    var seconds = 3                             // countdown time for timer
    @IBOutlet weak var displayMessage: UILabel!

    @IBOutlet weak var flashButton: UIButton!   //connects flash button
    var flashToggleOn: Bool = false;            //sets flash default to off
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Functions for capturing image
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
  

        super.viewDidLoad();
        
         let path = Bundle.main.path(forResource: "countdownSound_1.mp3", ofType:nil)!
         let url = URL(fileURLWithPath: path);
        do {
            sound = try AVAudioPlayer(contentsOf: url);
            sound?.numberOfLoops = 1;
            sound?.play()
            sound?.stop()
        } catch {
            // couldn't load file :(
        }
        

        startButton.layer.zPosition = 100;
        startButton.layer.cornerRadius = self.view.frame.height * 0.055 ;
        let fontSize = self.view.frame.width * 0.05 ;
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        startButton.clipsToBounds = true;
        displayMessage.font = displayMessage.font.withSize(fontSize)
        displayMessage.isHidden = true;
        
        let modelName = UIDevice.modelName
        if (modelName  ==  "iPad Air 2") {
            flashButton.isHidden = true;
        }
        
        
        view.bringSubviewToFront(startButton)
        viewFinder.layer.zPosition = -100;
        
        if (modelName == "iPhone 8") {
            bottomBorder_HeightConstraint.constant = 100
            startButton.layer.cornerRadius = self.view.frame.height * 0.065
        } else if (modelName == "iPhone 11") {
            bottomBorder_HeightConstraint.constant = 260
        } else if modelName.contains("7") {
            bottomBorder_HeightConstraint.constant = 100
            startButton.layer.cornerRadius = self.view.frame.height * 0.065
        } else if modelName.contains("6") {
            bottomBorder_HeightConstraint.constant = 100
            startButton.layer.cornerRadius = self.view.frame.height * 0.065
        }


        
        if modelName.contains("8") {
            countDownBox.frame.size.height = UIScreen.main.bounds.height - bottomBorder.frame.size.height
        } else if modelName.contains("7") {
            countDownBox.frame.size.height = UIScreen.main.bounds.height - bottomBorder.frame.size.height
        } else if modelName.contains("6") {
            countDownBox.frame.size.height = UIScreen.main.bounds.height - bottomBorder.frame.size.height
        } else if modelName.contains("iPad Pro (12") {
            countDownText.font = countDownText.font.withSize(200)
            countDownBox.frame.size.height = UIScreen.main.bounds.height - bottomBorder.frame.size.height*1.5
        } else if modelName.contains("iPad") {
            countDownText.font = countDownText.font.withSize(200)
            countDownBox.frame.size.height = UIScreen.main.bounds.height - bottomBorder.frame.size.height*1.2
        } else {
            countDownBox.frame.size.height = UIScreen.main.bounds.height - bottomBorder.frame.size.height - topBorder.frame.size.height
        }

        countDownBox.isHidden = true
        
          // when app enters background event, trigger notification and exit app
             let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        startButton.setTitle("Start", for:UIControl.State.normal);
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
        viewFinder.layer.addSublayer(cameraPreviewLayer!)

       

        
        captureSession.startRunning()
        DispatchQueue.main.async {
            self.cameraPreviewLayer.frame = self.viewFinder.bounds


        }
    }
    

    @IBAction func helpButton_TouchUpInside(_ sender: Any) {
        
        performSegue(withIdentifier: "showHelpSegue", sender: nil);
        
    }
    

    
    // Linked to the camera/shutter button on maine view controller of Main.storyboard (like the initial screen you see when you open up the app
    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
        
        sessionInProgress = true;
        
        if (takingPhotos) {
            return;
        }
        
        
        
        takingPhotos = true;
        var count = 4;
        var photosTaken = 0;
        fileNames = [];
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (t) in
        
            if let s = self {
                s.startButton.isHidden = true;
                s.displayMessage.isHidden = true;
                s.countDownBox.isHidden = false
                count = count - 1;
                if (count < 1) {
                    s.takePhoto();
                    count = 4;
                    photosTaken = photosTaken + 1;
                    if (photosTaken == 4) {
                        t.invalidate();
                        s.countDownBox.isHidden = true;
                        s.displayMessage.text = "All done!"
                        s.sessionInProgress = false
                        self?.takingPhotos = false;
                        self?.startButton.backgroundColor = UIColor.green
                    }
                    
                } else {
                    self?.sound?.play();
                   
                    s.countDownText.text = String(count);
                }
            }
        });
    }
    

    @IBAction func flashButton_TouchUpInside(_ sender: Any) {
        flashToggleOn.toggle()
        if (flashToggleOn) {
            
            flashButton.setImage(UIImage(systemName: "bolt.fill"),
                                 for: .normal)
        } else {
            flashButton.setImage(UIImage(systemName:"bolt.slash.fill"),
                                 for: .normal)
        }

    }
    

    func takePhoto() {
        
        //performSegue(withIdentifier: "showTimer_Segue", sender: nil)
        countDownBox.isHidden = true
        let settings = AVCapturePhotoSettings();
        
            if (flashToggleOn) {
            settings.flashMode = AVCaptureDevice.FlashMode.on
            } else {
                settings.flashMode = AVCaptureDevice.FlashMode.off
            }
    
 
        //  make  a separate function with flashToggledOn = !flashToggledOn inside and call that when the user presses the flash button
        
        photoOutput?.capturePhoto(with: settings, delegate: self);
        
        let s = self
        s.startButton.isHidden = true;
        s.displayMessage.isHidden = false;
        let message = sillyMessages.randomElement()!
        displayMessage.backgroundColor = UIColor.black
        s.displayMessage.text = message;
        
        
        //performSegue(withIdentifier: "showPhoto_Segue", sender: nil);
        //print("tap")
    }

    func launchPreview() {
        displayMessage.isHidden = true;
        performSegue(withIdentifier: "showPhotoSegue", sender: nil);
    }
    
    public func previewDismissed() {
        startButton.setTitle("Start", for:UIControl.State.normal);
        countDownBox.isHidden = true
        startButton.isHidden = false;
        print("showing button again")
        print(startButton.isHidden)
    }
    
    
    public func previewPrinted() {
        print("previewPrinted")
        
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfo.OutputType.photo
        
        
        // Set up print controller
        
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        printController.showsNumberOfCopies = false
        
        // Assign a UIImage version of my UIView as a printing iten;
        printController.printingItem = photoStripImage
        
        // Do it
        printController.present(from: self.view.frame, in: self.view, animated: true, completionHandler: nil);
        
        startButton.setTitle("Start", for:UIControl.State.normal);
        startButton.isHidden = false;
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotoSegue" {
            let previewVC = segue.destination as! PreviewViewController;
            
            if UIDevice.modelName.contains("Air") {
                photoStripImage = PhotoUtil.renderPhotostrip(
                photoFiles: fileNames.reversed(),
                photosCropRect: CGRect(x: 0, y: 0, width: 2300, height: 700))
                
            } else {
                photoStripImage = PhotoUtil.renderPhotostrip(
                photoFiles: fileNames.reversed(),
                photosCropRect: CGRect(x: 0, y: 0, width: 2300, height: 1700))
            }


            
            previewVC.image = photoStripImage;
            
            previewVC.delegate = self
            
            // prevents user from dismissing by sliding down modal
            previewVC.isModalInPresentation = true
            
        }
        
        
    }

    override var prefersStatusBarHidden: Bool {
        return true;
    }
    
    @objc func appMovedToBackground() {
        if (sessionInProgress) {
            print("App moved to background")
            exit(0)
        }
    }
    
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            image = UIImage(data: imageData);
            let filename = PhotoUtil.savePhotoToDisk(image!, name: "photo \(fileNames.count)")
            fileNames.append(filename)
            if (fileNames.count >= 4) {
                launchPreview();
            }
        }
    }
}



