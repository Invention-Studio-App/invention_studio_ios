//
//  FeedbackTVC.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 1/26/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit
import TGPControls

class FeedbackTVC: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    private let toolBrokenHeaders = ["Your Name", "Feedback", "Tool", "Problem", "Comments"]
    private let toolBrokenPrototypes = [["namePrototype"],
                              ["pickerHeaderPrototype", "pickerDropdownPrototype"],
                              ["pickerHeaderPrototype", "pickerDropdownPrototype", "pickerHeaderPrototype", "pickerDropdownPrototype"],
                              ["pickerHeaderPrototype", "pickerDropdownPrototype"],
                              ["commentsPrototype"]]
    private let toolBrokenCells = [["Your Name"],
                              ["Feedback", "FeedbackDropdown"],
                              ["Group", "ToolGroupDropdown", "Tool", "ToolDropdown"],
                              ["Problem", "ProblemDropdown"],
                              ["Comments"]]
    private let piFeedbackHeaders = ["Your Name", "Feedback", "Rating", "Comments"]
    private let piFeedbackPrototypes = [["namePrototype"],
                           ["pickerHeaderPrototype", "pickerDropdownPrototype"],
                           ["ratingPrototype"],
                           ["commentsPrototype"]]
    private let piFeedbackCells = [["Your Name"],
                           ["Feedback", "FeedbackDropdown"],
                           ["Rating"],
                           ["Comments"]]
    private let generalFeedbackHeaders = ["YourName", "Feedback", "Comments"]
    private let generalFeedbackPrototypes = [["namePrototype"],
                                ["pickerHeaderPrototype", "pickerDropdownPrototype"],
                                ["commentsPrototype"]]
    private let generalFeedbackCells = [["Your Name"],
                                 ["Feedback", "FeedbackDropdown"],
                                 ["Comments"]]

    private var currentHeaders = [String]()
    private var currentPrototypes = [[String]]()
    private var currentCells = [[String]]()

    private var currentDropdownHeader: IndexPath? = nil
    private var currentDropdown: IndexPath? = nil

    private var feedbackTypePicker: UIPickerView = UIPickerView()
    private var toolGroupPicker: UIPickerView = UIPickerView()
    private var toolPicker: UIPickerView = UIPickerView()
    private var problemPicker: UIPickerView = UIPickerView()
    private var pickerSelections = ["Feedback": "", "Group": "", "Tool": "", "Problem": ""]

    var name = ""
    var pickerValues = ["Feedback": ["Tool Broken", "PI Feedback", "General Feedback"],
                        "Group": ["3D Printers", "Laser Cutters", "Waterjet"],
                        "Tool": ["Baymax", "Rick"],
                        "Problem": ["Nozzle Not Extruding", "Bed Shifted"]]

    override func viewDidLoad() {
        super.viewDidLoad()

        name = UserDefaults.standard.string(forKey: "UserName")!

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        for picker in pickerSelections.keys {
            pickerSelections[picker] = pickerValues[picker]![0]
        }

        setFeedbackType()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setFeedbackType() {
        switch pickerSelections["Feedback"]! {
        case "Tool Broken":
            currentHeaders = toolBrokenHeaders
            currentPrototypes = toolBrokenPrototypes
            currentCells = toolBrokenCells
        case "PI Feedback":
            currentHeaders = piFeedbackHeaders
            currentPrototypes = piFeedbackPrototypes
            currentCells = piFeedbackCells
        case "General Feedback":
            currentHeaders = generalFeedbackHeaders
            currentPrototypes = generalFeedbackPrototypes
            currentCells = generalFeedbackCells
        default:
            break
        }
    }

    // MARK: - Table View Data Source/Delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return currentPrototypes.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel?.textColor = UIColor(named: "ISLight_AccentTertiary")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPrototypes[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return currentHeaders[section]
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prototype = currentPrototypes[indexPath.section][indexPath.row]
        let cellName = currentCells[indexPath.section][indexPath.row]
        switch prototype {
        case "namePrototype":
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as! FeedbackNameCell
            cell.anonymousSwitch.addTarget(self, action: #selector(anonymousSwitchChanged), for: UIControlEvents.valueChanged)

            if cell.anonymousSwitch.isOn {
                cell.titleLabel?.textColor = UIColor(named: "ISLight_Title")
                cell.titleLabel?.text = name
            } else {
                cell.titleLabel?.textColor = UIColor(named: "ISLight_Text")
                cell.titleLabel?.text = "Anonymous"
            }
            return cell
        case "pickerHeaderPrototype":
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as! FeedbackPickerHeaderCell
            cell.textLabel?.text = cellName
            cell.detailTextLabel?.text = pickerSelections[cellName]

            if indexPath == currentDropdownHeader {
                cell.detailTextLabel?.textColor = UIColor(named: "ISLight_AccentPrimary")
            } else {
                cell.detailTextLabel?.textColor = UIColor(named: "ISLight_Title")
            }
            return cell
        case "pickerDropdownPrototype":
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as! FeedbackPickerDropdownCell
            switch cellName {
            case "FeedbackDropdown":
                feedbackTypePicker = cell.pickerView
                feedbackTypePicker.dataSource = self
                feedbackTypePicker.delegate = self
                cell.pickerView.selectRow(pickerValues["Feedback"]!.index(of: pickerSelections["Feedback"]!)!, inComponent: 0, animated: false)
            case "ToolGroupDropdown":
                toolGroupPicker = cell.pickerView
                toolGroupPicker.dataSource = self
                toolGroupPicker.delegate = self
                cell.pickerView.selectRow(pickerValues["Group"]!.index(of: pickerSelections["Group"]!)!, inComponent: 0, animated: false)
            case "ToolDropdown":
                toolPicker = cell.pickerView
                toolPicker.dataSource = self
                toolPicker.delegate = self
                cell.pickerView.selectRow(pickerValues["Tool"]!.index(of: pickerSelections["Tool"]!)!, inComponent: 0, animated: false)
            case "ProblemDropdown":
                problemPicker = cell.pickerView
                problemPicker.dataSource = self
                problemPicker.delegate = self
                cell.pickerView.selectRow(pickerValues["Problem"]!.index(of: pickerSelections["Problem"]!)!, inComponent: 0, animated: false)
            default:
                break
            }
            return cell
        case "ratingPrototype":
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as! FeedbackRatingCell
            return cell
        case "commentsPrototype":
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as! FeedbackCommentsCell
            return cell
        default:
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let prototype = currentPrototypes[indexPath.section][indexPath.row]
        if prototype == "pickerDropdownPrototype" {
            if indexPath == currentDropdown {
                return 216
            }
            return 0
        } else if prototype == "commentsPrototype" {
            return 216
        } else if prototype == "ratingPrototype" {
            return 77
        }
        return 44
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prototype = currentPrototypes[indexPath.section][indexPath.row]
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
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    //MARK: - Picker View Delegate

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.feedbackTypePicker {
            return pickerValues["Feedback"]!.count
        } else if pickerView == self.toolGroupPicker {
            return pickerValues["Group"]!.count
        } else if pickerView == self.toolPicker {
            return pickerValues["Tool"]!.count
        } else if pickerView == self.problemPicker {
            return pickerValues["Problem"]!.count
        } else {
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.feedbackTypePicker {
            return pickerValues["Feedback"]?[row]
        } else if pickerView == self.toolGroupPicker {
            return pickerValues["Group"]?[row]
        } else if pickerView == self.toolPicker {
            return pickerValues["Tool"]?[row]
        } else if pickerView == self.problemPicker {
            return pickerValues["Problem"]?[row]
        } else {
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == self.feedbackTypePicker {
            return NSAttributedString(string:(pickerValues["Feedback"]?[row])!, attributes: [NSAttributedStringKey.foregroundColor : UIColor(named: "ISLight_Title")!])
        } else if pickerView == self.toolGroupPicker {
            return NSAttributedString(string:(pickerValues["Group"]?[row])!, attributes: [NSAttributedStringKey.foregroundColor : UIColor(named: "ISLight_Title")!])
        } else if pickerView == self.toolPicker {
            return NSAttributedString(string:(pickerValues["Tool"]?[row])!, attributes: [NSAttributedStringKey.foregroundColor : UIColor(named: "ISLight_Title")!])
        } else if pickerView == self.problemPicker {
            return NSAttributedString(string:(pickerValues["Problem"]?[row])!, attributes: [NSAttributedStringKey.foregroundColor : UIColor(named: "ISLight_Title")!])
        } else {
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let title = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        if pickerView == self.feedbackTypePicker {
            self.pickerSelections["Feedback"] = title
            setFeedbackType()
        } else if pickerView == self.toolGroupPicker {
            self.pickerSelections["Group"] = title
        } else if pickerView == self.toolPicker {
            self.pickerSelections["Tool"] = title
        } else if pickerView == self.problemPicker {
            self.pickerSelections["Problem"] = title
        }
        tableView.reloadData()
    }

    /// MARK: - Supporting Functions

    @objc func anonymousSwitchChanged() {
        tableView.reloadData()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
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
