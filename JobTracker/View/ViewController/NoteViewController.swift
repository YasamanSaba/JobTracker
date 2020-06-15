//
//  NoteViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/14/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet weak var txtTitle: UITextView!
    @IBOutlet weak var txtDesc: UITextView!
    
    var keyboardYSize: CGFloat = 0
    var lastCursorY: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if txtDesc.isFirstResponder {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                keyboardYSize = keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}


extension NoteViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if let selectedRange = textView.selectedTextRange
        {
            let caretRect = textView.caretRect(for: selectedRange.end)
            let windowRect = textView.convert(caretRect, to: self.view)
            
            let distance = windowRect.origin.y + 18 - (view.bounds.height - keyboardYSize)
            
            if windowRect.origin.y >= self.lastCursorY {
                if distance >= 0 &&  self.view.frame.origin.y > -(keyboardYSize - 70) {
                    self.view.frame.origin.y -= 18
                    self.lastCursorY = windowRect.origin.y
                }
            } else if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += 18
                self.lastCursorY = windowRect.origin.y
            }
        }
        
    }
    
    
}
