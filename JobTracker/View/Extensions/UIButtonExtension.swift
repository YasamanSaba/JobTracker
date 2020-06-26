//
//  UIButtonExtension.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/24/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
class PickerButton: UIButton {
    var myView: UIView!
    var toolBarView: UIView!
    override var inputView: UIView {
        get {
            return self.myView
        }

        set {
            self.myView = newValue
        }
    }

    override var inputAccessoryView: UIView {
        get {
            return self.toolBarView
        }
        set {
            self.toolBarView = newValue
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

}
