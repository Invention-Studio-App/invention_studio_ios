//
//  MachinesViewController.swift
//  invention-studio-ios
//
//  Created by Noah Sutter on 1/24/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit



class MachinesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var MachinesTable: UITableView!
    var machines = [Machine]()
    var equipmentGroup:String = "Equipment Group"
    
    enum Status {
        case AVAILABLE
        case INUSE
        case DOWN
        case UNKNOWN
    }
    
    class Machine {
        var name:String = ""
        var status:Status = Status.UNKNOWN
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = equipmentGroup
        getMachines()
        // Handling the table in this view controller
        MachinesTable.delegate = self
        MachinesTable.dataSource = self
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.machines.count
    }
    
    private func getMachines() {
        var ms = [Machine]()
        for index in 1..<20 {
            let m = Machine()
            m.name = "Machine " + String(index)
            let num = arc4random_uniform(4)
            if num == 0 {
                m.status = Status.AVAILABLE
            } else if num == 1 {
                m.status = Status.DOWN
            } else if num == 2 {
                m.status = Status.INUSE
            } else if num == 3 {
                m.status = Status.UNKNOWN
            }
            ms.append(m)
        }
        self.machines = ms
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MachineCell", for: indexPath) as? MachineCell else {
            fatalError("The dequeued cell is not an instance of MachineCell.")
        }
        cell.nameLabel.text = self.machines[indexPath.row].name
        
        switch self.machines[indexPath.row].status {
        case Status.AVAILABLE:
            cell.statusImage.image = #imageLiteral(resourceName: "green")
            cell.statusLabel.text = "Available"
            
        case Status.DOWN:
            cell.statusImage.image = #imageLiteral(resourceName: "red")
            cell.statusLabel.text = "Down"
            
        case Status.INUSE:
            cell.statusImage.image = #imageLiteral(resourceName: "orange")
            cell.statusLabel.text = "In use"
        case Status.UNKNOWN:
            cell.statusImage.image = #imageLiteral(resourceName: "red")
            cell.statusLabel.text = "Unknown"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mVC = storyboard?.instantiateViewController(withIdentifier: "MachineViewController") as! MachineViewController
        mVC.machine = self.machines[indexPath.row].name
        navigationController?.pushViewController(mVC, animated: true)
        self.MachinesTable.deselectRow(at: indexPath, animated: true)
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
