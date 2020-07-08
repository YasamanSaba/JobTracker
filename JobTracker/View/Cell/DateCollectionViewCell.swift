//
//  DateCollectionViewCell.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 7/7/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties -
    static let reuseIdentifier = String(describing: DateCollectionViewCell.self)
    var tapGesture: UITapGestureRecognizer!
    var onDelete: (() -> Void)?
    // MARK: - Outlet -
    @IBOutlet weak var imgBin: UIImageView!
    @IBOutlet weak var lblDateFrom: UILabel!
    @IBOutlet weak var lblDateTo: UILabel!
    // MARK: - IBInspectable -
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
    // MARK: - Functions
    func configure(date: FilterViewModel.FilterObject.DateFilter, onDelete: @escaping (() -> Void)) {
        self.onDelete = onDelete
        if let from = date.from {
            let dateFrom = DateFormatter.localizedString(from: from, dateStyle: .short, timeStyle: .none)
            self.lblDateFrom.text = dateFrom
        } else {
            lblDateFrom.text = "..."
        }
        if let to = date.to {
            let dateTo = DateFormatter.localizedString(from: to, dateStyle: .short, timeStyle: .none)
            self.lblDateTo.text = dateTo
        } else {
            lblDateTo.text = "..."
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnDelete(_:)))
        self.imgBin.addGestureRecognizer(tapGesture)
    }
    @objc func tapOnDelete(_ sender: Any) {
        onDelete?()
    }
}
