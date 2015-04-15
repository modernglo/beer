//
//  ViewController.swift
//  beers
//
//  Created by Los on 4/9/15.
//  Copyright (c) 2015 Los. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private var items:[Beer]!
    private var filteredItems:[Beer]!
    private let fetchURLString = "http://modernglo.com/beer/"
    private var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true;
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-HeavyOblique", size: 24)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.items = [Beer]()
        self.filteredItems = [Beer]()
        
        self.spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        self.spinner.frame = CGRectMake(0, 0, 20, 20);
        var spinnerButton = UIBarButtonItem(customView: self.spinner)
        self.navigationItem.setRightBarButtonItem(spinnerButton, animated:false)
        
        setupTableView()
        fetchObjects()
        
        var refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "fetchObjects")
        refreshButton.tintColor = UIColor.whiteColor()
        self.navigationItem .setLeftBarButtonItem(refreshButton, animated: false)
        self.searchBar.delegate = self
        self.searchDisplayController?.delegate = self
        var color = UIColor(red: 75, green: 181, blue: 193, alpha: 1)
        self.searchDisplayController?.searchResultsTableView.backgroundColor = color
        var searchBarTextField = self.searchBar?.valueForKey("searchField") as! UITextField;
        searchBarTextField.textColor = UIColor.whiteColor()
        self.searchDisplayController?.searchResultsTableView.allowsSelection = false
        
    }

    func setupTableView()
    {
        let nibName = UINib(nibName: "BeerTableViewCell", bundle:nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func filterSearch(searchText:String)
    {
        self.filteredItems = self.items.filter({( item : Beer) -> Bool in
            if (item.name.lowercaseString.rangeOfString(searchText.lowercaseString) != nil)
            {
                return true
            }
            else if (item.company.lowercaseString.rangeOfString(searchText.lowercaseString) != nil)
            {
                return true
            }
            else
            {
                return false
            }
        })
    }
    
    func fetchObjects()
    {
        self.items = [Beer]()
        self.filteredItems = [Beer]()
        var fetchURL = NSURL(string: fetchURLString)
        let request = NSURLRequest(URL: fetchURL!)
        self.spinner .startAnimating()
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            let jsonResponse:AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
            
            if let json = jsonResponse as? Dictionary<String,AnyObject> {
                if let beers = json["top250Rankings"] as? Array<Dictionary<String,AnyObject>>
                {
                    for beer in beers
                    {
                        var beerObject = Beer()
                        beerObject.name = beer["name"] as! String
                        if let rank = beer["rank"] as? NSNumber {
                            beerObject.rank = rank.integerValue
                        }
                        beerObject.company = beer["company"] as! String
                        beerObject.type = beer["type"] as! String
                        beerObject.rating = beer["rating"] as? NSNumber
                        self.items.append(beerObject)
                    }
                    self.tableView.reloadData()
                    self.spinner .stopAnimating()
                }
            }
            
        }
    }
//MARK: TableView Delegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredItems.count
        } else {
            return self.items.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! BeerTableViewCell
        var beer: Beer
        if tableView == self.searchDisplayController!.searchResultsTableView {
            beer = self.filteredItems[indexPath.row] as Beer
        } else {
            beer = self.items[indexPath.row] as Beer
        }
        if (self.items.count > indexPath.row)
        {
            cell.rankLabel?.text = "\(beer.rank!.integerValue)"
            cell.beerNameLabel?.text = beer.name
            cell.breweryLabel?.text = beer.company
            cell.beerTypeLabel?.text = beer.type
            cell.beerRatingLabel?.text = "\(beer.rating!.floatValue) rating"
        }
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

    }
//MARK: Search Bar Delegate Methods
    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        self.filterSearch(searchText)
//    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterSearch(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterSearch(self.searchDisplayController!.searchBar.text)
        return true
    }
}

