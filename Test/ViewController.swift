//
//  ViewController.swift
//  Test
//
//  Created by Mounik on 23/02/19.
//  Copyright © 2019 Mounik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var inputArray: [Coupons] = []
    var isAvailableSelected: Bool = true
    var selectedArray: [Coupons] = []
    var activityView: UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationTitle()
        self.getCouponDetailsServer()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            isAvailableSelected = true

        } else {
            isAvailableSelected = false
        }
        self.refreshCouponDetails()
    }
    
    func refreshCouponDetails() {
        selectedArray = inputArray.filter{ $0.isClipped == !isAvailableSelected }
        self.tableView.reloadData()
    }
    func addActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView?.center = self.view.center
        activityView?.startAnimating()
        self.view.addSubview(activityView!)
    }
    
    func setNavigationTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Coupons"
        titleLabel.font = UIFont.init(name: "System Bold", size: 45.0)
        titleLabel.sizeToFit()
        let leftItem = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
    }

    func getCouponDetailsServer() {
        self.addActivityIndicator()
        let url = URL(string: Constants.serviceURL)
        ServiceManager.get(url!, { (response, data) in
            if let finalResponse = data as? [String: Any] {
                 let responseArray = finalResponse["listOfCoupons"]
                self.parseCoupons(responseArray as! [Any])
                self.activityView?.stopAnimating()
                self.activityView?.removeFromSuperview()
            }
        }) { (response, error) in
            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func parseCoupons(_ responseArray: [Any]){
        for couponDict in responseArray {
            if let dict: [String: Any] = couponDict as? [String : Any] {
                var coupon: Coupons? = Coupons()
                coupon?.description = (dict["title"] as! String)
                coupon?.imageURL = (dict["imageURL"] as! String)
                coupon?.termsAndConditions = (dict["termsAndConditions"] as! String)
                coupon?.description = (dict["description"] as! String)
                coupon?.isClipped = (dict["isClipped"] as! Bool)
                let id = (dict["meijerOfferId"] as! Int)
                coupon?.id = String(id)
                inputArray.append(coupon!)
            }
        }
        
        self.tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedArray.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CouponsCellTableViewCell
        let coupon: Coupons = selectedArray[indexPath.row]
        cell.delegate = self
        cell.coupon = coupon
        
        return cell
    }
    

}

extension ViewController: CouponDelegate {
    
    func clipTapped(_ coupon: Coupons) {
        
        let index = inputArray.index(where:{$0.id == coupon.id})
        var couponObj = coupon
        couponObj.isClipped = !couponObj.isClipped!
        if let value = index {
            inputArray[value] = couponObj
        }
        self.refreshCouponDetails()
        
    }

}
