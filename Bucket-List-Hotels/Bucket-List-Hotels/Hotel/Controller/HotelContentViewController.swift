//
//  HotelContentViewController.swift
//  Bucket-List-Hotels
//
//  Created by Catherine Shing on 1/4/23.
//

import UIKit

class HotelContentViewController: UIViewController {
    var hotel: Hotel = Hotel()
    
    @IBOutlet var headerView: HotelContentView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        headerView.nameLabel.text = hotel.name
        headerView.locationLabel.text = hotel.country
        headerView.headerImageView.image = UIImage(named: hotel.image)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension HotelContentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HotelDescriptionCell.self), for: indexPath) as! HotelDescriptionCell
            cell.descriptionLabel.text = hotel.description
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HotelContactInfoCell.self), for: indexPath) as! HotelContactInfoCell
             cell.addressTextLabel.text = hotel.address
             
             let attributedString = createPhoneNumberLinkAttributeString(phoneNumber: hotel.phone)
             cell.phoneNumberTextLabel.attributedText = attributedString
             setupPhoneNumberTapGesture(label: cell.phoneNumberTextLabel, phoneNumber: hotel.phone)
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HotelMapCell.self), for: indexPath) as! HotelMapCell
            cell.configureMap(with: hotel.address, hotelName: hotel.name)
            cell.selectionStyle = .none
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for content view controller")
        }
    }
    
    func createPhoneNumberLinkAttributeString(phoneNumber: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: phoneNumber)
        attributedString.addAttribute(.link, value: "tel:\(phoneNumber)", range: NSRange(location: 0, length: phoneNumber.count))
        return attributedString
    }
    
    func setupPhoneNumberTapGesture(label: UILabel, phoneNumber: String) {
        let tapGesture = CustomTapGestureRecognizer(target: self, action: #selector(callPhoneNumber(sender:)))
        tapGesture.phoneNum = phoneNumber
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
    }
    
    @objc func callPhoneNumber(sender: CustomTapGestureRecognizer) {
        guard let phoneNumber = sender.phoneNum else {
            return
        }
        let formattedPhoneNum = phoneNumber.replacingOccurrences(of: " ", with: "")

        let numberUrl = URL(string: "tel://\(formattedPhoneNum)")!
        if UIApplication.shared.canOpenURL(numberUrl) {
            UIApplication.shared.open(numberUrl)
        }
    }
    
    class CustomTapGestureRecognizer: UITapGestureRecognizer {
        var phoneNum: String?
    }
}

