//
//  FeedbackTVC.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 1/26/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class FeedbackTVC: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let feedbackTypes = ["Machine Broken", "PI Feedback", "General Feedback"]

    var feedbackTypePicker: UIPickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        feedbackTypePicker.dataSource = self
        feedbackTypePicker.delegate = self
        feedbackTypePicker.selectedRow(inComponent: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        switch feedbackTypePicker.selectedRow(inComponent: 0) {
        case 0: //Machine Broken
            return 5
        case 1: //PI Feedback
            return 4
        case 2: //General Feedback
            return 3
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0: //Your Name
            return 1
        case 1: //Type
            return 1
        case 2: //Custom
            switch feedbackTypePicker.selectedRow(inComponent: 0) {
            case 0: //Machine Broken
                return 2
            case 1: //PI Feedback
                return 1
            case 2: //General Feedback
                return 1
            default:
                return 0
            }
        case 3: //Custom
            switch feedbackTypePicker.selectedRow(inComponent: 0) {
            case 0: //Machine Broken
                return 1
            case 1: //PI Feedback
                return 1
            default: //Includes: General Feedback
                return 0
            }
        case 4: //Custom
            switch feedbackTypePicker.selectedRow(inComponent: 0) {
            case 0: //Machine Broken
                return 1
            default: //Includes: PI Feedback, General Feedback
                return 0
            }
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Your Name"
        case 1:
            return "Type"
        case 2:
            switch feedbackTypePicker.selectedRow(inComponent: 0) {
            case 0:
                return "Machine"
            case 1:
                return "Rating"
            case 2:
                return "Comments"
            default:
                return nil
            }
        case 3:
            switch feedbackTypePicker.selectedRow(inComponent: 0) {
            case 0:
                return "Problem"
            case 1:
                return "Comments"
            default:
                return nil
            }
        case 4:
            switch feedbackTypePicker.selectedRow(inComponent: 0) {
            case 0:
                return "Comments"
            default:
                return nil
            }
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentsPrototype", for: indexPath)

        // Configure the cell...

        return cell
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
