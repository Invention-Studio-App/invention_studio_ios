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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

        headerView.backgroundColor = UIColor(named: "IS_FocusBackground")

        let headerImageView = UIImageView()
        headerImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width / 16.0 * 9.0)
        headerImageView.image = UIImage(named: "PlaceholderStudioImage")
        headerImageView.contentMode = UIViewContentMode.scaleAspectFill
        headerImageView.clipsToBounds = true
        headerView.addSubview(headerImageView)

        let headerTextView = UITextView()
        headerTextView.isEditable = false
        headerTextView.isSelectable = false
        headerTextView.isScrollEnabled = false
        headerTextView.bounces = false
        headerTextView.bouncesZoom = false
        headerTextView.backgroundColor = UIColor.clear
        headerTextView.textColor = UIColor(named: "IS_Text")
        headerTextView.font = UIFont.systemFont(ofSize: 16)
        headerTextView.text = "Is this the real life? Is this just fantasy? Caught in a landslide, no escape from reality. Open your eyes, look up to the skies and see... I'm just a poor boy, I need no sympathy. Because I'm easy come, easy go. Little high, little low. Everywhere the wind blows doesn't really matter to me. To me..."
        let headerTextViewSize = headerTextView.sizeThatFits(CGSize(width: view.frame.width - 16, height: CGFloat.greatestFiniteMagnitude))
        headerTextView.frame = CGRect(x: 8, y: headerImageView.frame.height + 8, width: view.frame.width - 16, height: headerTextViewSize.height)
        headerView.addSubview(headerTextView)

        let headerViewHeight = headerImageView.frame.height + headerTextView.frame.height + 16
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerViewHeight)

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
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "equipmentPrototype", for: indexPath) as! EquipmentCell
        
        cell.titleLabel?.text = "Testing"

        if indexPath.row < 3 {
            cell.status = Tool.Status.AVAILABLE
        } else if indexPath.row < 6 {
            cell.status = Tool.Status.INUSE
        } else if indexPath.row < 8{
            cell.status = Tool.Status.DOWN
        } else {
            cell.status = Tool.Status.UNKNOWN
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
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

    @IBAction func refresh(_ sender: Any) {
        refreshControl?.endRefreshing()
    }

}
