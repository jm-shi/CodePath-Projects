//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate {

    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    var searchWord = ""
    var searchBar = UISearchBar()
    var filterButton = UIBarButtonItem()
    
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    var filteredCategories:[String] = []
    
    var theOffset = 0
    var isMoreDataLoading = false
    var doFilterByRestaurants = true
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorInset = UIEdgeInsets.zero
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
    
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Restaurants"
        self.searchBar.tintColor = UIColor.white
        
        self.navigationItem.titleView = self.searchBar
        self.navigationItem.leftBarButtonItem = filterButton
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.74, green: 0.15, blue: 0.15, alpha: 0.9)
        
        self.filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(swapFilterType))
        self.filterButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = self.filterButton
        
        resetSearch()
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
    }
    
    // MARK: Miscellaeneous
    func resetSearch() {
        Business.searchWithTerm(term: searchWord, offset: theOffset, categories: nil, completion: { (businesses: [Business]?, error: Error?) -> Void in
        
         //let filteredCategory = ["Parks"]
         //self.filteredCategories = filteredCategory
         
         self.theOffset += 20
         self.businesses = businesses
         self.tableView.reloadData()
         })
    }
    
    func loadMoreData() {
        Business.searchWithTerm(term: searchWord, offset: theOffset, categories: filteredCategories, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.isMoreDataLoading = false
            self.theOffset += 20
            if (self.searchWord == "") {
                self.businesses.append(contentsOf: businesses!)
            }
            else {
                self.filteredBusinesses.append(contentsOf: businesses!)
            }
            self.tableView.reloadData()
        })
    }
    
    func filterByCategory(theCategories: String) {
        Business.searchWithTerm(term: searchWord, offset: theOffset, categories: filteredCategories, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.filteredCategories = [theCategories.lowercased()]
            self.filteredBusinesses = businesses
        })
    }
    
    func swapFilterType() {
        if (doFilterByRestaurants) {
            self.doFilterByRestaurants = false
            self.searchBar.placeholder = "Categories"
            
        }
        else {
            self.doFilterByRestaurants = true
            self.searchBar.placeholder = "Restaurants"
        }
        self.tableView.reloadData()
    }
    
    // MARK: UITableViewDelegate and UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            if (searchBar.text?.isEmpty)! {
                if let count = businesses?.count {
                    return count
                }
                return 0
            }
            else {
                if let count = filteredBusinesses?.count {
                    return count
                }
                return 0
            }
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        if (searchBar.text?.isEmpty)! {
            cell.business = businesses[indexPath.row]
        }
        else {
            cell.business = filteredBusinesses[indexPath.row]
        }
        
        return cell
    }
    
    // MARK: UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       searchWord = searchText
        
       if searchText.isEmpty {
            filteredBusinesses = businesses
            self.filteredCategories = []
        }
        else {
            if (doFilterByRestaurants) {
                filteredBusinesses = businesses.filter({ (business: Business) -> Bool in
                    if let name = business.name {
                        return name.range(of: searchWord, options: .caseInsensitive) != nil
                    }
                    return false
                })
            }
            else {
                filteredBusinesses = businesses.filter({ (business: Business) -> Bool in
                    if let category = business.categories {
                        return category.range(of: searchText, options: .caseInsensitive) != nil
                    }
                    return false
                })
        
            }
        }

        tableView.reloadData()
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                self.isMoreDataLoading = true
                
                // Load more results
                self.loadMoreData()
            }
        }
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     /*  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }*/
    
}
