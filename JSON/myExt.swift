//
//  myExt.swift
//  JSON
//
//  Created by Ouriel Bennathan on 19/04/2022.
//

import Foundation
import UIKit
import SVGKit
//let's create a image cache
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView{
    func loadImageUsingCache(withUrl urlString:String){
        //convert string location to URL location (Unified Resource Location)
        let url = URL(string: urlString)
        
        
        
        //check first of all, if we have image in the cache, and if so, load from the cache
        //this will give us faster image view, and better preformnce without loading the image from the internet
        if let cachedImage = imageCache.object(forKey: urlString as NSString){
            self.image = cachedImage
            return
        }
        
        //put indicator on the screen, so the user will know that we are loading image
        let activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView.init(style: .large)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center
        
        //load the image from the url (from the internet)
        URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            if error != nil {
                print (error!)
                return
            }
            DispatchQueue.main.async {
                       if let image = SVGKImage(data: data!){
                           //first of all, put the image into the cache
                           imageCache.setObject(image.uiImage, forKey: urlString  as NSString)
                           //set image into the uiimage view
                           self.image = image.uiImage
                           activityIndicator.removeFromSuperview()
                       }
            }
        }.resume()
        
    }
}


