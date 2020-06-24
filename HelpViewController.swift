//
//  HelpViewController.swift
//  tinybooth
//
//  Created by Camrynn Dilley on 6/18/20.
//  Copyright © 2020 codesquad. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var contactTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTextView()
        // Do any additional setup after loading the view.

    }

    func updateTextView() {
        
        let path = "https://github.com/csuncodesquadgroup/tinybooth"
        let text = contactTextView.text ?? ""
        let attributedString = NSAttributedString.makeHyperLink(for: path, in: text, as: "github")
        let font = contactTextView.font
        let color = contactTextView.textColor
        contactTextView.attributedText = attributedString
        contactTextView.font = font
        contactTextView.textColor = color
    }
    
    @IBAction func exitButton_TouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension NSAttributedString {
    
    static func makeHyperLink(for path: String, in string: String, as substring: String) -> NSAttributedString {
        
        let nsString = NSString(string: string)
        let substringRange = nsString.range(of: substring)
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.link, value: path, range: substringRange)
        return attributedString
        
    }
    
}
