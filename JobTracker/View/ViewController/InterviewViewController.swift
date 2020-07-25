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
    var blurEffectViewInterviewDate: UIVisualEffectView?
    // MARK: - IBOutlet -
    @IBOutlet weak var txtInterviewDate: UITextField!
    @IBOutlet weak var txtInterviewLink: UITextField!
    @IBOutlet weak var txtInterviewerName: UITextField!
    @IBOutlet weak var txtInterviewerRole: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var colTag: UICollectionView!
    @IBOutlet weak var tblReminder: UITableView!
    @IBOutlet weak var vwReminder: UIView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwTag: UIView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSaveButton()
        setup()
        viewModel.start(pickerView: rolePickerView, collectionView: colTag, tableView: tblReminder)
    }
    // MARK: - Functions
    private func setup() {
        configureTextBoxDatePicker()
        configureTextBoxInterviewerRole()
        txtInterviewDate.tintColor = .clear
        txtInterviewerRole.tintColor = .clear
        if !viewModel.isEditingMode {
            let blurEffect = UIBlurEffect(style: .light)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView!.alpha = 0.75
            blurEffectView!.backgroundColor = .systemGray5
            blurEffectView!.frame = view.bounds
            blurEffectView!.translatesAutoresizingMaskIntoConstraints = false
            self.vwReminder.addSubview(blurEffectView!)
            NSLayoutConstraint.activate([
                blurEffectView!.leadingAnchor.constraint(equalTo: vwReminder.leadingAnchor),
                blurEffectView!.trailingAnchor.constraint(equalTo: vwReminder.trailingAnchor),
                blurEffectView!.topAnchor.constraint(equalTo: vwReminder.topAnchor),
                blurEffectView!.bottomAnchor.constraint(equalTo: vwReminder.bottomAnchor)
            ])
            let nextBtn = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextButton))
            navigationItem.rightBarButtonItem = nextBtn
        }
    }
    private func activateBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectViewInterviewDate = UIVisualEffectView(effect: blurEffect)
        blurEffectViewInterviewDate?.alpha = 0.95
        blurEffectViewInterviewDate?.frame = view.bounds
        blurEffectViewInterviewDate?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let blurEffectView = blurEffectViewInterviewDate {
            self.view.addSubview(blurEffectView)
        }
    }
    private func deactiveBlur() {
        self.blurEffectViewInterviewDate?.removeFromSuperview()
    }
    private func configureTextBoxDatePicker() {
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
    private func configureTextBoxInterviewerRole() {
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
    private func setOnMainBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView!.alpha = 0.75
        blurEffectView!.backgroundColor = .systemGray5
        blurEffectView!.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView!.layer.cornerRadius = 10
        blurEffectView!.clipsToBounds = true
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
            blurEffectView!.leadingAnchor.constraint(equalTo: vwMain.leadingAnchor),
            blurEffectView!.trailingAnchor.constraint(equalTo: vwMain.trailingAnchor),
            blurEffectView!.topAnchor.constraint(equalTo: vwMain.topAnchor),
            blurEffectView!.bottomAnchor.constraint(equalTo: vwTag.bottomAnchor),
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
    private func showAlert(text: String) {
        let alertController = UIAlertController(title: "Warning!", message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    private func createSaveButton() {
        let btnSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveInterview))
        navigationItem.rightBarButtonItem = btnSave
    }
    
    // MARK: - OBJC Functions
    @objc func nextButton() {
        if viewModel.save(link: txtInterviewLink.text, interviewer: txtInterviewerName.text, desc: txtDescription.text) {
            blurEffectView?.removeFromSuperview()
            createSaveButton()
            setOnMainBlur()
            txtDescription.resignFirstResponder()
            txtInterviewerName.resignFirstResponder()
            txtInterviewLink.resignFirstResponder()
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
    @objc func saveInterview() {
        if viewModel.save(link: txtInterviewLink.text, interviewer: txtInterviewerName.text, desc: txtDescription.text) {
            if let navigationController = navigationController {
                navigationController.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
// MARK: - Extension -
extension InterviewViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.accessibilityIdentifier == "InterviewDate" {
            activateBlur()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        deactiveBlur()
    }
}
extension InterviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension InterviewViewController: InterviewViewModelDelegate {
    func link(text: String) {
        txtInterviewLink.text = text
    }
    
    func interviewer(text: String) {
        txtInterviewerName.text = text
    }
    
    func desc(text: String) {
        txtDescription.text = text
    }
    
    func role(text: String) {
        txtInterviewerRole.text = text
    }
    
    func date(text: String) {
        txtInterviewDate.text = text
    }
}
