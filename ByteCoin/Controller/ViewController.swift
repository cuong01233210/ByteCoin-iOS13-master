
import UIKit

class ViewController: UIViewController    {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    var coinManager = CoinManager()
    

    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
    
    
    
}
// MARK: - extension UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}
// MARK: - extension UIPickerViewDelegate
extension ViewController : UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}
// MARK: - extension CoinManagerDelegate
extension ViewController : CoinManagerDelegate
{
    func showResult(coinManager: CoinManager, lastPrice: Double, currency: String)
    {
        //print(lastPrice)
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format:" %.2f", lastPrice)
            self.currencyLabel.text = currency
        }
        // cú pháp để tránh bị frozen code và sập, chỉ cập nhật thông tin ở luồng chính còn các luồng khác lấy in4 bình thường
    }
}
