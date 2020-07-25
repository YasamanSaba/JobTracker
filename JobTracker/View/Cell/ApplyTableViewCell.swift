//
//  AppliesTableViewCell.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/10/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

@IBDesignable class ApplyTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: ApplyTableViewCell.self)
    
    // MARK: - Outlets
    @IBOutlet weak var lblCountryFlag: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblApplyDate: UILabel!
    @IBOutlet weak var lblNumberOfInterviews: UILabel!
    @IBOutlet weak var lblNumberOfTasks: UILabel!
    @IBOutlet weak var lblCheckListStatus: UILabel!
    @IBOutlet weak var lblApplyStatus: UILabel!
    @IBOutlet weak var imgIsFavorite: UIImageView!
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            
            var frame =  newFrame
            frame.origin.y += 4
            frame.size.height -= 8
            super.frame = frame
        }
    }
    
    func configure(apply: AppliesViewModel.ApplyItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMM-dd"
        lblApplyDate.text = dateFormatter.string(from: apply.date!)
        lblCountryFlag.text = apply.apply.city?.country?.flag
        lblCompanyName.text = apply.companyName
        lblNumberOfInterviews.text = String(apply.apply.interview?.count ?? 0)
        lblNumberOfTasks.text = String(apply.apply.task?.count ?? 0)
        lblCheckListStatus.text = "\(apply.numberOfNotCompletedChecklistItems)/\(apply.numberOfCheckListItems)"
        switch apply.apply.statusEnum {
        case .ceo:
            lblApplyStatus.text = "CEO"
            lblApplyStatus.tintColor = .systemGreen
        case .challenge:
            lblApplyStatus.text = "Challenge"
            lblApplyStatus.tintColor = .systemOrange
        case .contract:
            lblApplyStatus.text = "Contract"
            lblApplyStatus.tintColor = .systemGreen
        case .hr:
            lblApplyStatus.text = "HR"
            lblApplyStatus.tintColor = .systemGreen
        case .inSite:
            lblApplyStatus.text = "inSite"
            lblApplyStatus.tintColor = .systemGreen
        case .rejected:
            lblApplyStatus.text = "Rejected"
            lblApplyStatus.tintColor = .systemRed
        case .tech:
            lblApplyStatus.text = "Technical"
            lblApplyStatus.tintColor = .systemGreen
        case .none:
            print("Unexpected status")
        }
        imgIsFavorite.isHidden = !(apply.apply.company?.isFavorite ?? false)
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue{
                layer.borderColor = color.cgColor
            }else{
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            }else{
                layer.shadowColor = nil
            }
        }
    }
}
