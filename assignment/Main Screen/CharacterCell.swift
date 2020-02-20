//
//  CharacterCell.swift
//  assignment
//
//  Created by YR on 2/19/20.
//  Copyright © 2020 Fretello. All rights reserved.
//

import UIKit

class CharacterCell: UITableViewCell {
    
    static let cache = NSCache<NSString, UIImage>() // Cache to load profile images from instead of redownloading
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var profileKey:String = "" // to check if current image belongs to this cell
    
    var characterObj: Results! // character object instance in cell to facilitate navigation to Character screen
    
    func setUpCell(characterObj: Results){
        self.characterObj = characterObj
        
        populateCell()
    }
    
    
    
    func populateCell(){
        nameLabel.text =  characterObj.name
        speciesLabel.text = characterObj.species
        statusLabel.text = characterObj.status
        profileKey = characterObj.image
        
        profileImage.roundImage()
        
        
        populatedProfileImage()
    }
    
    fileprivate func populatedProfileImage() {
        
        //delete previous image on scroll synchronously while waiting for the next asynchronous call
      
        
        if(profileKey != characterObj.image){ return }
        
        if let image = CharacterCell.cache.object(forKey: characterObj?.image as NSString? ?? ""){
            //image cached, populate
            
            DispatchQueue.main.async{
                [weak self] in
                
                    if(self?.profileKey == self?.characterObj.image){
                        self?.profileImage.image = nil
                        self?.profileImage.image = image
                    }else{
                        self?.profileImage.image = nil
                }
            }
            
            
        }else{
            //download image from scratch
            profileImage.downloadProfileImage(url: characterObj?.image ?? "") { (image) in
                
                guard let url = self.characterObj?.image as NSString? else {return}
                
                if let image = image {
                    DispatchQueue.main.async{
                        [weak self] in
                        
                        if(self?.profileKey == self?.characterObj.image){ // check equivalence to avoid wrong image
                            self?.profileImage.image = nil
                            self?.profileImage?.image = image
                            CharacterCell.cache.setObject(image, forKey: url)
                        }else{
                            self?.profileImage.image = nil
                        }
                        
                        
                    }
                }
            }
        }
    }
    override func prepareForReuse() {
       
        profileImage.image = nil // to avoid images flickering
          
    }

}
