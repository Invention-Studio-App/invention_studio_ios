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

    let feedbackTypes = ["Machine Broken", "PI Feedback", "General Feedback"]
    let machineBrokenHeaders = ["Your Name", "Feedback", "Machine", "Problem", "Comments"]
    let machineBrokenCells = [["namePrototype"],
                              ["pickerHeaderPrototype", "pickerDropdownPrototype"],
                              ["pickerHeaderPrototype", "pickerDropdownPrototype", "pickerHeaderPrototype", "pickerDropdownPrototype"],
                              ["pickerHeaderPrototype", "pickerDropdownPrototype"],
                              ["commentsPrototype"]]
    let piFeedbackHeaders = ["Your Name", "Feedback", "Rating", "Comments"]
    let piFeedbackCells = [["namePrototype"],
                           ["pickerHeaderPrototype", "pickerDropdownPrototype"],
                           ["ratingPrototype"],
                           ["commentsPrototype"]]
    let generalFeedbackHeaders = ["YourName", "Feedback", "Comments"]
    let generalFeedbackCells = [["namePrototype"],
                                ["pickerHeaderPrototype", "pickerDropdownPrototype"],
                                ["commentsPrototype"]]

    var currentHeaders : [String] = [String]()
    var currentCells : [[String]] = [[String]]()

    var feedbackTypePicker: UIPickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        feedbackTypePicker.dataSource = self
        feedbackTypePicker.delegate = self
        feedbackTypePicker.selectedRow(inComponent: 0)
        currentHeaders = machineBrokenHeaders
        currentCells = machineBrokenCells
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return currentCells.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCells[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return currentHeaders[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prototype = currentCells[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: prototype, for: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let prototype = currentCells[indexPath.section][indexPath.row]
        if prototype == "pickerDropdownPrototype" || prototype == "commentsPrototype" {
            return 216
        }
        return UITableViewAutomaticDimension
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
        return feedbackTypes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return feedbackTypes[row]
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
