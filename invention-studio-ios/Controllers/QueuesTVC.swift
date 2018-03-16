//
//  QueuesTVC.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 1/26/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class QueuesTVC: ISTableViewController {

    let items = ["3D Printers", "Laser Cutters", "Waterjet"]
    var selectedSection: Int? = nil
    var groups = [QueueGroup]()
    var queueUsers = Dictionary<Int, [QueueUser]>()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshQueues(self)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.groups.count
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        let queueGroup = self.groups[section]
        let queueUsers = self.queueUsers[queueGroup.id]
        if queueUsers == nil || queueUsers!.count == 0 {
            count += 1
        } else {
            count += queueUsers!.count
        }
        return count
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            if let view = view as? UITableViewHeaderFooterView {
                view.textLabel?.textColor = Theme.accentTertiary
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
        let queueGroup = self.groups[indexPath.section]
        if indexPath.row == 0 {
            cell.textLabel?.text = self.groups[indexPath.section].name
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        } else {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)

            let queueUsers = self.queueUsers[queueGroup.id]!
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

    @IBAction func refreshQueues(_ sender: Any) {
        let apiEvalGroup = DispatchGroup()

        apiEvalGroup.enter()
        SumsApi.EquipmentGroup.QueueGroups(completion: { (groups) in
            for g in groups {
                self.queueUsers[g.id] = [QueueUser]()
            }
            self.groups = groups.sorted(by: { (groupA, groupB) in
                groupA.name <= groupB.name
            })
            
            apiEvalGroup.leave()
        })

        apiEvalGroup.notify(queue: .main, execute: {

            SumsApi.EquipmentGroup.QueueUsers(completion: { (users) in
                for u in users {
                    if u.queueName != "" {
                        self.queueUsers[u.queueGroupId]!.append(u)
                    }
                }
                for q in self.queueUsers {
                    self.queueUsers[q.key] = self.queueUsers[q.key]?.sorted(by: {(userA, userB) in
                        userA.memberQueueLocation < userB.memberQueueLocation
                    })
                }


                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            
        })
    }

    @IBAction func refresh(_ sender: UIRefreshControl) {
        //Your code here

        sender.endRefreshing()
    }

}
