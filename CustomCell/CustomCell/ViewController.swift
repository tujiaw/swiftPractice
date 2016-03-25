//
//  ViewController.swift
//  CustomCell
//
//  Created by tutujiaw on 16/3/20.
//  Copyright © 2016年 tujiaw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var team_: NSArray!
    var filterTeam_: NSMutableArray!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        let teamPath = NSBundle.mainBundle().pathForResource("team", ofType: "plist")
        if let path = teamPath {
            team_ = NSArray(contentsOfFile: path)
        }
        
        searchText("", scope: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let customCellId = "CustomCellID"
        let cell = tableView.dequeueReusableCellWithIdentifier(customCellId, forIndexPath: indexPath) as! CustomCell

        let rowDict = filterTeam_[indexPath.row] as? NSDictionary
        if let rowDict = rowDict {
            cell.label.text = rowDict["name"] as? String
            cell.img.image = UIImage(named: (rowDict["image"] as? String)! + ".png")
            cell.accessoryType = .DisclosureIndicator
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterTeam_.count
    }
}

extension ViewController: UISearchBarDelegate {
    func searchText(text: String, scope: Int) {
        if text.isEmpty {
            filterTeam_ = NSMutableArray(array: team_)
            return
        }
        
        var tempArray: NSArray!
        if scope == 0 {
            let scopePredicate = NSPredicate(format: "SELF.image contains[c] %@", text)
            tempArray = team_.filteredArrayUsingPredicate(scopePredicate)
            filterTeam_ = NSMutableArray(array: tempArray)
        } else if scope == 1 {
            let scopePredicate = NSPredicate(format: "SELF.name contains[c] %@", text)
            tempArray = team_.filteredArrayUsingPredicate(scopePredicate)
            filterTeam_ = NSMutableArray(array: tempArray)
        } else {
            filterTeam_ = NSMutableArray(array: team_)
        }
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchText("", scope: 0)
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange text: String) {
        searchText(text, scope: 0)
        tableView.reloadData()
    }
}

