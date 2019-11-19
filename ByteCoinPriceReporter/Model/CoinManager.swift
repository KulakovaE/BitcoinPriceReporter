//
//  CoinManager.swift
//  BitcoinPriceReporter
//
//  Created by Darko Kulakov on 2019-11-19.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(currency: String, price: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)\(currency)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task  = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(currency: currency, price: priceString)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data )
            let lastPrice = decodedData.last
            print(lastPrice)
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
