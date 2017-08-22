//
//  appendCustomerView.swift
//  Miselog
//
//  Created by 成田裕之 on 2017/06/03.
//  Copyright © 2017年 Hiroyuki Narita. All rights reserved.
//

import UIKit
import GoogleMobileAds

enum AddCustomerViewMode {
    case Create
    case Update
}

class AddCustomerViewController:
    UIViewController,
    UITextFieldDelegate {
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldMemo: UITextField!
    @IBOutlet weak var viewAdmob: GADBannerView!
    
    var customer: Customer? = nil
    var mode = AddCustomerViewMode.Create
    var didDismiss: (() -> Void)?
    
    override func viewDidLoad() {
        // Admob
        super.viewDidLoad()
        
        self.viewAdmob.adUnitID = Admob.MAIN_BANNER_ID
        self.viewAdmob.rootViewController = self
        self.viewAdmob.load(GADRequest())
        
        // textField
        self.textFieldName.delegate = self
        self.textFieldMemo.delegate = self
        
        if self.customer != nil {
            self.textFieldName.text = self.customer?.name
            self.textFieldMemo.text = self.customer?.memo
        }
    }
    
    
    /// Cancelボタンタップ
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Saveボタンタップ
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        self.save()
        self.dismiss(animated: true, completion: self.didDismiss)
    }
    
    
    /// キーボードリターンタップ
    ///
    /// - Parameter textField: <#textField description#>
    /// - Returns: return value description
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// 編集した情報を保存する
    func save() {
        let facade = CustomerFacade()
        switch mode {
        case .Create:
            let succeeded = facade.create(name: self.textFieldName.text!,
                                          memo: self.textFieldMemo.text!)
            
            if !succeeded {
                print("error")
            }
            
        case .Update:
            if self.customer != nil {
                let succeeded = facade.update(self.customer!.objectID,
                                              newName: self.textFieldName.text!,
                                              newMemo: self.textFieldMemo.text!)
                
                if !succeeded {
                    print("error")
                }
            }
        }

    }
}
