//
//  StateCollectionViewCell.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 7/2/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

@IBDesignable class StateCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties -
    static let reuseIdentifier = String(describing: StateCollectionViewCell.self)
    var stateObject: Status!
    var onDelete: ((Status) -> Void)!
    var tapGesture: UITapGestureRecognizer!
    // MARK: - Outlet -
    @IBOutlet weak var imgBin: UIImageView!
    @IBOutlet weak var lblStateName: UILabel!
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
    func configure(state: Status, onDelete: @escaping ((Status) -> Void)) {
        self.stateObject = state
        self.lblStateName.text = state.rawValue
        self.onDelete = onDelete
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnDelete(_:)))
        imgBin.addGestureRecognizer(tapGesture)
    }
    @objc func tapOnDelete(_ sender: Any) {
        onDelete(stateObject)
    }
}
