//
//  ImageDownloadManager.swift
//  Routes
//
//  Created by Vitor Costa on 04/03/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloadManager {
    
    // MARK: STATIC OBJECT REFERENCE
    static let shared:ImageDownloadManager = ImageDownloadManager()
    
    // private init for override purpose
    private init() {
    }
    
    func downloadImage(from url:String, onComplete: @escaping (UIImage) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let imageData:Data = try? Data(contentsOf: URL(string: url)!),
                let image:UIImage = UIImage(data: imageData)
            {
                DispatchQueue.main.async {
                    onComplete(image)
                }
            }
        }
    }
}

