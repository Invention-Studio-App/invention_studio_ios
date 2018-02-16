//
//  EquipmentGroupListTVC.swift
//  invention-studio-ios
//
//  Created by Noah Sutter on 1/23/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class EquipmentGroupListTVC: UITableViewController {

    
    var equipmentGroups = [String]()
    var tools = [Tool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadEquipmentGroups()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.equipmentGroups.count
    }
    
    //Loads the equipment groups from the API
    private func loadEquipmentGroups() {
        self.equipmentGroups = []
        SumsApi.EquipmentGroup.Tools(completion: { (tools) in
            for tool in tools {
                if (!(self.equipmentGroups.contains(tool.locationName))) {
                    self.equipmentGroups.append(tool.locationName)
                }
            }
            self.tools = tools
            self.equipmentGroups.sort()
            // Must be called from main thread, not UIKit
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            })
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "equipmentGroupPrototype", for: indexPath)
        cell.textLabel?.text = self.equipmentGroups[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mVC = storyboard?.instantiateViewController(withIdentifier: "EquipmentGroupTVC") as! EquipmentGroupTVC
        var sentTools = [Tool]()
        for tool in tools {
            if tool.locationName == self.equipmentGroups[indexPath.row] {
                sentTools.append(tool)
            }
        }
        mVC.tools = sentTools
        navigationController?.pushViewController(mVC, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
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

}
