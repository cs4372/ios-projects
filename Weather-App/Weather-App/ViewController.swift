//
//  ViewController.swift
//  Weather-App
//
//  Created by Catherine Shing on 2/16/23.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var weatherSummary: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func getWeather(_ sender: UIButton) {
        if let url = URL(string: "https://www.weather-forecast.com/locations/" + textField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
            print("url", url)
            URLSession.shared.dataTask(with: url) { data, response, error in
                var message = ""
                if let data = data {
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            let jsonString = String(data: data, encoding: .utf8)
                            var stringSeparator = "<p class=\"location-summary__text\"><span class=\"phrase\">"
                            if let contentArray = jsonString?.components(separatedBy: stringSeparator) {
                                if contentArray.count > 1 {
                                    stringSeparator = "</span>"
                                    let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                    if newContentArray.count > 1 {
                                        message = newContentArray[0].replacingOccurrences(of: "&deg", with: "'")
                                    }
                                }
                            }
                        }
                    }
                } else {
                    message = "The weather couldn't be found. Please try again"
                    if let error = error {
                        print("error", error)
                    }
                }
                if message == "" {
                    message = "The weather couldn't be found. Please try again"
                }
                DispatchQueue.main.sync(execute: {
                    self.weatherSummary.text = message
                    self.textField.text = ""
                })
            }.resume()
        }
    }
}

