//
//  ViewController.swift
//  BitcoinPriceReporter
//
//  Created by Darko Kulakov on 2019-11-19.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
}

//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdatePrice(currency: String, price: String) {
        DispatchQueue.main.async {
            self.currencyLabel.text = currency
            self.bitcoinLabel.text = price
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
