//
//  CharacterController.swift
//  assignment
//
//  Created by YR on 2/20/20.
//  Copyright © 2020 Fretello. All rights reserved.
//

import UIKit

class CharacterController: UIViewController {
    
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var backgroundImg: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var speciesLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    var characterObj: Results!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateViews()
    }
    
    
    func populateViews(){
   
        //populate all views for the screen
        
        profileImg.downloadProfileImage(url: characterObj.image) { (image) in
            if let image = image{
                DispatchQueue.main.async{
                    self.profileImg.image = image
                    self.profileImg.roundImage()
                }
                
            }
        }
        backgroundImg.downloadProfileImage(url: characterObj.image) { (image) in
            if let image = image{
                DispatchQueue.main.async{
                    self.backgroundImg.image = image
                }
            }
        }
        
        nameLabel.text = characterObj.name
        
        genderLabel.text = characterObj.gender
        statusLabel.text = characterObj.status
        
        originLabel.text = characterObj.origin["name"]
        locationLabel.text = characterObj.location["name"]
        
        speciesLabel.text = characterObj.species
        typeLabel.text = characterObj.type.isEmpty ? "no type":characterObj.type //if an empty string is returned, show a "no type" placeholder
    }
}
