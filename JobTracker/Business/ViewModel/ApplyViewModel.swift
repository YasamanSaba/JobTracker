//
//  ApplyViewModel.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/25/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class ApplyViewModel: NSObject {
    
    // MARK: -
    struct ApplyInfo {
        let companyName: String
        let jobOfferURL: URL
        let location: String
        let timeElapsed: String
        let state: String
        let resume: String
    }
    
    private let service: ApplyServiceType
    private let apply: Apply
    var resumeResultController: NSFetchedResultsController<Resume>!
    var statePickerView: UIPickerView?
    var resumePickerView: UIPickerView?
    var states: [Status] = []
    init(service: ApplyServiceType, apply: Apply) {
        self.service = service
        self.apply = apply
    }
    func configureResume(pickerView: UIPickerView) {
        pickerView.accessibilityIdentifier = "ResumePickerView"
        resumeResultController = service.getAllResumeVersion()
        resumeResultController.delegate = self
        do {
            try resumeResultController.performFetch()
            self.resumePickerView = pickerView
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.selectRow(resumeResultController.fetchedObjects?.firstIndex(of: apply.resume!) ?? 0, inComponent: 0, animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    func configureState(pickerView: UIPickerView) {
        self.states = service.getAllState()
        pickerView.accessibilityIdentifier = "StatePickerView"
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(states.firstIndex(of: apply.statusEnum ?? Status.hr) ?? 0, inComponent: 0, animated: true)
    }
    func getApplyInfo() -> ApplyInfo {
        var components: DateComponents? = nil
        if let appliedTime = apply.date {
            let calendar = Calendar.current
            components = calendar.dateComponents([.day], from: appliedTime, to: Date())
        }
        return ApplyInfo(companyName: apply.company?.title ?? "Unknown", jobOfferURL: apply.jobLink ?? URL(string: "www.google.com")!, location: "\(apply.city?.country?.name ?? "Unknown"), \(apply.city?.name ?? "Unknown")", timeElapsed: "\(components?.day ?? 0) days ago",state: apply.statusEnum?.rawValue ?? "Unknown", resume: apply.resume?.version ?? "Unknown")
    }
    func changeState() {
    
    }
}
extension ApplyViewModel: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.accessibilityIdentifier == "ResumePickerView", let objects = resumeResultController.fetchedObjects {
            return objects.count
        }
        if pickerView.accessibilityIdentifier == "StatePickerView" {
            return self.states.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.accessibilityIdentifier == "ResumePickerView", let objects = resumeResultController.fetchedObjects {
            return objects[row].version ?? ""
        }
        if pickerView.accessibilityIdentifier == "StatePickerView" {
            return self.states[row].rawValue
        }
        return ""
    }
}
extension ApplyViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.resumePickerView?.reloadAllComponents()
    }
}
