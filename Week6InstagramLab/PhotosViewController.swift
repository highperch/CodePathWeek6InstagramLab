//
//  ViewController.swift
//  Week6InstagramLab
//
//  Created by Justin Peng on 3/9/16.
//  Copyright © 2016 Justin Peng. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var photos: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 320
        
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=e05c462ebd86446ea48a5af73769b602")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("responseDictionary: \(responseDictionary)")
                            // Store the returned array of media in your photos property
                            self.photos = responseDictionary["data"] as! [NSDictionary]
                            self.tableView.reloadData()
                    }
                }
        });
        task.resume()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableViewCell", forIndexPath: indexPath) as! PhotoTableViewCell
        let photo = photos[indexPath.row]
        let urlString = photo.valueForKeyPath("images.low_resolution.url") as! String
        cell.photoImageView.setImageWithURL(NSURL(string: urlString)!)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

