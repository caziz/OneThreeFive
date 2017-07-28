//
//  ImageService.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/27/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit

class ImageService {
    
    static func fetchImage(url: URL) -> UIImage? {
        if let imageData = NSData(contentsOf: url) {
            return UIImage(data: imageData as Data)
        }
        return nil
    }
    
    static func saveImage(path : String, image: UIImage) {
        if let data = UIImagePNGRepresentation(image) {
            let filename = getDocumentsDirectory().appendingPathComponent("\(path).png")
            do {
                try data.write(to: filename)
            } catch {
                print("Error: failed to write image")
            }
        }
    }
    
    static func loadImage(path: String) -> UIImage? {
        let filename = getDocumentsDirectory().appendingPathComponent("\(path).png")
        print("looking in:\n\(filename)")
        if let imageData = NSData(contentsOfFile: filename.path)  {
            print("found data!")
            return UIImage(data: imageData as Data)
        }
        return nil
    }
    
    static func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
