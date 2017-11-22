//
//  GeneresViewController.swift
//  Heady
//
//  Created by Mayur on 21/11/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit

var selectedGenereId    = ""
class GeneresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var generesTableView: UITableView!
    
    // MARK:- Variable Declarations
    var currentPage = 0
    var moviesGenereList  = [MovieGeners]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- TableView Delegate Methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return moviesGenereList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell                = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text    = moviesGenereList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGenereId    = "\(moviesGenereList[indexPath.row].id)"
    }

    // MARK:- UI Related Things
    func setUI(){
        generesTableView.separatorColor = UIColor.clear
        genereAPICall()
    }
    
    // MARK:- API Calls
    func genereAPICall(){
        let movieGenereAPICall  = MovieGenersAPI()
        movieGenereAPICall.makeAPICall(fromViewController: self, page: "\(currentPage)")
    }
    // MARK:- API Responses
    func generesAPIResponse(dic : Any){
        
        var error: NSError?
        let genereParser    = MovieGenereParser()
        let movieGenereList = genereParser.parseList(data: dic, error: &error)
        processGenereResponse(genereList: movieGenereList)
    }
    
    // MARK:- Process API Responses
    func processGenereResponse(genereList : [MovieGeners]){
        moviesGenereList    = genereList
        for i in 0..<genereList.count{
            print("Genere Id \(genereList[i].id) & Genere Name \(genereList[i].name)")
        }
        generesTableView.reloadData()
    }
}
