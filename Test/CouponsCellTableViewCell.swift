//
//  CouponsCellTableViewCell.swift
//  Test
//
//  Created by Mounik on 23/02/19.
//  Copyright © 2019 Mounik. All rights reserved.
//

import UIKit

protocol CouponDelegate {
    func clipTapped(_ coupon: Coupons)
}

class CouponsCellTableViewCell: UITableViewCell {

    var delegate: CouponDelegate?
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    var coupon: Coupons?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func btnClipTapped(_ sender: UIButton) {
        if let couponObj = coupon {
            self.delegate?.clipTapped(couponObj)
        }
    }
    
    func updateCellDetails() {
        self.lblTitle.text = coupon?.title
        self.lblDescription.text = coupon?.description
        self.lblMsg.text = coupon?.termsAndConditions
        
        let url = URL(string: (coupon?.imageURL)!)
        let data = try? Data(contentsOf: url!)
        //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        self.imgView.image = UIImage(data: data!)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
