//
//  EquipmentVC.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 1/26/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class EquipmentVC: ISViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var segmentContainer: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var segmentContainerBorderLine = CAShapeLayer()

    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var informationScrollView: UIScrollView!
    private let refreshControl = UIRefreshControl()
    private let statusTitleLabel = UILabel()
    private let statusIcon = UIView()
    private let statusLabel = UILabel()

    @IBOutlet weak var reportProblemTableView: UITableView!

    private let toolBrokenHeaders = ["Your Name", "Problem", "Comments", ""]
    private let toolBrokenPrototypes = [["namePrototype"],
                                        ["pickerHeaderPrototype", "pickerDropdownPrototype"],
                                        ["commentsPrototype"],
                                        ["submitPrototype"]]
    private let toolBrokenCells = [["Your Name"],
                                   ["Problem", "ProblemDropdown"],
                                   ["Comments"],
                                   ["Submit"]]

    private var currentDropdownHeader: IndexPath? = nil
    private var currentDropdown: IndexPath? = nil

    private var toolGroupPicker: UIPickerView = UIPickerView()
    private var toolPicker: UIPickerView = UIPickerView()
    private var problemPicker: UIPickerView = UIPickerView()
    private var pickerSelections = ["Problem": ""]

    private var anonymousSwitch: UISwitch? = nil
    private var commentBox: UITextView? = nil

    var name = ""
    var pickerValues = ["Problem": ["Nozzle Not Extruding", "Bed Shifted"]]
    var location: Location!
    var tools = [Tool]()
    var tool: Tool!
    var backProp:(([Tool]) -> ())?
    var informationTextView = UITextView()

    private var _status: Tool.Status = Tool.Status.UNKNOWN
    var status: Tool.Status {
        get {
            return _status
        }
        set {
            _status = newValue
            statusLabel.text = _status.rawValue
            statusLabel.frame.size = statusLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 21))

            switch(_status) {
            case .AVAILABLE:
                statusIcon.backgroundColor = UIColor(named: "Status_Available")
            case .INUSE:
                statusIcon.backgroundColor = UIColor(named: "Status_InUse")
            case .DOWN:
                statusIcon.backgroundColor = UIColor(named: "Status_Down")
            case .UNKNOWN:
                statusIcon.backgroundColor = UIColor(named: "Status_Unknown")
            }
        }
    }
    var segmentViews = Array<UIView>()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.delegate = self
        /**
         ** General Setup
         **/
        status = tool.status()

        /**
         ** Set Up Segment Controller
         **/
        segmentContainer.backgroundColor = Theme.headerFooter
        segmentContainerBorderLine.strokeColor = Theme.accentSecondary.cgColor

        segmentViews.append(informationView)
        segmentViews.append(reportProblemTableView)

        /**
         ** Set Up Information View
         **/

        //Set Up Refresh Control
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        self.informationScrollView.addSubview(refreshControl)

        //Set Up Image
        let informationImageView = UIImageView()
        informationImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width / 16.0 * 9.0)
        //TODO: Use dynamic photo
        informationImageView.image = InventionStudioImages.imageForTool(locationName: self.tool.locationName, toolName: self.tool.toolName)
        informationImageView.contentMode = UIViewContentMode.scaleAspectFill
        informationImageView.clipsToBounds = true
        informationScrollView.addSubview(informationImageView)

        //Set Up Status Label
        //"Status:" Label
        statusTitleLabel.text = "Status:"
        let statusTitleLabelSize = statusTitleLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 21))
        statusTitleLabel.frame = CGRect(x: 16, y: informationImageView.frame.maxY + 16, width: statusTitleLabelSize.width, height: 21)
        informationScrollView.addSubview(statusTitleLabel)

        //Status icon
        let statusIconSize: CGFloat = 16.0
        statusIcon.frame.size = CGSize(width: statusIconSize, height: statusIconSize)
        statusIcon.frame.origin.x = statusTitleLabel.frame.maxX + 8
        statusIcon.center.y = statusTitleLabel.center.y
        statusIcon.layer.cornerRadius = statusIconSize / 2.0
        informationScrollView.addSubview(statusIcon)

        //Status label
        statusLabel.frame.origin.x = statusIcon.frame.maxX + 8
        statusLabel.center.y = statusTitleLabel.center.y
        informationScrollView.addSubview(statusLabel)

        //Set Up TextView
        informationTextView.isEditable = false
        informationTextView.isSelectable = false
        informationTextView.isScrollEnabled = false
        informationTextView.bounces = false
        informationTextView.bouncesZoom = false
        informationTextView.backgroundColor = UIColor.clear
        informationTextView.font = UIFont.systemFont(ofSize: 16)
        let attributedString = try! NSMutableAttributedString(
            data: tool.toolDescription.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        let attributesDict = [NSAttributedStringKey.foregroundColor: Theme.text,
                              NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
        attributedString.addAttributes(attributesDict, range: NSMakeRange(0, attributedString.length))
        informationTextView.attributedText = attributedString
        let informationTextViewSize = informationTextView.sizeThatFits(CGSize(width: view.frame.width - 16, height: CGFloat.greatestFiniteMagnitude))
        informationTextView.frame = CGRect(x: 8, y: statusTitleLabel.frame.maxY + 8, width: view.frame.width - 16, height: informationTextViewSize.height)
        informationScrollView.addSubview(informationTextView)

        //Set ScrollView content size
        informationScrollView.contentSize = CGSize(width: view.frame.width, height: informationTextView.frame.maxY + 8)

        /**
         ** Set Up "Report Problem" TableView
         **/

        reportProblemTableView.backgroundColor = Theme.background
        reportProblemTableView.tintColor = Theme.accentPrimary

        name = UserDefaults.standard.string(forKey: "Name")!

        //Dismiss keyboard on tap
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        //Scroll when keyboard appears
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        //Set Up PickerView
        for picker in pickerSelections.keys {
            pickerSelections[picker] = pickerValues[picker]![0]
        }
        reportProblemTableView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: segmentContainer.frame.minX, y: segmentContainer.frame.maxY))
        linePath.addLine(to: CGPoint(x: segmentContainer.frame.maxX, y: segmentContainer.frame.maxY))
        segmentContainerBorderLine.path = linePath.cgPath
        segmentContainerBorderLine.lineWidth = 0.5
        segmentContainer.layer.addSublayer(segmentContainerBorderLine)
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

    //MARK: - Table View Data Source/Delegate

    func numberOfSections(in tableView: UITableView) -> Int {
        return toolBrokenPrototypes.count
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel?.textColor = Theme.accentTertiary
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toolBrokenPrototypes[section].count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if toolBrokenHeaders[section] == "" {
            return UITableViewAutomaticDimension
        }
        return 66
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return toolBrokenHeaders[section]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let prototype = toolBrokenPrototypes[indexPath.section][indexPath.row]
        if prototype == "pickerDropdownPrototype" {
            if indexPath == currentDropdown {
                return 216
            }
            return 0
        } else if prototype == "commentsPrototype" {
            return 216
        }
        return 44
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prototype = toolBrokenPrototypes[indexPath.section][indexPath.row]
        let cellName = toolBrokenCells[indexPath.section][indexPath.row]
        switch prototype {
        case "namePrototype":
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as! FeedbackNameCell
            self.anonymousSwitch = cell.anonymousSwitch
            cell.anonymousSwitch.addTarget(self, action: #selector(anonymousSwitchChanged), for: UIControlEvents.valueChanged)
            if cell.anonymousSwitch.isOn {
                cell.titleLabel?.text = name
            } else {
                cell.titleLabel?.text = "Anonymous"
            }
            return cell
        case "pickerHeaderPrototype":
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath)
            cell.textLabel?.text = cellName
            cell.detailTextLabel?.text = pickerSelections[cellName]

            if indexPath == currentDropdownHeader {
                cell.detailTextLabel?.textColor = Theme.accentPrimary
            } else {
                cell.detailTextLabel?.textColor = Theme.title
            }
            return cell
        case "pickerDropdownPrototype":
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as! FeedbackPickerDropdownCell
            switch cellName {
            case "ProblemDropdown":
                problemPicker = cell.pickerView
                problemPicker.dataSource = self
                problemPicker.delegate = self
                cell.pickerView.selectRow(pickerValues["Problem"]!.index(of: pickerSelections["Problem"]!)!, inComponent: 0, animated: false)
            default:
                break
            }
            return cell
        case "commentsPrototype":
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as! FeedbackCommentsCell
            self.commentBox = cell.commentBox
            cell.commentBox.delegate = self
            return cell
        case "submitPrototype":
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath)
            cell.backgroundColor = Theme.accentPrimary
            return cell
        default:
            return UITableViewCell()
        }
    }

    //MARK: - Picker View Delegate

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == problemPicker {
            return pickerValues["Problem"]!.count
        } else {
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == problemPicker {
            return pickerValues["Problem"]?[row]
        } else {
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == problemPicker {
            return NSAttributedString(string:(pickerValues["Problem"]?[row])!, attributes: [NSAttributedStringKey.foregroundColor : Theme.title])
        } else {
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let title = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        if pickerView == problemPicker {
            pickerSelections["Problem"] = title
        }
        reportProblemTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prototype = toolBrokenPrototypes[indexPath.section][indexPath.row]
        let oldDropdownSection : Int? = currentDropdown?.section
        if prototype == "pickerHeaderPrototype" {
            if indexPath == currentDropdownHeader {
                currentDropdownHeader = nil
                currentDropdown = nil
            } else {
                currentDropdownHeader = indexPath
                currentDropdown = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            }
            if oldDropdownSection != nil && oldDropdownSection != indexPath.section {
                tableView.reloadSections([oldDropdownSection!], with: UITableViewRowAnimation.automatic)
            }
            tableView.reloadSections([indexPath.section], with: UITableViewRowAnimation.automatic)
        } else if prototype == "submitPrototype" {
            let form = ToolBrokenFeedbackForm()
            form.equipment_group_id = self.tool.equipmentGroupId

            if self.anonymousSwitch!.isOn {
                form.username = UserDefaults.standard.string(forKey: "Username")!
            } else {
                form.username = "anonymous"
            }

            form.problem = self.pickerSelections["Problem"]!
            form.tool_group_name = self.tool.locationName
            form.tool_name = self.tool.toolName
            form.comments = self.commentBox!.text


            InventionStudioApi.Feedback.tool_broken(form: form, completion: { message in
                let parts = message.components(separatedBy: ":")
                self.alert(title: parts[0], message: parts[1])
            })
        }
    }

    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            if let anonymousSwitch = self.anonymousSwitch {
                anonymousSwitch.setOn(true, animated: false)
            }
            if let commentBox = self.commentBox {
                commentBox.text = nil
            }
            self.reportProblemTableView.setContentOffset(CGPoint.zero, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }



    // MARK: - Supporting Functions

    @objc func anonymousSwitchChanged() {
        reportProblemTableView.reloadData()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
        let contentInsets = UIEdgeInsets.zero
        UIView.animate(withDuration: 0.3) {
            self.reportProblemTableView.contentInset = contentInsets
            self.reportProblemTableView.scrollIndicatorInsets = contentInsets
        }
    }

    @objc func keyboardWasShown(_ notification : Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            reportProblemTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
            reportProblemTableView.contentOffset = CGPoint(x: 0, y:keyboardSize.height)
        }
    }

    @objc func refresh(_ sender: UIRefreshControl) {
        sender.attributedTitle = NSAttributedString(string: "Fetching tool info...")
        SumsApi.EquipmentGroup.Tools(completion: { (tools) in
            self.tools = tools
            self.backProp?(tools)
            var fTool = true
            for tool in tools {
                if (fTool && tool.toolId == self.tool.toolId) {
                    fTool = false
                    DispatchQueue.main.async {
                        self.status = tool.status()
                        self.tool = tool
                        let attributedString = try! NSMutableAttributedString(
                            data: tool.toolDescription.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                            options: [.documentType: NSAttributedString.DocumentType.html],
                            documentAttributes: nil)
                        let attributesDict = [NSAttributedStringKey.foregroundColor: Theme.text,
                                              NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
                        attributedString.addAttributes(attributesDict, range: NSMakeRange(0, attributedString.length))
                        self.informationTextView.attributedText = attributedString
                        
                        //Set ScrollView content size
                        self.informationScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.informationTextView.frame.maxY + 8)
                        sender.endRefreshing()
                    }
                }
            }
            
        })
    }

}


