//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCurrency(_ coinManager: CoinManager, coinFeatures: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "1050F951-B944-4D9E-8909-E11581F5C0B7"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = baseURL + "/" + currency + "?apikey=" + apiKey
        
        
        // Create a URL
        
        if let url = URL(string: urlString) {
            
            // Create a URLSession
            
            let session = URLSession(configuration: .default)
            
            // Create a session task
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCurrency(self, coinFeatures: bitcoinPrice)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            //Get the last property from the decoded data.
            let lastPrice = decodedData.rate
            let lastCurrency = decodedData.asset_id_quote
            
            let coinFeatures = CoinModel(price: lastPrice, currency: lastCurrency)
            
            return coinFeatures
            
        } catch {
            
            print(error)
            return nil
        }
    }

    
}
