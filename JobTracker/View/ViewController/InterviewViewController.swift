//
//  InterviewViewController.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 7/11/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class InterviewViewController: UIViewController, ViewModelSupportedViewControllers {
    // MARK: - Properties -
    var viewModel: InterviewViewModel!
    var datePicker: UIDatePicker!
    var rolePickerView: UIPickerView!
    var blurEffectView: UIVisualEffectView?
    // MARK: - IBOutlet -
    @IBOutlet weak var txtInterviewDate: UITextField!
    @IBOutlet weak var txtInterviewLink: UITextField!
    @IBOutlet weak var txtInterviewerName: UITextField!
    @IBOutlet weak var txtInterviewerRole: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var colTag: UICollectionView!
    @IBOutlet weak var tblReminder: UITableView!
    @IBOutlet weak var vwReminder: UIView!
    // MARK: - IBAction -
    
    @IBAction func btnAddTag(_ sender: Any) {
        viewModel.addTags(sender: self)
    }
    @IBAction func btnAddReminder(_ sender: Any) {
        viewModel.addReminder(sender: self)
    }
    @IBAction func btnOpenURL(_ sender: Any) {
        guard let url = txtInterviewLink.text else {return}
        viewModel.open(url: url)
    }
    // MARK: - Life Cycle -
    fileprivate func createSaveButton() {
        let btnSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
        navigationItem.rightBarButtonItem = btnSave
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSaveButton()
        setup()
    }
    // MARK: - Functions -
    func setup() {
        configureTextBoxDatePicker()
        viewModel.dateText { [weak self] in
            self?.txtInterviewDate.text = $0
        }
        viewModel.roleText { [weak self] in
            self?.txtInterviewerRole.text = $0
        }
        configureTextBoxInterviewerRole()
        viewModel.configureRole(pickerView: rolePickerView)
        viewModel.configureTags(collectionView: colTag)
        viewModel.configureReminder(tableView: tblReminder)
        txtInterviewDate.tintColor = .clear
        txtInterviewerRole.tintColor = .clear
        if let initialValue = viewModel.getInitialValue() {
            txtInterviewLink.text = initialValue.link
            txtInterviewerName.text = initialValue.interviewrName
            txtDescription.text = initialValue.desc
        } else {
            let blurEffect = UIBlurEffect(style: .light)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView!.alpha = 0.75
            blurEffectView!.backgroundColor = .systemGray5
            blurEffectView!.frame = view.bounds
            blurEffectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.vwReminder.addSubview(blurEffectView!)
            let nextBtn = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextButton))
            navigationItem.rightBarButtonItem = nextBtn
        }
    }
    
    func configureTextBoxDatePicker() {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime

        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .systemBlue
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelDatePicker))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.txtInterviewDate.inputView = datePicker
        self.txtInterviewDate.inputAccessoryView = toolBar
    }
    func configureTextBoxInterviewerRole() {
        rolePickerView = UIPickerView()
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .systemBlue
        toolBar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDatePicker))
        toolBar.setItems([spaceButton, doneButton], animated: false)
        txtInterviewerRole.inputView = rolePickerView
        txtInterviewerRole.inputAccessoryView = toolBar
    }
    func setOnMainBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView!.alpha = 0.75
        blurEffectView!.backgroundColor = .systemGray5
        blurEffectView!.translatesAutoresizingMaskIntoConstraints = false
        let label = UILabel()
        label.text = "You can add your reminder(s) below"
        label.font = UIFont.preferredFont(forTextStyle: .headline, compatibleWith: .none)
        let imageView = UIImageView(image: UIImage(systemName: "arrow.down.circle"))
        imageView.tintColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(blurEffectView!)
        blurEffectView!.contentView.addSubview(label)
        blurEffectView!.contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            blurEffectView!.topAnchor.constraint(equalTo: txtInterviewDate.topAnchor),
            blurEffectView!.leadingAnchor.constraint(equalTo: colTag.leadingAnchor),
            blurEffectView!.trailingAnchor.constraint(equalTo: txtInterviewDate.trailingAnchor),
            blurEffectView!.bottomAnchor.constraint(equalTo: colTag.bottomAnchor),
            blurEffectView!.centerXAnchor.constraint(equalTo: label.centerXAnchor),
            blurEffectView!.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            label.bottomAnchor.constraint(greaterThanOrEqualTo: imageView.topAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: blurEffectView!.bottomAnchor, constant: -10),
            imageView.centerXAnchor.constraint(equalTo: blurEffectView!.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1)
        ])
        imageView.transform = .init(translationX: 0, y: -200)
        UIView.animate(withDuration:2,
        delay: 0,
        usingSpringWithDamping: 0.5,
        initialSpringVelocity: 0.2,
        options: [.curveEaseOut],
        animations: {
               imageView.transform = .identity
               }, completion: nil)
    }
    func showAlert(text: String) {
        let alertController = UIAlertController(title: "Warning!", message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    @objc func nextButton() {
        do {
            try viewModel.save(link: txtInterviewLink.text, interviewer: txtInterviewerName.text, desc: txtDescription.text)
            blurEffectView?.removeFromSuperview()
            createSaveButton()
            setOnMainBlur()
            txtDescription.resignFirstResponder()
            txtInterviewerName.resignFirstResponder()
            txtInterviewLink.resignFirstResponder()
        } catch let error as InterviewViewModelError{
            showAlert(text: error.rawValue)
        } catch {
            print(error)
        }
    }
    @objc func cancelDatePicker() {
        txtInterviewDate.resignFirstResponder()
    }
    @objc func saveDatePicker() {
        let interviewDate = datePicker.date
        viewModel.set(date: interviewDate)
        txtInterviewDate.resignFirstResponder()
    }
    @objc func doneDatePicker() {
        txtInterviewerRole.resignFirstResponder()
    }
}
// MARK: - Extension -
extension InterviewViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
