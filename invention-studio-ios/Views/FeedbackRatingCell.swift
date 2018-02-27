//
//  FeedbackRatingCell.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 1/30/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit
import TGPControls

class FeedbackRatingCell: UITableViewCell {

    @IBOutlet weak var camelLabels: TGPCamelLabels!
    @IBOutlet weak var slider: TGPDiscreteSlider!

    override func layoutSubviews() {
        camelLabels.upFontColor = Theme.accentPrimary
        camelLabels.downFontColor = Theme.title
        camelLabels.names = ["N/A", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        camelLabels.value = 0

        slider.tintColor = Theme.accentPrimary
        slider.minimumValue = 0
        slider.value = 0
        slider.ticksListener = camelLabels
    }

}
