//
//  EquipmentGroupListTVC.swift
//  invention-studio-ios
//
//  Created by Noah Sutter on 1/23/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class EquipmentGroupListTVC: ISTableViewController {
    var equipmentGroups = [Location]()
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
    
    //Loads the equipment groups from the API with a refresher to stop
    private func loadEquipmentGroups(_ sender: UIRefreshControl) {
        SumsApi.EquipmentGroup.Tools(completion: { (tools) in
            self.tools = tools
            self.equipmentGroups = self.getEquipmentGroups(tools: tools)
            // Must be called from main thread, not UIKit
            DispatchQueue.main.async {
                self.tableView.reloadData()
                sender.endRefreshing()
            }
        })
        
    }
    
    //Loads the equipment groups from the API without a refresher to stop
    private func loadEquipmentGroups() {
        SumsApi.EquipmentGroup.Tools(completion: { (tools) in
            self.tools = tools
            self.equipmentGroups = self.getEquipmentGroups(tools: tools)
            // Must be called from main thread, not UIKit
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    // Gets the equipment groups out of a list of tools
    func getEquipmentGroups(tools:[Tool]) -> [Location] {
        var equipmentGroups = Set<Location>()
        for tool in tools {
            if tool.locationId != 0 {
                equipmentGroups.insert(Location(fromTool: tool))
            }
        }
        return equipmentGroups.sorted(by: { (groupA, groupB) in
            return groupA.locationName <= groupB.locationName
        })
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "equipmentGroupPrototype", for: indexPath)
        cell.textLabel?.text = self.equipmentGroups[indexPath.row].locationName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let mVC = storyboard?.instantiateViewController(withIdentifier: "EquipmentGroupTVC") as! EquipmentGroupTVC
        var sentTools = [Tool]()
        for tool in tools {
            if tool.locationId == self.equipmentGroups[indexPath.row].locationId && tool.locationId != 0 {
                //Exclude tools with no location
                sentTools.append(tool)
            }
        }
        mVC.tools = tools
        mVC.groupTools = sentTools
        mVC.location = equipmentGroups[indexPath.row]
        mVC.title = sentTools[0].locationName
        
        // defining the method EquipmentGroupTVC can use to update tools if refreshed
        mVC.backProp = {tools in
            self.tools = tools
            self.equipmentGroups = self.getEquipmentGroups(tools: tools)
            
            // Must be called from main thread, not UIKit
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        // Pushing the new view controller up
        navigationController?.pushViewController(mVC, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func refresh(_ sender: UIRefreshControl) {
        sender.attributedTitle = NSAttributedString(string: "Fetching groups...")
        loadEquipmentGroups(sender)
    }

}
