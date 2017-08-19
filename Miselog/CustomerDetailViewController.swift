//
//  CustomerDetailViewController.swift
//  Miselog
//
//  Created by 成田裕之 on 2017/06/03.
//  Copyright © 2017年 Hiroyuki Narita. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CustomerDetailViewController: UIViewController,
                                    UITableViewDataSource,
                                    UITableViewDelegate,
                                    GADBannerViewDelegate {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMemo: UILabel!
    @IBOutlet weak var viewAdmob: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    
    var customer = Customer()
    var activityList = [CustomerActivity]()
    var didDismiss: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* カスタマラベル初期化 */
        self.labelName.text = self.customer.name
        self.labelMemo.text = self.customer.memo
        
        let activityFacade = CustomerActivityFacade();
        self.activityList = activityFacade.select(customer: self.customer)
        
        /* テーブル初期化 */
        let nib = UINib(nibName: "CustomerActivityNoNameTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CustomerActivityNoNameCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        /* Admob初期化 */
        self.viewAdmob.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        self.viewAdmob.rootViewController = self
        self.viewAdmob.load(GADRequest())
    }
    
    
    /// Backボタンタップ
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func buttonBackTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: self.didDismiss)
    }
    
    
    /// Editボタンタップ
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func buttonEditTapped(_ sender: UIBarButtonItem) {
        let nextViewController
            = self.storyboard?.instantiateViewController(
                withIdentifier: "AddCustomerView") as! AddCustomerViewController
        nextViewController.mode = AddCustomerViewMode.Update
        nextViewController.customer = self.customer
        nextViewController.didDismiss = self.updateView
        self.present(nextViewController, animated: true, completion: nil)
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
        //return 3
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
            withIdentifier: "CustomerActivityNoNameCell",
            for: indexPath) as! CustomerActivityNoNameTableViewCell
        
        let act = self.activityList[indexPath.row];
        cell.labelActivityMemo.text = act.memo

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd' 'HH:mm"
        
        cell.labelDate.text = formatter.string(from: act.date! as Date)
        
        return cell
    }
    
    func updateView() {
        self.tableView.reloadData()
        self.labelName.text = self.customer.name
        self.labelMemo.text = self.customer.memo
    }

}
