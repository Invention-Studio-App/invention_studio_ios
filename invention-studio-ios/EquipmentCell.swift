//
//  EquipmentCell.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 1/26/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class EquipmentCell: UITableViewCell {

    enum Status: String {
        case available = "Available"
        case inUse = "In Use"
        case down = "Down"
    }

    let statusColorAvailable = UIColor(red: 0/255, green: 204/255, blue: 0/255, alpha: 255/255)
    let statusColorInUse = UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 255/255)
    let statusColorDown = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 255/255)

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusIcon: UIView!

    private var _status: Status = Status.available
    var status: Status {
        get {
            return _status
        }
        set {
            _status = newValue
            self.statusLabel.text = _status.rawValue

            switch(_status) {
            case .available:
                self.statusIcon.backgroundColor = statusColorAvailable
            case .inUse:
                self.statusIcon.backgroundColor = statusColorInUse
            case .down:
                self.statusIcon.backgroundColor = statusColorDown
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        let statusColor = statusIcon.backgroundColor
        super.setSelected(selected, animated: animated)
        if selected {
            statusIcon.backgroundColor = statusColor
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let statusColor = statusIcon.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            statusIcon.backgroundColor = statusColor
        }
    }

}
