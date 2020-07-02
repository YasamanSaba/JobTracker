//
//  CityCollectionViewCell.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/1/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

@IBDesignable class CityCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: CityCollectionViewCell.self)
    
    @IBOutlet weak var lblCityName: UILabel!
    
    func configure(city: City) {
        lblCityName.text = city.name
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
