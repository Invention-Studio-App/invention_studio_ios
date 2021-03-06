//
//  EquipmentGroupTVC.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 1/25/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class EquipmentGroupTVC: ISTableViewController, UINavigationControllerDelegate {

    private let headerView = UIView()
    var location: Location!
    var tools = [Tool]()
    var groupTools = [Tool]()
    var backProp:(([Tool]) -> ())?
    let headerTextView = UITextView()
    // used to ensure refresh is only running once
    var refreshing = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        /**
         ** Set Up TableView Header
         **/
        headerView.backgroundColor = Theme.background

        //Draw header image
        let headerImageView = UIImageView()
        headerImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width / 16.0 * 9.0)
        //TODO: Use dynamic photo
        headerImageView.image = InventionStudioImages.imageForTool(locationName: self.location.locationName, toolName: "header")
        headerImageView.contentMode = UIViewContentMode.scaleAspectFill
        headerImageView.clipsToBounds = true
        headerView.addSubview(headerImageView)

        //Draw header TextView
        
        headerTextView.isEditable = false
        headerTextView.isSelectable = false
        headerTextView.isScrollEnabled = false
        headerTextView.bounces = false
        headerTextView.bouncesZoom = false
        headerTextView.backgroundColor = UIColor.clear

        //Set attributed text from HTML
        let attributedString = try! NSMutableAttributedString(
            data: location.locationDescription.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        let attributesDict = [NSAttributedStringKey.foregroundColor: Theme.text,
                              NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
        attributedString.addAttributes(attributesDict, range: NSMakeRange(0, attributedString.length))
        headerTextView.attributedText = attributedString
        
        let headerTextViewSize = headerTextView.sizeThatFits(CGSize(width: view.frame.width - 16, height: CGFloat.greatestFiniteMagnitude))
        headerTextView.frame = CGRect(x: 8, y: headerImageView.frame.maxY + 8, width: view.frame.width - 16, height: headerTextViewSize.height)
        headerView.addSubview(headerTextView)

        //Calculate header height and set frame
        let headerViewHeight = headerTextView.frame.maxY + 16
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerViewHeight)

        //Add header to Tableview
        tableView.tableHeaderView = headerView
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupTools.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "equipmentPrototype", for: indexPath) as! EquipmentCell

        cell.titleLabel?.text = self.groupTools[indexPath.row].toolName
        cell.status = self.groupTools[indexPath.row].status()
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eVC  = storyboard?.instantiateViewController(withIdentifier: "EquipmentVC") as! EquipmentVC
        eVC.location = self.location
        eVC.tools = self.tools
        eVC.tool = self.groupTools[indexPath.row]
        eVC.title = eVC.tool.toolName
        
        eVC.backProp = {tools in
            self.tools = tools
            self.backProp?(tools)
            self.groupTools = self.getGroupTools(tools: tools)
            // Must be called from main thread, not UIKit
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
                // Updating the location and location description
                var fLocation = true
                for tool in tools {
                    if (fLocation && tool.locationId == self.location.locationId) {
                        fLocation = false
                        //Set attributed text from HTML
                        self.location = Location(fromTool: tool)
                        let attributedString = try! NSMutableAttributedString(
                            data: self.location.locationDescription.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                            options: [.documentType: NSAttributedString.DocumentType.html],
                            documentAttributes: nil)
                        let attributesDict = [NSAttributedStringKey.foregroundColor: Theme.text,
                                              NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
                        attributedString.addAttributes(attributesDict, range: NSMakeRange(0, attributedString.length))
                        self.headerTextView.attributedText = attributedString
                    }
                }
            }
        }
        
        
        navigationController?.pushViewController(eVC, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getGroupTools(tools:[Tool]) -> [Tool] {
        var tempGroupTools:[Tool] = []
        for tool in tools {
            if (tool.locationId == self.location.locationId) {
                tempGroupTools.append(tool)
            }
        }
        return tempGroupTools
    }

    // MARK: - Scroll view delegate

    @IBAction func refresh(_ sender: UIRefreshControl) {
        if (!refreshing) {
            refreshing = true
            sender.attributedTitle = NSAttributedString(string: "Fetching tools...")
            SumsApi.EquipmentGroup.Tools(completion: { tools, error in
                if error != nil {
                    // sending error alert
                    let parts = error!.components(separatedBy: ":")
                    self.alert(title: parts[0], message: parts[1], sender: sender)
                    return
                }
                
                self.tools = tools!
                // updating tools in EquipmentGroupListTVC
                self.backProp?(tools!)
                self.groupTools = self.getGroupTools(tools: tools!)
                
                // Must be called from main thread, not UIKit
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    var fLocation = true
                    for tool in tools! {
                        if (fLocation && tool.locationId == self.location.locationId) {
                            fLocation = false
                            //Set attributed text from HTML
                            self.location = Location(fromTool: tool)
                            let attributedString = try! NSMutableAttributedString(
                                data: self.location.locationDescription.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                                options: [.documentType: NSAttributedString.DocumentType.html],
                                documentAttributes: nil)
                            let attributesDict = [NSAttributedStringKey.foregroundColor: Theme.text,
                                                  NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
                            attributedString.addAttributes(attributesDict, range: NSMakeRange(0, attributedString.length))
                            self.headerTextView.attributedText = attributedString
                        }
                    }
                    
                    // updating refresh title
                    let attributedTitle = NSAttributedString(string: "Last Refresh: Success")
                    sender.attributedTitle = attributedTitle
                    
                    // ending refreshing
                    sender.endRefreshing()
                    self.refreshing = false
                }
            })
        }
    }

    func alert(title: String, message: String, sender: Any?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: {
                if sender != nil {
                    let attributedTitle = NSAttributedString(string: "Last Refresh: Failed")
                    (sender as! UIRefreshControl).attributedTitle = attributedTitle
                    (sender as! UIRefreshControl).endRefreshing()
                    self.refreshing = false
                }
            })
        }
    }

}
