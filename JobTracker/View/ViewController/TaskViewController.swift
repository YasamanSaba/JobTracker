//
//  TaskViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/11/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, ViewModelSupportedViewControllers {
    
    // MARK: - Properties
    var viewModel: TaskViewModel!
    var assingDatePicker: UIDatePicker!
    var deadlinePicker: UIDatePicker!
    var blurEffectView: UIVisualEffectView?
    var bottomEffectView: UIVisualEffectView?
    var mainEffectView: UIVisualEffectView?
    
    // MARK: - Outlets
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtAssignDate: UITextField!
    @IBOutlet weak var txtDeadlineDate: UITextField!
    @IBOutlet weak var txtLink: UITextField!
    @IBOutlet weak var tblReminder: UITableView!
    @IBOutlet weak var vwDeadlinePicker: UIView!
    @IBOutlet weak var vwAssignDatePicker: UIView!
    @IBOutlet weak var swIsFinished: UISwitch!
    @IBOutlet weak var dtpAssignDate: UIDatePicker!
    @IBOutlet weak var dtpDeadline: UIDatePicker!
    @IBOutlet weak var vwReminder: UIView!
    @IBOutlet weak var vwTop: UIView!
    // MARK: - Actions
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
          
        } else {
            
        }
    }
    @IBAction func assingDateDone(_ sender: Any) {
        viewModel.setAssign(date: dtpAssignDate.date)
        txtAssignDate.resignFirstResponder()
    }
    @IBAction func deadlineDone(_ sender: Any) {
        viewModel.setDeadline(date: dtpDeadline.date)
        txtDeadlineDate.resignFirstResponder()
    }
    @IBAction func addReminder(_ sender: Any) {
        viewModel.addReminder(sender: self)
    }
    @IBAction func openLink(_ sender: Any) {
        if let link = txtLink.text {
            viewModel.open(url: link)
        }
    }
    
    // MARK: - Functions
    private func activateBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.alpha = 0.95
        blurEffectView?.frame = view.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let blurEffectView = blurEffectView {
            self.view.addSubview(blurEffectView)
        }
    }
    private func deactiveBlur() {
        self.blurEffectView?.removeFromSuperview()
    }
    func showAlert(text: String) {
        let alertController = UIAlertController(title: "Warning!", message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    fileprivate func createSaveButton() {
        let btnSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = btnSave
    }
    func setOnMainBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        mainEffectView = UIVisualEffectView(effect: blurEffect)
        mainEffectView!.alpha = 0.75
        mainEffectView!.backgroundColor = .systemGray5
        mainEffectView!.translatesAutoresizingMaskIntoConstraints = false
        mainEffectView!.layer.cornerRadius = 5
        let label = UILabel()
        label.text = "You can add your reminder(s) below"
        label.font = UIFont.preferredFont(forTextStyle: .headline, compatibleWith: .none)
        let imageView = UIImageView(image: UIImage(systemName: "arrow.down.circle"))
        imageView.tintColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.vwTop.addSubview(mainEffectView!)
        mainEffectView!.contentView.addSubview(label)
        mainEffectView!.contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            mainEffectView!.topAnchor.constraint(equalTo: vwTop.topAnchor),
            mainEffectView!.leadingAnchor.constraint(equalTo: vwTop.leadingAnchor),
            mainEffectView!.trailingAnchor.constraint(equalTo: vwTop.trailingAnchor),
            mainEffectView!.bottomAnchor.constraint(equalTo: vwTop.bottomAnchor),
            mainEffectView!.centerXAnchor.constraint(equalTo: label.centerXAnchor),
            mainEffectView!.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            label.bottomAnchor.constraint(greaterThanOrEqualTo: imageView.topAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: mainEffectView!.bottomAnchor, constant: -10),
            imageView.centerXAnchor.constraint(equalTo: mainEffectView!.centerXAnchor),
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
    
    // MARK: - OBJC Functions
    @objc func save() {
        guard let title = txtTitle.text, !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(text: "Please fill title")
            return
        }
        if viewModel.save(title: title, isDone: swIsFinished.isOn, link: txtLink.text ?? "") {
            if let navigationController = navigationController {
                navigationController.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @objc func nextButton() {
        guard let title = txtTitle.text, !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(text: "Please fill title")
            return
        }
        if viewModel.next(title: title, isDone: swIsFinished.isOn, link: txtLink.text ?? "") {
            bottomEffectView?.removeFromSuperview()
            createSaveButton()
            setOnMainBlur()
            txtTitle.resignFirstResponder()
            txtLink.resignFirstResponder()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createSaveButton()
        navigationItem.title = "Task"
        txtAssignDate.inputView = vwAssignDatePicker
        txtDeadlineDate.inputView = vwDeadlinePicker
        
        if !viewModel.isEditingMode {
            let blurEffect = UIBlurEffect(style: .light)
            bottomEffectView = UIVisualEffectView(effect: blurEffect)
            bottomEffectView!.alpha = 0.75
            bottomEffectView!.backgroundColor = .systemGray5
            bottomEffectView!.frame = self.vwReminder.bounds
            bottomEffectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.vwReminder.addSubview(bottomEffectView!)
            let nextBtn = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextButton))
            navigationItem.rightBarButtonItem = nextBtn
        }
        viewModel.start(tableView: tblReminder)
    }
}


extension TaskViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.accessibilityIdentifier == "AssignDate" || textField.accessibilityIdentifier == "Deadline" {
            activateBlur()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        deactiveBlur()
    }
}
extension TaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension TaskViewController: TaskViewModelDelegate {
    func deadline(text: String) {
        txtDeadlineDate.text = text
    }
    
    func assignDate(text: String) {
        txtAssignDate.text = text
    }
    
    func title(_ text: String) {
        txtTitle.text = text
    }
    
    func link(_ text: String) {
        txtLink.text = text
    }

}
