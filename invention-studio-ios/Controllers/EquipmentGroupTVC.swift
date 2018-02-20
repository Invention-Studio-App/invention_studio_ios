//
//  EquipmentGroupTVC.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 1/25/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class EquipmentGroupTVC: UITableViewController {

    private let headerView = UIView()
    var tools = [Tool]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tools.sort(by: { (toolA, toolB) in
            if (toolA.status().hashValue == toolB.status().hashValue) {
                return toolA.toolName <= toolB.toolName
            }
            return toolA.status().hashValue <= toolB.status().hashValue
        })

        /**
         ** Set Up TableView Header
         **/
        headerView.backgroundColor = UIColor(named: "IS_FocusBackground")

        //Draw header image
        let headerImageView = UIImageView()
        headerImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width / 16.0 * 9.0)
        //TODO: Use dynamic photo
        headerImageView.image = UIImage(named: "PlaceholderStudioImage")
        headerImageView.contentMode = UIViewContentMode.scaleAspectFill
        headerImageView.clipsToBounds = true
        headerView.addSubview(headerImageView)

        //Draw header TextView
        let headerTextView = UITextView()
        headerTextView.isEditable = false
        headerTextView.isSelectable = false
        headerTextView.isScrollEnabled = false
        headerTextView.bounces = false
        headerTextView.bouncesZoom = false
        headerTextView.backgroundColor = UIColor.clear
        //headerTextView.text = tools[0].locationName

        //Set attributed text from HTML
        let attributedString = try! NSMutableAttributedString(
            data: tools[0].locationName.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        let attributesDict = [NSAttributedStringKey.foregroundColor: UIColor(named: "IS_Text")!,
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: headerView.frame.height)
        if tableView.contentOffset.y < -headerView.frame.height {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tools.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "equipmentPrototype", for: indexPath) as! EquipmentCell

        cell.titleLabel?.text = tools[indexPath.row].toolName
        cell.status = tools[indexPath.row].status()
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eVC  = storyboard?.instantiateViewController(withIdentifier: "EquipmentVC") as! EquipmentVC
        eVC.tool = self.tools[indexPath.row]
        eVC.tools = self.tools
        navigationController?.pushViewController(eVC, animated: true)
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

    // MARK: - Scroll view delegate

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //updateHeaderView()
    }

    @IBAction func refresh(_ sender: UIRefreshControl) {
        //Your code here
        /*
        SumsApi.EquipmentGroup.Tools(completion: { (tools) in
            for tool in tools {
                if (!(self.equipmentGroups.contains(tool.locationName))) {
                    self.equipmentGroups.append(tool.locationName)
                }
            }
            self.tools = tools
            // Must be called from main thread, not UIKit
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })*/
        sender.endRefreshing()
    }

}
