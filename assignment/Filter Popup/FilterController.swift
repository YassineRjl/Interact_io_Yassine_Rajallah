//
//  FilterController.swift
//  assignment
//
//  Created by YR on 2/20/20.
//  Copyright © 2020 Fretello. All rights reserved.
//

import UIKit


enum statusEnum: String {
    case none, alive, dead, unknown
}

enum genderEnum: String {
    case none, female, male, genderless, unknown
}


protocol UrlExtensionProtocol{
    func buildUrlExtension(url: String)
}


class FilterController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
        
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    var delegate: UrlExtensionProtocol?
    
    var dietBool = true
    var bodyBool = true
    var genderBool = true
    var heightBool = true
    
    var genderType = [String]()
    var statusType = [String]()
    
    var tappedTextField: UITextField?
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyboardWhenTappedAround()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVar()
        createViewPicker()
    }
    
    
    
    func initializeVar(){

        genderType = [genderEnum.none.rawValue,
                      genderEnum.female.rawValue,
                      genderEnum.male.rawValue,
                      genderEnum.genderless.rawValue,
                      genderEnum.unknown.rawValue
                     ]
        
        statusType = [statusEnum.none.rawValue,
                     statusEnum.alive.rawValue,
                     statusEnum.dead.rawValue,
                     statusEnum.unknown.rawValue]
        
        
        genderTextField.addTarget(self, action: #selector(myTargetFunction(_:)), for: .touchDown)
        statusTextField.addTarget(self, action: #selector(myTargetFunction(_:)), for: .touchDown)
        
    }
 
    
    // call and assign textview to a global placeholder and act on it by reference
    @objc func myTargetFunction(_ sender: UITextField) {

       tappedTextField = sender
        
    }
    
    //setup the input views for each textview
    func createViewPicker() {
        
        //Create first Picker
        let pickerONE = UIPickerView()
        pickerONE.delegate = self
        pickerONE.backgroundColor = .white
        genderTextField.inputView = pickerONE
        
        
        //Create second picker
        let pickerTWO = UIPickerView()
        pickerTWO.delegate = self
        pickerTWO.backgroundColor = .white
        statusTextField.inputView = pickerTWO
        
        
        
        //create toolbar button "Done"
        let toolBar = UIToolbar()
            toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissingPicker))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        //assign the done button for each text field
        genderTextField.inputAccessoryView = toolBar
        statusTextField.inputAccessoryView = toolBar
        
    }
    

    //dismiss picke view when tapped on Done
    @objc func dismissingPicker() {
        if let picker = tappedTextField?.inputView as? UIPickerView{ //to trigger delegate and store last value
            pickerView(picker, didSelectRow: picker.selectedRow(inComponent: 0), inComponent: 0)
        }
        view.endEditing(true)
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(tappedTextField == genderTextField){
            print("gender type count : \(genderType.count)")
            return genderType.count
            
        }else if(tappedTextField == statusTextField){
            print("status type count : \(statusType.count)")
            return statusType.count
        }
        
        
        return 0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(tappedTextField == genderTextField){
            
            return genderType[row]
        }else if(tappedTextField == statusTextField){
            
            return statusType[row]
        }
       
        return ""
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let someString: String?
        if(tappedTextField == genderTextField){
            someString = genderType[row]
            
        }else if(tappedTextField == statusTextField){
            someString = statusType[row]
        }
            
        else{
            someString = ""
        }
        tappedTextField?.text = someString //display changes on referenced textfield
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        var label: UILabel

        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }

        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Menlo-Regular", size: 17)

        if(tappedTextField == genderTextField){

            label.text = genderType[row]
        }else if(tappedTextField == statusTextField){

            label.text = statusType[row]
        }
        else{
            label.text = ""
        }

        return label
    }

    
    
    
    //call delegate back to main screen to change search results
    @IBAction func saveSettings(_ sender: Any) {
        
        dismiss(animated: true, completion: {
            self.delegate?.buildUrlExtension(url: self.constructUrlExtension())
            
        })
    }
    
    func constructUrlExtension() -> String{
        guard let statusTxt = statusTextField.text, let genderTxt = genderTextField.text else{
            print("one of texts is nil")
            return ""
        }
        if(statusTxt.isEmpty && statusTxt.isEmpty){
            print("both texts are empty")
            return ""
            
        }
        
        var urlExtension = ""
        
        if(statusTxt != "none"){
            urlExtension += "?status=\(statusTxt)"
        }
        
        if(genderTxt != "none"){
            
            if(urlExtension.isEmpty){ //condition to change to characters "?" or "&" according to the number of parameters and placement of the string in the url extension
                urlExtension += "?gender=\(genderTxt)"
            }else{
                urlExtension += "&gender=\(genderTxt)"
            }
            
        }
        
        return urlExtension
    }
    
}

