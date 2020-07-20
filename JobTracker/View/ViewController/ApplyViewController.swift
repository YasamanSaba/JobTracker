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
    @IBOutlet weak var tblInterview: UITableView!
    @IBOutlet weak var tblTask: UITableView!
    @IBOutlet weak var imgHeart: UIImageView!
    @IBOutlet weak var colTags: UICollectionView!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var btnResume: UIButton!
    // MARK: - Actions -
    @IBAction func btnCompany(_ sender: Any) {
        viewModel.openApplyLink()
    }
    @IBAction func btnAddInterview(_ sender: Any) {
        viewModel.addInterview(sender: self)
    }
    @IBAction func btnAddTask(_ sender: Any) {
        viewModel.addTask(sender: self)
    }
    @IBAction func btnShowResume(_ sender: Any) {
        viewModel.openResumeLink()
    }
    @IBAction func tapOnHeart(_ sender: Any) {
        heartState.toggle()
    }
    
    // MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        viewModel.start(collectionView: colTags, interviewTableView: tblInterview, taskTableview: tblTask)
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.start(collectionView: colTags, interviewTableView: nil, taskTableview: nil)
    }
    // MARK: - Functions -
    func setUp() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "list.number"), style: .done, target: self, action: #selector(btnChecklist))
        let editButton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .done, target: self, action: #selector(btnEditApply))
        navigationItem.rightBarButtonItems = [barButton, editButton]
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
    @objc func btnChecklist() {
        viewModel.checklist(sender: self)
    }
    @objc func btnEditApply() {
        viewModel.editApply(sender: self)
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
// MARK: - Extensions -
extension ApplyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === tblInterview {
            viewModel.selectInterview(at: indexPath, sender: self)
        }
        if tableView === tblTask {
            viewModel.selectTask(at: indexPath, sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension ApplyViewController: ApplyViewModelDelegate {
    func applyInfo(_ applyInfo : ApplyViewModel.ApplyInfo) {
        heartState = applyInfo.isFavorite
        btnCompanyName.setTitle(applyInfo.companyName, for: .normal)
        lblPassedTime.text = applyInfo.timeElapsed
        lblLocation.text = applyInfo.location
        lblState.text = applyInfo.state
        btnResume.setTitle(applyInfo.resume, for: .normal)
    }
}
