//
//  ViewController.swift
//  count
//
//  Created by Wkalpha on 2019/4/3.
//  Copyright © 2019 wkalpha. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController {
    
    // init all varible to int type
    var totalNumber = 0
    var timesOfOne = 0
    var timesOfFive = 0
    var timesOfTen = 0
    
    // Drop table
    @IBAction func dropTable(_ sender: UIButton) {
        // Warning user
        let controller = UIAlertController(title: "移除資料", message: "這個動作將會移除所有資料且不可復原", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let db = try? Connection("\(path)/Count.sqlite")
            let countTime = Table("countTime")
            do{
                try db?.run(countTime.drop())
                print("使用者已將資料表刪除...")
            }catch{
                print(error)
            }
            
            // Hint
            let controller = UIAlertController(title: "資料已清除！", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Done", style: .default, handler: nil)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
            
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
       
    }
    
    // When click the show button
    // it will show the query result to the console
    @IBAction func showBtn(_ sender: UIButton) {
        do{
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
            for user  in (try? db?.prepare(countTime))!! {
                print("id: \(user[id]), One Time Tap: \(user[one]), Five Time Tap: \(user[five]), Ten Time Tap: \(user[ten]), Total: \(user[total]), Date: \(user[date])")
            }
        }catch{
            print(error)
        }
    }
    
    // When click the save button
    // it will ask you to save records to database and reset all records or not
    @IBAction func saveBtn(_ sender: UIButton) {
        
        // Format date
        let currentDate = Date()
        let dataFormatter = DateFormatter()
        dataFormatter.locale = Locale(identifier: "zh_Hant_TW")
        // Example : 2019-04-05
        dataFormatter.dateFormat = "YYYY-MM-dd"
        // Date to String
        let stringDate = dataFormatter.string(from: currentDate)
        
        // Alert message before save data
        let controller = UIAlertController(title: "儲存並歸零", message: "清除點擊和總數並儲存？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            do {
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
                do {
                    let rowid = try db?.run(countTime.insert(one <- self.timesOfOne, five <- self.timesOfFive, ten <- self.timesOfTen, date <- stringDate, total <- self.totalNumber))
                    print("inserted id: \(rowid!)")
                } catch {
                    print("insertion failed: \(error)")
                }
                for user  in (try? db?.prepare(countTime))!! {
                    print("id: \(user[id]), One Time Tap: \(user[one]), Five Time Tap: \(user[five]), Ten Time Tap: \(user[ten]), Total: \(user[total]), Date: \(user[date])")
                }
                // Where path is
                print(path)
                
                
                // Reset all of tap times
                self.timesOfOne = 0
                self.timesOfFive = 0
                self.timesOfTen = 0
                self.totalNumber = 0
                self.count.text = "\(self.totalNumber)"
                self.oneTimes.text = "\(self.timesOfOne)"
                self.fiveTimes.text = "\(self.timesOfFive)"
                self.tenTimes.text = "\(self.timesOfTen)"
                let controller = UIAlertController(title: "資料儲存成功", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                controller.addAction(okAction)
                self.present(controller, animated: true, completion: nil)
            } catch {
                print(error)
            }
            print(stringDate,"儲存")
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var count: UILabel!
    
    @IBOutlet weak var tenTimes: UILabel!
    @IBOutlet weak var fiveTimes: UILabel!
    @IBOutlet weak var oneTimes: UILabel!
    @IBAction func selectPlusNumber(_ sender: UIButton){
        
        switch sender.tag {
        case 1:
            totalNumber += 1
            timesOfOne += 1
            count.text = "\(totalNumber)"
            oneTimes.text = "\(timesOfOne)"
        case 5:
            totalNumber += 5
            timesOfFive += 1
            count.text = "\(totalNumber)"
            fiveTimes.text = "\(timesOfFive)"
        case 10:
            totalNumber += 10
            timesOfTen += 1
            count.text = "\(totalNumber)"
            tenTimes.text = "\(timesOfTen)"
        case 2 :
            let controller = UIAlertController(title: "重置", message: "是否重置畫面？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                self.timesOfOne = 0
                self.timesOfFive = 0
                self.timesOfTen = 0
                self.totalNumber = 0
                self.count.text = "\(self.totalNumber)"
                self.oneTimes.text = "\(self.timesOfOne)"
                self.fiveTimes.text = "\(self.timesOfFive)"
                self.tenTimes.text = "\(self.timesOfTen)"
                let controller = UIAlertController(title: "重置完畢", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Done", style: .default, handler: nil)
                controller.addAction(okAction)
                self.present(controller, animated: true, completion: nil)
            }
            controller.addAction(okAction)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            present(controller, animated: true, completion: nil)
        default:
            break
        }
    }
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        count.text = "\(totalNumber)"
        oneTimes.text = "\(timesOfOne)"
        fiveTimes.text = "\(timesOfFive)"
        tenTimes.text = "\(timesOfTen)"
    }
}

