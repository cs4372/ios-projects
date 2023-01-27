//
//  SwappingController.swift
//  Auto-Layout-Programmatically
//
//  Created by Catherine Shing on 1/22/23.
//

import UIKit

class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: {(_) in
            self.collectionViewLayout.invalidateLayout()
            let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        })
    }
    
    let pages = [
        Page(imageName: "american_food.jpeg", headerText: "Join us for American food", descriptionText: "Pizzas, Burgers"),
        Page(imageName: "chinese_food.jpeg", headerText: "Join us for Chinese food",
            descriptionText: "Dimsum, Chicken Chow Mein"),
        Page(imageName: "indian_food.jpeg", headerText: "Join us for Indian food",
            descriptionText: "Chicken Curry"),
        Page(imageName: "italian_food.jpeg", headerText: "Join us for Italian food",
            descriptionText: "Pizzas, Spaghetti")
    ]
    
    private let previousButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Prev", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        btn.layer.cornerRadius = 10.0
        btn.backgroundColor = .yellow
        return btn
    }()

    private let nextButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Next", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        btn.layer.cornerRadius = 10.0
        btn.backgroundColor = .orange
        return btn
    }()

    @objc private func handleNext() {
        let nextIndex = min(pageControl.currentPage + 1, pages.count-1)
        print(nextIndex)
        if nextIndex < pages.count {
            let indexPath = IndexPath(item: nextIndex, section: 0)
            pageControl.currentPage = nextIndex
            collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    @objc private func handlePrev() {
        let prevIndex = max(0,pageControl.currentPage - 1)
        let indexPath = IndexPath(item: prevIndex, section: 0)
        pageControl.currentPage = prevIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = UIColor.red
        pc.pageIndicatorTintColor = UIColor.gray
        pc.sizeToFit()
        return pc
    }()

    private func setUpBottomControls() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillProportionally
        bottomControlsStackView.spacing = 10
        bottomControlsStackView.alignment = .center
        view.addSubview(bottomControlsStackView)
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBottomControls()
        collectionView?.backgroundColor = .white
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "myCell")
        collectionView?.isPagingEnabled = true
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x/view.frame.width)
    }
}
