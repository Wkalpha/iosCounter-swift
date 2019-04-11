//
//  ListResult.swift
//  iosCounter
//
//  Created by 高俊瑋 on 2019/4/11.
//  Copyright © 2019 wkalpha. All rights reserved.
//

import UIKit
import SQLite

class ListResult: UITableViewController {
    var count = 0
    var resultArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let db = try? Connection("\(path)/Count.sqlite")
        let countTime = Table("countTime")
        let id = Expression<Int64>("id")
        let one = Expression<Int>("one")
        let five = Expression<Int>("five")
        let ten = Expression<Int>("ten")
        let total = Expression<Int>("total")
        let date = Expression<String>("date")
        try! db?.run(countTime.create(ifNotExists: true, block: { (table) in
            table.column(id, primaryKey: true)
            table.column(one)
            table.column(five)
            table.column(ten)
            table.column(total)
            table.column(date)
        }))
        
        // Using foreach to put element to resultArray
        for user  in (try? db?.prepare(countTime))!! {
            resultArray.append("Total:\(user[total])")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // Show max rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }

    // Show content in each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Configure the cell...
        cell.textLabel?.text = "Total:\(resultArray[indexPath.row])"
        return cell
    }

}
