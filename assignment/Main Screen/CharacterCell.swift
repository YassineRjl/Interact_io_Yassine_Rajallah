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
    
    var profileID:String = "" // to check if current image belongs to this cell
    
    var characterObj: Results! // character object instance in cell to facilitate navigation to Character screen
    
    func setUpCell(characterObj: Results){
        self.characterObj = characterObj
        
        populateCell()
    }
    
    
    func populateCell(){
        nameLabel.text =  characterObj.name
        speciesLabel.text = characterObj.species
        statusLabel.text = characterObj.status
        profileID = characterObj.name
        
        profileImage.roundImage()
        
        
        if let image = CharacterCell.cache.object(forKey: characterObj?.image as NSString? ?? ""){
            //image cached, populate
            
            DispatchQueue.main.async{
                [weak self] in
                if let strongSelf = self{
                    strongSelf.profileImage.image = nil
                    strongSelf.profileImage.image = image
                }
            }
                
            
        }else{
            //download image from scratch
            profileImage.downloadProfileImage(url: characterObj?.image ?? "") { (image) in
                
                guard let url = self.characterObj?.image as NSString? else {return}
                
                if let image = image {
                    DispatchQueue.main.async{
                    [weak self] in
                        if let strongSelf = self{
                            if(strongSelf.profileID == strongSelf.characterObj.name){ // check equivalence to avoid wrong image
                                strongSelf.profileImage.image = nil
                                strongSelf.profileImage?.image = image
                                CharacterCell.cache.setObject(image, forKey: url)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    
    override func prepareForReuse() {
        DispatchQueue.main.async{
        [weak self] in
            if let strongSelf = self{
                strongSelf.profileImage.image = nil // to avoid images flickering
            }
        }
    }

}
