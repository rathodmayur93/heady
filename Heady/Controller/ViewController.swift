//
//  ViewController.swift
//  Heady
//
//  Created by Mayur on 21/11/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit

let constant            = Constants()
var genereMovieList     = [MovieList]()
var selectedItemIndex   = 0

class ViewController: UICollectionViewController {
    
    // MARK:- Outets
    @IBOutlet var movieCollectionView   : UICollectionView!
    @IBOutlet var searchTF              : UITextField!
    @IBOutlet var filter                : UIBarButtonItem!
    
    // MARK: - Properties & Variables
    fileprivate let reuseIdentifier = "MovieCell"
    fileprivate let sectionInsets   = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate var currentPage     = 1
    
    fileprivate var widthPerItem    : CGFloat   = 0.0
    fileprivate let itemsPerRow     : CGFloat   = 2
    fileprivate var isSearchListActive          = false
    fileprivate var searchQuery                 = ""
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- UI Related Things
    func setUI(){
        genereMovieList.removeAll()
        movieListAPICall()
        movieCollectionView.delegate    = self
        searchTF.delegate               = self
    }
    
    // MARK:- API Calls
    func movieListAPICall(){
        let movieListAPICall  = MovieListAPICall()
        movieListAPICall.makeAPICall(fromViewController: self, page: "\(currentPage)", genereId: selectedGenereId)
    }
    
    func searchMovieAPICall(query : String){
        isSearchListActive      = true
        let searchMovieAPICall  = SearchMovieAPI()
        searchMovieAPICall.makeAPICall(fromViewController: self, page: "\(currentPage)", query: query)
    }
    
    // MARK:- API Responses
    func moviesAPIResponse(dic : Any){
        
        var error: NSError?
        let genereParser    = MovieListParser()
        let movieList       = genereParser.parseList(data: dic, error: &error)
        genereMovieList    += movieList
        movieCollectionView.reloadData()
    }
    
    func searchMovieAPIResponse(dic : Any){
        var error: NSError?
        let genereParser    = MovieListParser()
        let movieList       = genereParser.parseList(data: dic, error: &error)
        genereMovieList    += movieList
        movieCollectionView.reloadData()
    }
    
    // MARK:- Button Actions
    @IBAction func filterBTAction(_ sender: Any) {
        showFilterActionSheet()
    }
    
    // MARK:- Action Sheet For Filter
    func showFilterActionSheet(){
        
        let optionMenu = UIAlertController(title: nil, message: "Sort By", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Popularity", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.sortByPopularity()
        })
        let saveAction = UIAlertAction(title: "Highest Rated", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.sortByHighestRate()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })

        optionMenu.view.tintColor   = UIColor.darkGray
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    // MARK:- Sorting Functions
    func sortByPopularity(){
        genereMovieList.sort { (movie1, movie2) -> Bool in
            movie1.popularity > movie2.popularity
        }
        movieCollectionView.reloadData()
    }
    
    func sortByHighestRate(){
        genereMovieList.sort { (movie1, movie2) -> Bool in
            movie1.voteAvg > movie2.voteAvg
        }
        movieCollectionView.reloadData()
    }
    
}

// MARK:- When User Search Anything
extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     
        if(textField.text! != ""){
            genereMovieList.removeAll()
            searchMovieAPICall(query: textField.text!)
            searchQuery     = textField.text!
            textField.text  = nil
            currentPage     = 1
            textField.resignFirstResponder()
        }else{
            UiUtillity.shared.showAlert(title: "Error", message: "Please Enter Text To Search", logMessage: "Search Text Blank", fromController: self)
        }
        return true
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        print("List Count \(genereMovieList.count)")
        return genereMovieList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,for: indexPath) as! MovieCollectionViewCell
        
        cell.movieLabel.text        = genereMovieList[indexPath.row].title
        cell.movieThumbnail.loadFromURL(photoUrl: "\(constant.IMAGE_BASE_URL)\(genereMovieList[indexPath.row].posterImage)")
        
        if(indexPath.row == genereMovieList.count - 1){
            currentPage += 1
            if(isSearchListActive){
                searchMovieAPICall(query: searchQuery)
            }else{
                movieListAPICall()
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItemIndex   = indexPath.row
    }
}

// MARK:- UICollectionView Delegate Flow Layout
extension ViewController : UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace    = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth  = view.frame.width - paddingSpace
        widthPerItem    = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK:- Load Image From URL
extension UIImageView {
    
    //load image async from url
    func loadFromURL(photoUrl:String){
        let url     = NSURL(string: photoUrl)
        let request = NSMutableURLRequest(url:url! as URL);
       
        let datatask = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print(error!)
            }
            else{
                if let urlContent = data{
                    do {
                        DispatchQueue.main.sync(execute: {
                            self.image  = UIImage(data: urlContent)
                        })
                    }
                }
            }
        }
        datatask.resume()
    }
}

