//
//  EquipmentCell.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 1/26/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class EquipmentCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusIcon: UIView!

    private var _status: Tool.Status = Tool.Status.AVAILABLE
    var status: Tool.Status {
        get {
            return _status
        }
        set {
            _status = newValue
            self.statusLabel.text = _status.rawValue

            switch(_status) {
            case .AVAILABLE:
                self.statusIcon.backgroundColor = UIColor(named: "Status_Available")
            case .INUSE:
                self.statusIcon.backgroundColor = UIColor(named: "Status_InUse")
            case .DOWN:
                self.statusIcon.backgroundColor = UIColor(named: "Status_Down")
            case .UNKNOWN:
                self.statusIcon.backgroundColor = UIColor(named: "Status_Unknown")
            }
        }
    }

}
