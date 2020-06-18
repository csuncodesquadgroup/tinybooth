//
//  PreviewViewController.swift
//  tinybooth
//
//  Created by Camrynn Dilley on 6/4/20.
//  Copyright © 2020 codesquad. All rights reserved.
//

import UIKit



protocol PreviewDelegate {
    func previewDismissed()
    func previewPrinted()
}

class PreviewViewController: UIViewController {

    var delegate: PreviewDelegate?
    
    @IBOutlet weak var photo: UIImageView!  // linked to the UIImageView on previeew screen
    var image: UIImage!                     //  is the image variable for what goes inside the UIImageView
    
    @IBOutlet weak var shareButton: UIButton!   //linked to the share button
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image =  self.image;
        print("image in PreviewViewController is ");
        print(image);
        
    }
    
    
    // Linked to the "Redo" button on Preview screen of Main.storyboard
    @IBAction func redoButton_TouchUpInside(_ sender: Any) {
        
        // dismisses preview modal
        dismiss(animated: true, completion: {
            self.delegate?.previewDismissed()
        })
        
    }

    // Linked to the "Print" button on Preview screen of Main.storyboard
    @IBAction func printButton_TouchUpInside(_ sender: Any) {
        delegate?.previewPrinted()
        
        // dismisses preview modal - un comment to do it
//        dismiss(animated: true, completion: {
//            self.delegate?.previewDismissed()
//        })
    }

    // Linked to the "Share" button on Preview screen of Main.storyboard
    @IBAction func shareButton_TouchUpInside(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        if let popOver = activityController.popoverPresentationController {
            popOver.permittedArrowDirections = .up
            popOver.sourceRect = CGRect(x: shareButton.frame.origin.x, y: shareButton.frame.origin.y, width: shareButton.frame.width, height: shareButton.frame.height)
            popOver.sourceView = self.view
        }
        activityController.excludedActivityTypes = [.print]
        self.present(activityController, animated: true, completion: nil)
        self.delegate?.previewDismissed()
    }
   
}
    
  

