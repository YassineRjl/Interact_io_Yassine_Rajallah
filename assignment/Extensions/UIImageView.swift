//
//  NetworkUtil.swift
//  assignment
//
//  Created by YR on 2/20/20.
//  Copyright © 2020 Fretello. All rights reserved.
//

import UIKit



extension UIImageView{
    
    //access download and send back a completion handler with the image
     func downloadProfileImage(url: String,  completion: @escaping (_: UIImage?)->()  ){

        guard let url = URL(string: url) else {completion(nil); return }
        downloadedFrom(url: url, contentMode: .scaleAspectFit, completion: {img in
                completion(img)
            })
            
    }
    
    //download an image from a url
     private func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit,  completion: @escaping (_: UIImage?)->()  ) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                
                else { completion(nil); return; }
           
            DispatchQueue.main.async() { () -> Void in
                completion(image)
            }
        }.resume()
    }
    
    
    // make an image rounded
    func roundImage(){
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
    
}
