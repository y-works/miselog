//
//  CustomerListView.swift
//  Miselog
//
//  Created by 成田裕之 on 2017/06/03.
//  Copyright © 2017年 Hiroyuki Narita. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

class CustomerListViewController: UIViewController,
                                  UITableViewDataSource,
                                  UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var admobBannerView: GADBannerView!
    
    var customerList = [Customer]()
    var customerFacade = CustomerFacade()
    var customerActivityFacade = CustomerActivityFacade()
    var selectForActivity = false
    var didDismissForAddActivity: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.lightGray
        
        let nib = UINib(nibName: "CustomerListTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CustomerCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.updateTableView()
        
        self.admobBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        self.admobBannerView.rootViewController = self
        self.admobBannerView.load(GADRequest())
        
    }
    
    
    @IBAction func buttonAddCustomerTapped(_ sender: UIBarButtonItem) {
        self.addCustomer()
    }
    
    /// カスタマを追加
    func addCustomer() {
        let nextViewController
            = self.storyboard?.instantiateViewController(
                withIdentifier: "AddCustomerView") as! AddCustomerViewController
        
        nextViewController.didDismiss = { self.updateTableView() }
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    
    /// セルの個数
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - section: <#section description#>
    /// - Returns: <#return value description#>
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.customerList.count
    }
    
    
    /// セルの表示
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#return value description#>
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(
                       withIdentifier: "CustomerCell",
                       for: indexPath) as! CustomerListTableViewCell
        cell.labelName.text = self.customerList[indexPath.row].name

        cell.labelMemo.text = self.customerList[indexPath.row].memo
        
        cell.layoutIfNeeded()
        
        return cell
    }
    
    /// セルのタップ
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectForActivity {
            let prev = self.presentingViewController as! AddCustomerActivityViewController
            
            prev.customer = self.customerList[indexPath.row]
            
            self.selectForActivity = false;
            self.dismiss(animated: true,
                         completion: self.didDismissForAddActivity)
        
        } else {
            let nextViewController
                = self.storyboard?.instantiateViewController(
                    withIdentifier: "CustomerDetailView") as! CustomerDetailViewController
            
            nextViewController.didDismiss = self.updateTableView
            nextViewController.customer = self.customerList[indexPath.row]
            self.present(nextViewController, animated: true, completion: nil)
        }
    }
    
    /// セルのスワイプ削除
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - editingStyle: <#editingStyle description#>
    ///   - indexPath: <#indexPath description#>
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.customerActivityFacade.delete(related: self.customerList[indexPath.row])
            self.customerFacade.delete(object: self.customerList[indexPath.row])
            self.customerList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    /// テーブルの更新
    func updateTableView() {
        self.customerList = self.customerFacade.selectAll()
        self.tableView.reloadData()
    }
}
