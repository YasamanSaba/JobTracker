//
//  NoteViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/14/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController, ViewModelSupportedViewControllers {
    
    // MARK: - ViewModel
    var viewModel: NoteViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var txtTitle: UITextView!
    @IBOutlet weak var txtDesc: UITextView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var constDescBottom: NSLayoutConstraint!
    
    // MARK: - Properties
    var keyboardYSize: CGFloat = 0
    var lastCursorY: CGFloat = 0
    var normalBottomConstant: CGFloat = 0
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        normalBottomConstant = constDescBottom.constant
        toolBar.largeContentTitle = "Note"
        
        self.txtDesc.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.txtTitle.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if let initialValues = viewModel.getInitialValues() {
            txtTitle.text =  initialValues.title
            txtDesc.text = initialValues.body
            editMode(on: false)
        } else {
            editMode(on: true)
        }
    }
    
    // MARK: - Methods
    func editMode(on: Bool) {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let flxButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        if on {
            let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
            toolBar.setItems([doneButton,flxButton,saveButton], animated: true)
            txtTitle.isEditable = true
            txtTitle.isSelectable = true
            txtTitle.backgroundColor = .systemBackground
            txtDesc.isEditable = true
            txtDesc.isSelectable = true
            txtDesc.backgroundColor = .systemBackground
        } else {
            let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(edit))
            toolBar.setItems([doneButton,flxButton,editButton], animated: true)
            txtTitle.isEditable = false
            txtTitle.isSelectable = false
            txtTitle.backgroundColor = .systemGray5
            txtDesc.isEditable = false
            txtDesc.isSelectable = false
            txtDesc.backgroundColor = .systemGray5
        }
    }
    func showAlert(text: String) {
        let alertController = UIAlertController(title: "Warning!", message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func done() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func save() {
        guard let title = txtTitle.text, !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(text: "Please fill title")
            return
        }
        do {
            viewModel.save(title: title, body: txtDesc.text ?? "")
            if let navigationController = navigationController {
                navigationController.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    @objc func edit() {
        editMode(on: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if txtDesc.isFirstResponder {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                keyboardYSize = keyboardSize.height
                UIView.animate(withDuration: 0.5) { [weak self] in
                    guard let self = self else { return }
                    self.constDescBottom.constant = self.normalBottomConstant + self.keyboardYSize
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.constDescBottom.constant = self.normalBottomConstant
        }
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
}
extension NoteViewController: NoteViewModelDelegate {
    
}
