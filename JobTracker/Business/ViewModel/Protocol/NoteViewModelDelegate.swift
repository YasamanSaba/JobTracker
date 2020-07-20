//
//  NoteViewModelDelegate.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 7/19/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

protocol NoteViewModelDelegate: ViewModelDelegate {
    func title(text: String)
    func body(text: String)
}
