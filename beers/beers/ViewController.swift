//
//  ViewController.swift
//  beers
//
//  Created by Los on 4/9/15.
//  Copyright (c) 2015 Los. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private var items:[Dictionary<String,AnyObject>]!
    private let fetchURLString = "http://modernglo.com/beer/"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-HeavyOblique", size: 24)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        let nibName = UINib(nibName: "BeerTableViewCell", bundle:nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.items = [Dictionary<String,AnyObject>]()
        fetchObjects()
    }

    func fetchObjects()
    {
        var fetchURL = NSURL(string: fetchURLString)
        let request = NSURLRequest(URL: fetchURL!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            let jsonResponse:AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
            
            if let json = jsonResponse as? Dictionary<String,AnyObject> {
                if let beers = json["top250Rankings"] as? Array<Dictionary<String,AnyObject>>
                {
                    for beer in beers
                    {
                        var beerMap = Dictionary<String,AnyObject>()
                        beerMap["name"] = beer["name"]
                        beerMap["rank"] = beer["rank"]
                        beerMap["company"] = beer["company"]
                        beerMap["type"] = beer["type"]
                        beerMap["rating"] = beer["rating"]
                        self.items.append(beerMap)
                    }
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(self.items.count)
        return self.items.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as BeerTableViewCell
        
        var item = self.items[indexPath.row]
        var rank: AnyObject? = item["rank"]
        cell.rankLabel?.text = "\(rank!)"
        cell.beerNameLabel?.text = item["name"] as? String
        cell.breweryLabel?.text = item["company"] as? String
        cell.beerTypeLabel?.text = item["type"] as? String
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

    }

}

