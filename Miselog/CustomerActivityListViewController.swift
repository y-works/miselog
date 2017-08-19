//
//  CustomerActivityListViewController.swift
//  Miselog
//
//  Created by 成田裕之 on 2017/06/03.
//  Copyright © 2017年 Hiroyuki Narita. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CustomerActivityListViewController: UIViewController,
                                          UITableViewDataSource,
                                          UITableViewDelegate,
                                          GADBannerViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewAdmob: GADBannerView!
    
    var activityList = [CustomerActivity]()
    var activityFacade = CustomerActivityFacade()
    
    
    /// カスタマアクティビティ追加ボタンタップ
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func buttonAddActivityTapped(_ sender: UIBarButtonItem) {
        self.addActivity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.lightGray
        
        let nib = UINib(nibName: "CustomerActivityTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CustomerActivityCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.updateTableView()
        
        self.viewAdmob.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        self.viewAdmob.rootViewController = self
        self.viewAdmob.load(GADRequest())
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.updateTableView()
    }
    
    
    /// セル個数取得
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - section: <#section description#>
    /// - Returns: <#return value description#>
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.activityList.count
    }
    
    
    /// セル表示
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#return value description#>
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(
            withIdentifier: "CustomerActivityCell",
            for: indexPath) as! CustomerActivityTableViewCell
        
        let activity = self.activityList[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd' 'HH:mm"
        //let dateStr = formatter.string(from: Date( activity.date))
        
        cell.labelName.text = activity.customer?.name
        cell.labelActivityMemo.text = activity.memo
        cell.labelDate.text = formatter.string(from: activity.date! as Date)
        cell.layoutIfNeeded()
        
        return cell
    }
    
    
    /// セル選択
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController
            = self.storyboard?.instantiateViewController(
                withIdentifier: "CustomerDetailView") as! CustomerDetailViewController
        
        nextViewController.customer = self.activityList[indexPath.row].customer!
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    
    /// セルのスワイプ削除
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - editingStyle: <#editingStyle description#>
    ///   - indexPath: indexPath description
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.activityFacade.delete(object: self.activityList[indexPath.row])
            self.activityList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    /// テーブルを更新する
    public func updateTableView() {
        self.activityList = self.activityFacade.selectAll()
        self.tableView.reloadData()
    }
    
    
    /// カスタマアクティビティを追加する
    func addActivity() {
        let nextViewController
            = self.storyboard?.instantiateViewController(
                withIdentifier: "AddCustomerActivityView")
                as! AddCustomerActivityViewController
        
        nextViewController.didDismiss = { self.updateTableView() }
        self.present(nextViewController, animated: true, completion: nil)
    }
}
