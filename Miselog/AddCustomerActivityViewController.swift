//
//  AddCustomerActivityViewController.swift
//  Miselog
//
//  Created by 成田裕之 on 2017/06/03.
//  Copyright © 2017年 Hiroyuki Narita. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

enum AddCustomerActivityMode {
    case Create
    case Update
}

class AddCustomerActivityViewController:
    UIViewController,
    UITextFieldDelegate {
    var didDismiss: (() -> Void)?
    //var customer = Customer()
    var customer:Customer? = nil
    var facade = CustomerActivityFacade()
    var date = Date()
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    var mode = AddCustomerActivityMode.Create
    
    @IBOutlet weak var testFieldMemo: UITextField!
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textFieldTime: UITextField!
    @IBOutlet weak var labelCustomerName: UILabel!
    @IBOutlet weak var viewAdmob: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let now = Date()
        self.date = now;
        
        // textFieldDate
        self.dateFormatter.locale = Locale(identifier: "ja_JP")
        self.dateFormatter.dateFormat = "yyyy/MM/dd"
        self.textFieldDate.text = self.dateFormatter.string(from: self.date)
        
        // textFieldTime
        self.timeFormatter.locale = Locale(identifier: "ja_JP")
        self.timeFormatter.dateFormat = "HH:mm"
        self.textFieldTime.text = self.timeFormatter.string(from: self.date)
        
        // datePicker
        let datePickerToolBar = UIToolbar()
        let doneButtonDate = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(AddCustomerActivityViewController.doneDatePicker))
        let cancelButtonDate = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(AddCustomerActivityViewController.cancelDatePicker))
        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        datePickerToolBar.barStyle = .default
        datePickerToolBar.isTranslucent = true
        datePickerToolBar.tintColor = UIColor(
            red: 76/255,
            green: 217/255,
            blue: 100/255,
            alpha: 1)
        datePickerToolBar.sizeToFit()
        datePickerToolBar.setItems(
            [cancelButtonDate, spaceButton, doneButtonDate],
            animated: false)
        datePickerToolBar.isUserInteractionEnabled = true
        
        datePicker.datePickerMode = .date
        self.textFieldDate.inputView = datePicker
        self.textFieldDate.inputAccessoryView = datePickerToolBar
        
        // TimePicer
        let timePickerToolBar = UIToolbar()
        let doneButtonTime = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(AddCustomerActivityViewController.doneTimePicker))
        let cancelButtonTime = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(AddCustomerActivityViewController.cancelTimePicker))
        timePickerToolBar.barStyle = .default
        timePickerToolBar.isTranslucent = true
        timePickerToolBar.tintColor = UIColor(
            red: 76/255,
            green: 217/255,
            blue: 100/255,
            alpha: 1)
        timePickerToolBar.sizeToFit()
        timePickerToolBar.setItems(
            [cancelButtonTime, spaceButton, doneButtonTime],
            animated: false)
        timePickerToolBar.isUserInteractionEnabled = true
        
        self.timePicker.datePickerMode = .time
        self.textFieldTime.inputView = self.timePicker
        self.textFieldTime.inputAccessoryView = timePickerToolBar
        
        // Admob
        self.viewAdmob.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        self.viewAdmob.rootViewController = self
        self.viewAdmob.load(GADRequest())
        
        // testFieldMemo
        self.testFieldMemo.delegate = self;
    }
    
    
    /// 一覧から選択ボタンタップ
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func buttonSelectCustomerTapped(_ sender: UIButton) {
      self.selectCustomer()
    }
    
    
    /// Saveボタンタップ
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func buttonSaveTapped(_ sender: UIBarButtonItem) {
        self.save();
    }
    
    /// Cancelボタンタップ
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func buttonCancelTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// キーボードリターンタップ
    ///
    /// - Parameter textField: <#textField description#>
    /// - Returns: <#return value description#>
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// DatePickerの完了をタップ
    func doneDatePicker() {
        self.updateDate(to: self.datePicker.date)
        self.textFieldDate.text = self.dateFormatter.string(from: self.date)
        self.textFieldTime.text = self.timeFormatter.string(from: self.date)
        self.textFieldDate.resignFirstResponder()
    }
    
    /// DatePickerのキャンセルをタップ
    func cancelDatePicker() {
        self.textFieldDate.resignFirstResponder()
    }
    
    
    /// TimePicerの完了をタップ
    func doneTimePicker() {
        self.updateTime(to: self.timePicker.date)
        self.textFieldTime.text = self.timeFormatter.string(from: self.date)
        self.textFieldDate.text = self.dateFormatter.string(from: self.date)
        
        self.textFieldTime.resignFirstResponder()
    }
    
    /// TimePickerのキャンセルをタップ
    func cancelTimePicker() {
        self.textFieldTime.resignFirstResponder()
    }
    
    /// カスタマ選択
    func selectCustomer() {
        let nextViewController
            = self.storyboard?.instantiateViewController(
                withIdentifier: "CostomerListView") as! CustomerListViewController
        nextViewController.selectForActivity = true
        nextViewController.didDismissForAddActivity = self.updateCustomer
        
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    /// カスタマ情報表示の更新
    func updateCustomer() {
        if self.customer != nil {
            self.labelCustomerName.text = self.customer?.name
        }
        else {
            self.labelCustomerName.text = ""
        }
        
        /* TODO: メモとアクティビティの更新 */
    }
    
    /// 保存
    func save() {
        var succeeded = false
        
        if self.customer != nil {
            succeeded = self.facade.create(customer: self.customer!,
                                               memo: self.testFieldMemo.text!,
                                               date: self.date)
            
            if !succeeded {
                print("error")
            }
            
            self.dismiss(animated: true, completion: self.didDismiss)
        } else {
            let alert = UIAlertController(
                title: "入力エラー",
                message: "お客様を選択してください",
                preferredStyle: UIAlertControllerStyle.alert)
            
            let defaultButton = UIAlertAction(
                title: "OK",
                style: UIAlertActionStyle.default,
                //handler: (action: UIAlertAction!) -> Void in print("OK"))
                handler: {(action: UIAlertAction!) -> Void in print("OK")})
            
            alert.addAction(defaultButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    /// 時刻のみを更新
    ///
    /// - Parameter to: <#to description#>
    func updateTime(to: Date) {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: self.date)
        components.hour = calendar.component(.hour, from: to)
        components.minute = calendar.component(.minute, from: to)
        self.date = calendar.date(from: components)!
    }
    
    
    /// 日付のみを更新
    ///
    /// - Parameter to: <#to description#>
    func updateDate(to: Date) {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: self.date)
        components.year = calendar.component(.year, from: to)
        components.month = calendar.component(.month, from: to)
        components.day = calendar.component(.day, from: to)
        self.date = calendar.date(from: components)!
    }
}
