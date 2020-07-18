//
//  AppliesTableViewCell.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/10/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class ApplyTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: ApplyTableViewCell.self)
    
    // MARK: - Outlets
    @IBOutlet weak var lblCountryFlag: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblApplyDate: UILabel!
    @IBOutlet weak var lblNumberOfInterviews: UILabel!
    @IBOutlet weak var lblNumberOfTasks: UILabel!
    @IBOutlet weak var lblCheckListStatus: UILabel!
    @IBOutlet weak var lblApplyStatus: UILabel!
    @IBOutlet weak var imgIsFavorite: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configure(apply: AppliesViewModel.ApplyItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMM-dd"
        lblApplyDate.text = dateFormatter.string(from: apply.date!)
        lblCountryFlag.text = apply.apply.city?.country?.flag
        lblCompanyName.text = apply.apply.company?.title
        lblNumberOfInterviews.text = String(apply.apply.interview?.count ?? 0)
        lblNumberOfTasks.text = String(apply.apply.task?.count ?? 0)
        let doneItems = apply.apply.checkListItem?.filter { ($0 as! CheckListItem).isDone }.count ?? 0
        let allItems = apply.apply.checkListItem?.count ?? 0
        lblCheckListStatus.text = "\(doneItems)/\(allItems)"
        switch apply.apply.statusEnum {
        case .ceo:
            lblApplyStatus.text = "CEO"
            lblApplyStatus.tintColor = .systemGreen
        case .challenge:
            lblApplyStatus.text = "Challenge"
            lblApplyStatus.tintColor = .systemOrange
        case .contract:
            lblApplyStatus.text = "Contract"
            lblApplyStatus.tintColor = .systemGreen
        case .hr:
            lblApplyStatus.text = "HR"
            lblApplyStatus.tintColor = .systemGreen
        case .inSite:
            lblApplyStatus.text = "inSite"
            lblApplyStatus.tintColor = .systemGreen
        case .rejected:
            lblApplyStatus.text = "Rejected"
            lblApplyStatus.tintColor = .systemRed
        case .tech:
            lblApplyStatus.text = "Technical"
            lblApplyStatus.tintColor = .systemGreen
        case .none:
            print("Unexpected status")
        }
        imgIsFavorite.isHidden = !(apply.apply.company?.isFavorite ?? false)
    }
}
