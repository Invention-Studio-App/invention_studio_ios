//
//  QueuesTVC.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 1/26/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class QueuesTVC: UITableViewController {

    let items = ["3D Printers", "Laser Cutters", "Waterjet"]
    var selectedSection: Int? = nil
    var groups = [String]()
    var users = [QueueUser]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshQueues(self)
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func refreshQueues(_ sender: Any) {
        SumsApi.EquipmentGroup.QueueGroups(completion: { (groups) in
            var gs = [String]()
            for group in groups {
                if (!(gs.contains(group.name))) {
                    gs.append(group.name)
                }
            }
            gs.sort()
            self.groups = gs
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        SumsApi.EquipmentGroup.QueueUsers(completion: { (users) in
            self.users = users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.groups.count
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 2
        for user in users {
            if (user.queueName == self.groups[section]) {
                count += 1
            }
        }
        if (count > 2) {
            count -= 1
        }
        return count
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            if let view = view as? UITableViewHeaderFooterView {
                view.textLabel?.textColor = UIColor(named: "ISLight_AccentTertiary")
            }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "To join a queue, head to the SUMS kiosk for the room you're interested in"
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return UITableViewAutomaticDimension
        default:
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "queuesPrototype", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = self.groups[indexPath.section]
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            cell.textLabel?.textColor = UIColor(named: "ISLight_Title")
        } else {
            var u = [QueueUser]()
            for user in self.users {
                if (user.queueName == self.groups[indexPath.section]) {
                    u.append(user)
                }
            }
            u.sort(by: { (userA, userB) in
                return userA.memberQueueLocation <= userB.memberQueueLocation
            })
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            // No users in the queue
            if (u.count == 0) {
                cell.textLabel?.text = "No users in queue"
            } else {
                cell.textLabel?.text = String(format: "%d. %@", u[indexPath.row - 1].memberQueueLocation, u[indexPath.row - 1].memberName)
                // If the current user, bold the text
                if (u[indexPath.row - 1].memberUserName == UserDefaults.standard.string(forKey: "Username")!) {
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                }
            }
            cell.textLabel?.textColor = UIColor(named: "ISLight_Title")
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.section == selectedSection {
            return UITableViewAutomaticDimension
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let oldSelectedSection: Int? = selectedSection
            if indexPath.section == selectedSection {
                selectedSection = nil
            } else {
                selectedSection = indexPath.section
            }
            if oldSelectedSection != nil && oldSelectedSection != selectedSection {
                tableView.reloadSections([oldSelectedSection!], with: UITableViewRowAnimation.fade)
            }
            tableView.reloadSections([indexPath.section], with: UITableViewRowAnimation.fade)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func refresh(_ sender: UIRefreshControl) {
        //Your code here

        sender.endRefreshing()
    }

}
