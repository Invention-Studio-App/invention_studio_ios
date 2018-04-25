//
//  QueuesTVC.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 1/26/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class QueuesTVC: ISTableViewController {

    // Declaring variables
    let items = ["3D Printers", "Laser Cutters", "Waterjet"]
    var selectedSection: Int? = nil
    var groups = [QueueGroup]()
    var queueUsers = Dictionary<String, [QueueUser]>()
    var refreshing = false
    let refreshingGroup = DispatchGroup()

    // when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the latest queue data into the table
        self.refreshQueues(nil)
    }
    
    // MARK: - Table view data source

    //  Returns the number of table sections (the number of groups)
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.groups.count
    }

    // Retruns the number of users to display in a section (should be 2 if none, otherwise 1 + the actual amount)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        let queueGroup = self.groups[section]
        let queueUsers = self.queueUsers[String(queueGroup.id) + String(queueGroup.isGroup)]
        if queueUsers == nil || queueUsers!.count == 0 {
            count += 1
        } else {
            count += queueUsers!.count
        }
        return count
    }

    // Sets the color of the table view
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            if let view = view as? UITableViewHeaderFooterView {
                view.textLabel?.textColor = Theme.accentTertiary
            }
    }

    // Sets the header text for the table
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "To join a queue, head to the SUMS kiosk for the room you're interested in"
        default:
            return nil
        }
    }

    // Sets the header dimensions for the table
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return UITableViewAutomaticDimension
        default:
            return 2
        }
    }

    // Sets the footer height for the table
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }

    // Returns the correct cell based on the section and row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "queuesPrototype", for: indexPath)
        let queueGroup = self.groups[indexPath.section]
        if indexPath.row == 0 { // this is a group
            cell.textLabel?.text = self.groups[indexPath.section].name
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        } else { // this is a user or a no user message
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)

            let queueUsers = self.queueUsers[String(queueGroup.id) + String(queueGroup.isGroup)]!
            // No users in the queue
            if queueUsers.count == 0 {
                cell.textLabel?.text = "No users in queue"
            } else {
                cell.textLabel?.text = String(format: "%d. %@", queueUsers[indexPath.row - 1].memberQueueLocation, queueUsers[indexPath.row - 1].memberName)
                // If the current user, bold the text
                if (queueUsers[indexPath.row - 1].memberUserName == UserDefaults.standard.string(forKey: "Username")!) {
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                }
            }
        }

        return cell
    }

    // Sets the height of each cell in the table
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.section == selectedSection {
            return UITableViewAutomaticDimension
        } else {
            return 0
        }
    }

    // Opens and closes the correct section based on what was clicked
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

    // Refreshing the queue data
    @IBAction func refreshQueues(_ sender: Any?) {
        // if not already refrshing
        if !refreshing {
            refreshing = true
            if (sender != nil) {
                (sender as! UIRefreshControl).attributedTitle = NSAttributedString(string: "Fetching queues...")
            }
            
            // Cancelling the refresh after 5 seconds
            let failTask = DispatchWorkItem {
                if sender != nil && (sender as! UIRefreshControl).isRefreshing {
                    let attributedTitle = NSAttributedString(string: "Error: Failed Refresh")
                    (sender as! UIRefreshControl).attributedTitle = attributedTitle
                    (sender as! UIRefreshControl).endRefreshing()
                    self.refreshing = false
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: failTask)
            
            // dispatch group made to ensure queue groups is loaded before the users
            let apiEvalGroup = DispatchGroup()
            apiEvalGroup.enter()
            // Updating the list of groups
            SumsApi.EquipmentGroup.QueueGroups(completion: { groups, error in
                if error != nil {
                    let parts = error!.components(separatedBy: ":")
                    self.alert(title: parts[0], message: parts[1], sender: sender)
                    
                    return
                }

                for g in groups! {
                    self.queueUsers[String(g.id) + String(g.isGroup)] = [QueueUser]()
                }
                self.groups = groups!.sorted(by: { (groupA, groupB) in
                    groupA.name <= groupB.name
                })
                
                apiEvalGroup.leave()
            })
            
            apiEvalGroup.notify(queue: .main, execute: {
                // Updating the list of users
                SumsApi.EquipmentGroup.QueueUsers(completion: { users, error in
                    if error != nil {
                        let parts = error!.components(separatedBy: ":")
                        self.alert(title: parts[0], message: parts[1], sender: sender)
                        return
                    }
                    
                    for u in users! {
                        print(u.memberName)
                        self.queueUsers[String(u.queueGroupId) + String(u.isGroup)]!.append(u)
                    }
                    
                    for q in self.queueUsers {
                        self.queueUsers[q.key] = self.queueUsers[q.key]?.sorted(by: {(userA, userB) in
                            userA.memberQueueLocation < userB.memberQueueLocation
                        })
                    }
                    
                    // reloading data, cancelling the fail task, and updating the reload text
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if sender != nil {
                            let attributedTitle = NSAttributedString(string: "Success")
                            (sender as! UIRefreshControl).attributedTitle = attributedTitle
                            (sender as! UIRefreshControl).endRefreshing()
                        }
                        failTask.cancel()
                        self.refreshing = false
                        print("Success")
                    }
                })
                
            })
        }
    }

    func alert(title: String, message: String, sender: Any?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: {
                if sender != nil {
                    let attributedTitle = NSAttributedString(string: "Error: Failed Refresh")
                    (sender as! UIRefreshControl).attributedTitle = attributedTitle
                    (sender as! UIRefreshControl).endRefreshing()
                    self.refreshing = false
                }
            })
        }
    }

}
