//
//  FeedbackTVC.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 1/26/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit
import TGPControls

class FeedbackTVC: ISTableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    private let toolBrokenHeaders = ["Your Name", "Feedback", "Tool", "Problem", "Comments", ""]
    private let toolBrokenPrototypes = [["namePrototype"],
                              ["pickerHeaderPrototype", "pickerDropdownPrototype"],
                              ["pickerHeaderPrototype", "pickerDropdownPrototype", "pickerHeaderPrototype", "pickerDropdownPrototype"],
                              ["pickerHeaderPrototype", "pickerDropdownPrototype"],
                              ["commentsPrototype"],
                              ["submitPrototype"]]
    private let toolBrokenCells = [["Your Name"],
                              ["Feedback", "FeedbackDropdown"],
                              ["Group", "ToolGroupDropdown", "Tool", "ToolDropdown"],
                              ["Problem", "ProblemDropdown"],
                              ["Comments"],
                              ["Submit"]]
    private let piFeedbackHeaders = ["Your Name", "Feedback", "PI Name", "Rating", "Comments", ""]
    private let piFeedbackPrototypes = [["namePrototype"],
                           ["pickerHeaderPrototype", "pickerDropdownPrototype"],
                           ["piNamePrototype"],
                           ["ratingPrototype"],
                           ["commentsPrototype"],
                           ["submitPrototype"]]
    private let piFeedbackCells = [["Your Name"],
                           ["Feedback", "FeedbackDropdown"],
                           ["PI Name"],
                           ["Rating"],
                           ["Comments"],
                           ["Submit"]]
    private let generalFeedbackHeaders = ["YourName", "Feedback", "Comments", ""]
    private let generalFeedbackPrototypes = [["namePrototype"],
                                ["pickerHeaderPrototype", "pickerDropdownPrototype"],
                                ["commentsPrototype"],
                                ["submitPrototype"]]
    private let generalFeedbackCells = [["Your Name"],
                                 ["Feedback", "FeedbackDropdown"],
                                 ["Comments"],
                                 ["Submit"]]

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
    var tools: [Tool]!
    var pickerValues = ["Feedback": ["Tool Broken", "PI Feedback", "General Feedback"],
                        "Group": [],
                        "Tool": [],
                        "Problem": ["Nozzle Not Extruding", "Bed Shifted"]]

    override func viewDidLoad() {
        super.viewDidLoad()

        name = UserDefaults.standard.string(forKey: "Name")!

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        let apiEvalGroup = DispatchGroup()

        apiEvalGroup.enter()
        SumsApi.EquipmentGroup.Tools(completion: { (tools) in
            self.tools = tools
            var equipmentGroups = Set<String>()
            for tool in tools {
                if tool.locationId != 0 {
                    equipmentGroups.insert(Location(fromTool: tool).locationName)
                }
            }
            self.pickerValues["Group"] = equipmentGroups.sorted()

            apiEvalGroup.leave()
        })

        apiEvalGroup.notify(queue: .main, execute: {
            self.toolGroupPicker.reloadAllComponents()
            self.setToolNames()

            for picker in self.pickerSelections.keys {
                self.pickerSelections[picker] = self.pickerValues[picker]![0]
            }

            self.setFeedbackType()
            self.tableView.reloadData()
        })
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

    func setToolNames() {
        var groupTools = [String]()
        for t in self.tools {
            if self.pickerSelections["Group"] != "" {
                if t.locationName == self.pickerSelections["Group"] {
                    groupTools.append(t.toolName)
                }
            } else if t.locationName == self.pickerValues["Group"]![0] {
                groupTools.append(t.toolName)
            }
        }
        self.pickerValues["Tool"] = groupTools.sorted()
        self.pickerSelections["Tool"] = self.pickerValues["Tool"]![0]

        self.toolPicker.reloadComponent(0)
    }

    // MARK: - Table View Data Source/Delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return currentPrototypes.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel?.textColor = Theme.accentTertiary
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPrototypes[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return currentHeaders[section]
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if currentHeaders[section] == "" {
            return UITableViewAutomaticDimension
        }
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
                cell.titleLabel?.textColor = Theme.title
                cell.titleLabel?.text = name
            } else {
                cell.titleLabel?.textColor = Theme.text
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
        case "piNamePrototype":
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as! FeedbackPINameCell
            return cell
        case "ratingPrototype":
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as! FeedbackRatingCell
            return cell
        case "commentsPrototype":
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath) as! FeedbackCommentsCell
            return cell
        case "submitPrototype":
            let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath)
            cell.backgroundColor = Theme.accentPrimary
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
        } else if prototype == "submitPrototype" {
            let feedbackType = self.pickerValues["Feedback"]![feedbackTypePicker.selectedRow(inComponent: 0)]
            if feedbackType == "Tool Broken" {
                let username = UserDefaults.standard.string(forKey: "Username")!
                let password = UserDefaults.standard.string(forKey: "UserKey")!
                let loginString = String(format: "%@:%@", username, password)
                let loginData = loginString.data(using: String.Encoding.utf8)!
                let base64LoginString = loginData.base64EncodedString()
                
                // create the request
                let url = URL(string: "https://is-apps.me.gatech.edu/api/v1-0/feedback/tool_broken")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
                let apiKey = "88c0a47e-6396-4463-87f5-c726c1da9874"
                request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
                
                var postString = ""
                let locName = self.pickerValues["Group"]![toolGroupPicker.selectedRow(inComponent: 0)]
                let id = UserDefaults.standard.string(forKey: "DepartmentId")

                let json: [String: Any] = ["equipment_group_id": id,
                                           "username": username,
                                           "problem": self.pickerValues["Problem"]![problemPicker.selectedRow(inComponent: 0)],
                                           "tool_group_name": locName,
                                           "tool_name": self.pickerValues["Tool"]![toolPicker.selectedRow(inComponent: 0)],
                                           "comments": "No comment"]
                print(json)
                let jsonData = try? JSONSerialization.data(withJSONObject: json)
                
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {                                                 // check for fundamental networking error
                        print("error=\(error)")
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(response)")
                    }
                    self.alert(err: ((response as? HTTPURLResponse)?.statusCode)!)
                    let responseString = String(data: data, encoding: .utf8)
                    print("responseString = \(responseString)")
                }
                task.resume()
            } else if feedbackType == "PI Feedback" {
                let username = UserDefaults.standard.string(forKey: "Username")!
                let password = UserDefaults.standard.string(forKey: "UserKey")!
                let loginString = String(format: "%@:%@", username, password)
                let loginData = loginString.data(using: String.Encoding.utf8)!
                let base64LoginString = loginData.base64EncodedString()
                
                // create the request
                let url = URL(string: "https://is-apps.me.gatech.edu/api/v1-0/feedback/staff")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
                let apiKey = "88c0a47e-6396-4463-87f5-c726c1da9874"
                request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
                
                let id = UserDefaults.standard.string(forKey: "DepartmentId")
                
                let json: [String: Any] = ["equipment_group_id": id,
                                           "username": username,
                                           "staff_name": "",
                                           "rating": 4,
                                           "comments": "No comment"]
                print(json)
                let jsonData = try? JSONSerialization.data(withJSONObject: json)
                
                request.httpBody = jsonData

                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {                                                 // check for fundamental networking error
                        print("error=\(error)")
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(response)")
                    }
                    self.alert(err: ((response as? HTTPURLResponse)?.statusCode)!)
                    let responseString = String(data: data, encoding: .utf8)
                    print("responseString = \(responseString)")
                }
                task.resume()
            } else if feedbackType == "General Feedback" {
                let username = UserDefaults.standard.string(forKey: "Username")!
                let password = UserDefaults.standard.string(forKey: "UserKey")!
                let loginString = String(format: "%@:%@", username, password)
                let loginData = loginString.data(using: String.Encoding.utf8)!
                let base64LoginString = loginData.base64EncodedString()
                
                // create the request
                let url = URL(string: "https://is-apps.me.gatech.edu/api/v1-0/feedback/general")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
                let apiKey = "88c0a47e-6396-4463-87f5-c726c1da9874"
                request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
                
                let id = UserDefaults.standard.string(forKey: "DepartmentId")
                
                let json: [String: Any] = ["equipment_group_id": id,
                                           "username": username,
                                           "comments": "No comment"]
                print(json)
                let jsonData = try? JSONSerialization.data(withJSONObject: json)
                
                request.httpBody = jsonData
                
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {                                                 // check for fundamental networking error
                        print("error=\(error)")
                        return
                    }
                    
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(response)")
                    }
                    self.alert(err: ((response as? HTTPURLResponse)?.statusCode)!)
                    let responseString = String(data: data, encoding: .utf8)
                    print("responseString = \(responseString)")
                }
                task.resume()
            }
        }
    }
    
    func alert(err:Int) {
        if err == 200 {
            let alert = UIAlertController(title: "Success", message: "Thank you for submitting feedback!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if err == 400 {
            let alert = UIAlertController(title: "Error", message: "Error submitting feedback.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if err == 500 {
            let alert = UIAlertController(title: "Error", message: "Internal server error.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

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
        let attributes = [NSAttributedStringKey.foregroundColor : Theme.title]
        if pickerView == self.feedbackTypePicker {
            return NSAttributedString(string:(pickerValues["Feedback"]?[row])!, attributes: attributes)
        } else if pickerView == self.toolGroupPicker {
            return NSAttributedString(string:(pickerValues["Group"]?[row])!, attributes: attributes)
        } else if pickerView == self.toolPicker {
            return NSAttributedString(string:(pickerValues["Tool"]?[row])!, attributes: attributes)
        } else if pickerView == self.problemPicker {
            return NSAttributedString(string:(pickerValues["Problem"]?[row])!, attributes: attributes)
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
            setToolNames()
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

}
