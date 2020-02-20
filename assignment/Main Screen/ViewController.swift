//
//  ViewController.swift
//  assignment
//
//  Created by YR on 2/19/20.
//  Copyright © 2020 Fretello. All rights reserved.
//

import UIKit
import AnimatedGradientView

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UrlExtensionProtocol {
    
     
    @IBOutlet var gradientView: AnimatedGradientView! // for the animated view in the background
    @IBOutlet var charactersTableView: UITableView! // simple table view
    
    let rootUrl = "https://rickandmortyapi.com/api/character/"
    
    var nextPage_PlaceHolder: String! // this helps with storing the link for the next update
    var networkDataList:[Results]? // store network results
    var nextPageUrl:String!{ // trigger network update when given a new value
        didSet{
            getRickAndMortyData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup delegates and separation style
        setupTable()
        
        //activate gradient animation in background
        setupGradient()
        
        //assigne link to "nextPageUrl" to populate table
        setUpIntitalData()
    }
    
    
    func setUpIntitalData(){
        networkDataList = []
        nextPageUrl = rootUrl
    }
    

    func setupGradient(){
        gradientView.direction = .up
        gradientView.animationValues = [(colors: ["#2BC0E4", "#EAECC6"], .up, .axial),
        (colors: ["#833ab4", "#fd1d1d", "#fcb045"], .right, .axial),
        (colors: ["#003973", "#E5E5BE"], .down, .axial),
        (colors: ["#1E9600", "#FFF200", "#FF0000"], .left, .axial)]
    }
    func setupTable(){
        self.charactersTableView.dataSource = self
        self.charactersTableView.delegate = self
        charactersTableView.separatorStyle = .none
    }

    
    
    
    
    
    
    
    
    //Function for network call
    func getRickAndMortyData() {
        //construct the url, use guard to avoid nonoptional
        guard let urlObj = URL(string: nextPageUrl) else
        { return }

        //fetch data
        URLSession.shared.dataTask(with: urlObj) {[weak self](data, response, error) in
            //to avoid non optional in JSONDecoder
            guard let data = data else { return }
            do {
                //decode object
                let downloadedRickAndMorty = try JSONDecoder().decode(PagedCharacters.self, from: data)
                self?.networkDataList?.append(contentsOf: downloadedRickAndMorty.results)
                self?.nextPage_PlaceHolder = downloadedRickAndMorty.info.next // store for next call

                DispatchQueue.main.async {
                    self?.charactersTableView.reloadSections(IndexSet(integer: 0), with: .left)
                }

            } catch {
                print(error)
            }
            }.resume()

    }
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let count = networkDataList?.count else {return}
        if(indexPath.row == count - 1){
            //call get api for next page
            nextPageUrl = nextPage_PlaceHolder
        }
    }
    
    //setup cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height * 0.2
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.networkDataList?.count ?? 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //guard statements to be on the safe side
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "rickandmortyCell") as? CharacterCell else { return UITableViewCell() }

        guard let obj = networkDataList?[indexPath.row] else {return UITableViewCell()}
        cell.setUpCell(characterObj: obj)
        cell.selectionStyle = .none // to avoid selection color on tap
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //present the full info of the tapped character on a new screen
        presentCharacterScreen(indexPath)
    }
    
    
    
    
    
    
    
    
    
   
    //Show popup when tapped the floating search button
    @IBAction func tappedSearch(_ sender: Any) {
        presentFilterPopUp()
    }
    
    //protocol function that returns link extention only, then concatenated with the root link
    func buildUrlExtension(url: String) {
        nextPage_PlaceHolder = ""
        nextPageUrl = rootUrl + url
        DispatchQueue.main.async{
            [weak self] in
            if let strongSelf = self{
                strongSelf.networkDataList?.removeAll()
                strongSelf.charactersTableView.reloadSections(IndexSet(integer: 0), with: .right)
            }
        }
        
    }
    
    
    
    
    // transitions
    
    func presentCharacterScreen(_ indexPath: IndexPath) {
        DispatchQueue.main.async{
            [weak self] in
            if let strongSelf = self{
                let storyboard = UIStoryboard(name: "Character", bundle: nil)
                if let controller = storyboard.instantiateViewController(withIdentifier: "CharacterController") as? CharacterController{
                    guard let obj = strongSelf.networkDataList?[indexPath.row] else {return}
                    controller.characterObj = obj
                    strongSelf.present(controller, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    func presentFilterPopUp() {
        DispatchQueue.main.async{
            [weak self] in
            if let strongSelf = self{
                let storyboard = UIStoryboard(name: "Filter", bundle: nil)
                if let controller = storyboard.instantiateViewController(withIdentifier: "FilterController") as? FilterController{
                    controller.delegate = strongSelf
                    strongSelf.present(controller, animated: true, completion: nil)
                }
            }
        }
        
    }
    
}

