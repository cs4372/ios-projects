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
    
    let APIKey = "b9c0df8e630328a7feea13a0d2d110b0"
    
    @IBAction func getWeather(_ sender: UIButton) {
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=" + textField.text!.replacingOccurrences(of: " ", with: "-") + "&appid=\(APIKey)") {
            print("url", url)
            URLSession.shared.dataTask(with: url) { data, response, error in
                var message = ""
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                    let weatherData = try decoder.decode(WeatherData.self, from: data)
                        let description = weatherData.list[0].weather[0].description
                            message = description
                        } catch {
                            print(error)
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

