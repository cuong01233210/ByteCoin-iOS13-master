
import Foundation
import UIKit
protocol CoinManagerDelegate
{
    func didFailWithError(error: Error)
    func showResult(coinManager: CoinManager, lastPrice: Double, currency: String)
}
struct CoinManager   {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "22323AF1-296D-4299-9439-19161A4EFA46"
    let gachcheo = "/"
    var delegate : CoinManagerDelegate?
    // delegate này đã có chứng chỉ CoinManagerDelegate, sau muốn use hàm nào trong viewcontroller thì nhớ bổ sung hàm đó vào chứng chỉ và nhớ cho viewcontroller : coinmanagerdelegate
    var currencyInput : String?
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    mutating func getCoinPrice(for currency : String)
    {
        currencyInput = currency
       let url = "\(baseURL)\(gachcheo)\(currency)?apikey=\(apiKey)"
       // print("URL la: \(url)")
        performRequest(with: url)
        
    }
    func performRequest(with urlString : String)
    {
        // 1. create an url
        if let url = URL(string: urlString)
        {
            // 2. create a sessionURL
            let session = URLSession(configuration: .default)
            // 3. give session a task
            let task =  session.dataTask(with: url) { (data, response, error) in
                if error != nil
                {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data
                {
                    //print(true)
                    
                   if let bitcoinPrice = self.parseJSON(safeData)
                    {
                       self.delegate?.showResult(coinManager: self, lastPrice: bitcoinPrice, currency : currencyInput ?? "USD")
                   }
                }
            }
            // 4. start the task
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> Double?
    {
        let decoder = JSONDecoder.self()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let lastPrice = decodedData.rate
           // print(lastPrice)
            return lastPrice
        }
     catch {
        delegate?.didFailWithError(error: error)
        return nil
    }
    }
}
