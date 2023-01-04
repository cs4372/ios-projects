//
//  ViewController.swift
//  random-image-picker
//
//  Created by Catherine Shing on 12/25/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageContainer: UIImageView!

    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.systemMint
        return imageView
    }()
    
    lazy var clickButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 180, y: 180, width: 300, height: 50))
        button.backgroundColor = UIColor.orange
        button.setTitle("Click to generate new image", for: .normal)
        button.center.x = view.center.x
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewUI()
        generateNewImage()
        addImagePickerButton()
    }
    
    private func setupViewUI() {
        self.title = "Random Picture Generator"
        view.backgroundColor = UIColor.systemMint
        let imageView = imageView
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView.center = view.center
        view.addSubview(imageView)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        generateNewImage()
        clickButtonAnimation()
        animateLabelTransitions()
    }
    
    private func generateNewImage(){
        if let url = URL(string: "https://picsum.photos/300") {
           URLSession.shared.dataTask(with: url) { (data, response, error) in
             guard let imageData = data else { return }

             DispatchQueue.main.async {
                 self.imageView.image = UIImage(data: imageData)
               }
           }.resume()
         }
    }
    
    private func addImagePickerButton() {
        let btn = clickButton
        self.view.addSubview(btn)
        clickButtonAnimation()
    }
    
    private func animateLabelTransitions() {
        // Animate the alpha
        self.imageView.alpha = 0.5
        UIView.animate(withDuration: 0.8, animations: {
            self.imageView.alpha = 1
        })
    }
    
    private func clickButtonAnimation(){
        UIView.animate(withDuration: 0.4, animations: {
            self.clickButton.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
            }, completion: { (finish) in
                UIView.animate(withDuration: 0.4, animations: {
                    self.clickButton.transform = CGAffineTransform.identity
                })
        })
    }
}
