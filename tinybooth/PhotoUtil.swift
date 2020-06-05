//
//  PhotoUtil.swift
//  tinybooth
//
//  Created by Camrynn Dilley on 6/5/20.
//  Copyright © 2020 codesquad. All rights reserved.
//



import Foundation
import CoreGraphics
import UIKit

public class PhotoUtil {
    
    public static let OUTPUT_WIDTH        = 800
    public static let OUTPUT_HEIGHT       = 1200
    public static let MARGIN              = 30
    
    // w 1024
    // h 1536
    
    
    
    public static func renderPhotostrip(
        photoFiles: [String],
        photosCropRect: CGRect) -> UIImage {
        
        let STRIP_PHOTO_HEIGHT = ((OUTPUT_HEIGHT - MARGIN) / photoFiles.count) - (MARGIN);
        let STRIP_PHOTO_WIDTH = (OUTPUT_WIDTH / 2) - (MARGIN * 2);

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let ctx = CGContext(
            data: nil,
            width: Int(OUTPUT_WIDTH),
            height: Int(OUTPUT_HEIGHT),
            bitsPerComponent: Int(8),
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        
        for (i, file) in photoFiles.enumerated() {
            
            let photo = UIImage(contentsOfFile: file)
            let croppedPhoto = photo?.cgImage?.cropping(to: photosCropRect)!

            ctx.draw(croppedPhoto!, in: CGRect(
                x: MARGIN,
                y: MARGIN + ((STRIP_PHOTO_HEIGHT * i) + (MARGIN * i)),
                width: STRIP_PHOTO_WIDTH,
                height: STRIP_PHOTO_HEIGHT))

 
            ctx.draw(croppedPhoto!, in: CGRect(
                x: (MARGIN * 3) + STRIP_PHOTO_WIDTH,
                y: MARGIN + ((STRIP_PHOTO_HEIGHT * i) + (MARGIN * i)),
                width: STRIP_PHOTO_WIDTH,
                height: STRIP_PHOTO_HEIGHT))
            
        }
        
        return UIImage(cgImage: ctx.makeImage()!)
    }
    
    
    public static func savePhotoToDisk(_ image: UIImage, name: String) -> String {
        let filename = getDocumentsDirectory(name + ".jpg")
        var img = PhotoUtil.reorient(image)
        if let data = img.jpegData(compressionQuality: 0.8) {
            try? data.write(to: URL(fileURLWithPath: filename))
        }
        return filename
    }
    
    public static func getDocumentsDirectory(_ name: String) -> String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(name).path
    }
 

public static func reorient(_ src:UIImage)->UIImage {
    if src.imageOrientation == UIImage.Orientation.up {
        return src
    }
    var transform: CGAffineTransform = CGAffineTransform.identity
    switch src.imageOrientation {
    case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
        transform = transform.translatedBy(x: src.size.width, y: src.size.height)
        transform = transform.rotated(by: CGFloat(M_PI))
        break
    case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
        transform = transform.translatedBy(x: src.size.width, y: 0)
        transform = transform.rotated(by: CGFloat(M_PI_2))
        break
    case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
        transform = transform.translatedBy(x: 0, y: src.size.height)
        transform = transform.rotated(by: CGFloat(-M_PI_2))
        break
    case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
        break
    }
    
    switch src.imageOrientation {
    case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
        transform.translatedBy(x: src.size.width, y: 0)
        transform.scaledBy(x: -1, y: 1)
        break
    case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
        transform.translatedBy(x: src.size.height, y: 0)
        transform.scaledBy(x: -1, y: 1)
    case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right:
        break
    }
    
    let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: (src.cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (src.cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    
    ctx.concatenate(transform)
    
    switch src.imageOrientation {
    case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
        ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
        break
    default:
        ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
        break
    }
    
    let cgimg:CGImage = ctx.makeImage()!
    let img:UIImage = UIImage(cgImage: cgimg)
    
    return img
}
}


