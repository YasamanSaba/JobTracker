//
//  ApplyViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/13/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class ApplyViewController: UIViewController, ViewModelSupportedViewControllers {
    // MARK: - Properties -
    var applyInfo: ApplyViewModel.ApplyInfo?
    var viewModel: ApplyViewModel!
    var states: [String] = []
    var blurEffectView: UIVisualEffectView!
    // MARK: - Outlets -
    @IBOutlet weak var lblPassedTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnCompanyName: UIButton!
    @IBOutlet weak var btnState: PickerButton!
    @IBOutlet weak var btnResume: PickerButton!
    @IBOutlet weak var tblInterview: UITableView!
    @IBOutlet weak var tblTask: UITableView!
    @IBOutlet weak var imgHeart: UIImageView!
    // MARK: - Actions -
    @IBAction func btnResumeChange(_ sender: PickerButton) {
        sender.becomeFirstResponder()
        activateBlur()
    }
    @IBAction func btnCompany(_ sender: Any) {
        guard let applyInfo = applyInfo else { return }
        UIApplication.shared.open(applyInfo.jobOfferURL)
    }
    @IBAction func btnAddInterview(_ sender: Any) {
    }
    @IBAction func btnAddTask(_ sender: Any) {
    }
    @IBAction func btnStateChange(_ sender: PickerButton) {
        sender.becomeFirstResponder()
        activateBlur()
    }
    @IBAction func tapOnHeart(_ sender: Any) {
        heartState.toggle()
    }
    // MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    // MARK: - Functions -
    func setUp() {
        tblInterview.delegate = self
        tblTask.delegate = self
        configureSatetPickerView()
        configureResumePickerView()
        applyInfo = viewModel.getApplyInfo()
        heartState = applyInfo!.isFavorite
        btnCompanyName.setTitle(applyInfo!.companyName, for: .normal)
        lblPassedTime.text = applyInfo!.timeElapsed
        lblLocation.text = applyInfo!.location
        btnState.setTitle(applyInfo!.state, for: .normal)
        btnResume.setTitle(applyInfo!.resume, for: .normal)
        viewModel.configureInterviewDataSource(for: tblInterview)
        viewModel.configureTaskDataSource(for: tblTask)
    }
    fileprivate func activateBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.95
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
    }
    fileprivate func deactiveBlur() {
        self.blurEffectView.removeFromSuperview()
    }
    func configureSatetPickerView() {
        let statePickerView = UIPickerView()
        statePickerView.accessibilityIdentifier = "StatePickerView"
        let toolbarStatePicker = UIToolbar()
        toolbarStatePicker.barStyle = UIBarStyle.default
        toolbarStatePicker.isTranslucent = true
        toolbarStatePicker.sizeToFit()
        let doneStatePRBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(stateDoneClick))
        let spaceStatePRBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelStatePRBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(stateCancelClick))
        toolbarStatePicker.setItems([cancelStatePRBtn, spaceStatePRBtn, doneStatePRBtn], animated: false)
        toolbarStatePicker.isUserInteractionEnabled = true
        btnState.inputView = statePickerView
        btnState.inputAccessoryView = toolbarStatePicker
        self.viewModel.configureState(pickerView: statePickerView)
    }
    func configureResumePickerView() {
        let resumePickerView = UIPickerView()
        resumePickerView.accessibilityIdentifier = "ResumePickerView"
        let toolbarResumePickerView = UIToolbar()
        toolbarResumePickerView.barStyle = UIBarStyle.default
        toolbarResumePickerView.isTranslucent = true
        toolbarResumePickerView.sizeToFit()
        let doneResumePRVtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(resumeDoneClick))
        let spaceResumePRBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelResumePRBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(resumeCancelClick))
        toolbarResumePickerView.setItems([cancelResumePRBtn, spaceResumePRBtn, doneResumePRVtn], animated: false)
        toolbarResumePickerView.isUserInteractionEnabled = true
        btnResume.inputView = resumePickerView
        btnResume.inputAccessoryView = toolbarResumePickerView
        self.viewModel.configureResume(pickerView: resumePickerView)
    }
    @objc func stateCancelClick() {
        self.btnState.resignFirstResponder()
        deactiveBlur()
    }
    @objc func stateDoneClick() {
        self.btnState.setTitle(self.viewModel.changeState(), for: .normal) 
        self.btnState.resignFirstResponder()
        deactiveBlur()
    }
    @objc func resumeDoneClick() {
        self.btnResume.setTitle(self.viewModel.changeResumeVersion(), for: .normal)
        self.btnResume.resignFirstResponder()
        deactiveBlur()
    }
    @objc func resumeCancelClick() {
        btnResume.resignFirstResponder()
        deactiveBlur()
    }
    var heartState: Bool = false {
        didSet {
            if heartState {
                imgHeart.image = UIImage(systemName: "heart.fill")
            } else {
                imgHeart.image = UIImage(systemName: "heart")
            }
            viewModel.setIsFavorite(heartState)
        }
    }
}
extension ApplyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
