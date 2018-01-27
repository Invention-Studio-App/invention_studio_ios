//
//  EquipmentVC.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 1/26/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class EquipmentVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var segmentContainer: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!

    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var statusIcon: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var reportProblemTableView: UITableView!
    
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
                self.statusIcon.backgroundColor = UIColor(named: "StatusColorAvailable")
            case .INUSE:
                self.statusIcon.backgroundColor = UIColor(named: "StatusColorInUse")
            case .DOWN:
                self.statusIcon.backgroundColor = UIColor(named: "StatusColorDown")
            case .UNKNOWN:
                self.statusIcon.backgroundColor = UIColor(named: "StatusColorUnknown")
            }
        }
    }
    var segmentViews = Array<UIView>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.segmentViews.append(informationView)
        self.segmentViews.append(reportProblemTableView)
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: segmentContainer.frame.minX, y: segmentContainer.frame.maxY))
        linePath.addLine(to: CGPoint(x: segmentContainer.frame.maxX, y: segmentContainer.frame.maxY))
        line.path = linePath.cgPath
        line.strokeColor = UIColor.lightGray.cgColor
        line.lineWidth = 0.5
        segmentContainer.layer.addSublayer(line)

        status = Tool.Status.AVAILABLE
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        for (i, view) in segmentViews.enumerated() {
            if i == sender.selectedSegmentIndex {
                view.isHidden = false
            } else {
                view.isHidden = true
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportProblemPrototype", for: indexPath)

        cell.textLabel?.text = "Testing"

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
