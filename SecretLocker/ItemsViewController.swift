//
//  ViewController.swift
//  SecretLocker
//
//  Created by Sitthorn Ch on 7/1/2564 BE.
//

import UIKit

class ItemsViewController: UIViewController {

    @IBOutlet weak var itemCollection: UICollectionView!
    
    var itemWidth: CGFloat {
        let spaces: CGFloat = Design.itemSpace * CGFloat(Design.itemsPerRow - 1)
        return  floor((Design.screenWidth - spaces) / CGFloat(Design.itemsPerRow))
    }
    
    var itemSize: CGSize {
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        itemCollection.dataSource = self
        itemCollection.delegate = self
        
        itemCollection.register(PhotoCell.self, forCellWithReuseIdentifier: photoCellID)
    }


}

extension ItemsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Design.itemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Design.itemSpace
    }
    
}

extension ItemsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ///Navigate to full preview page
    }
}

extension ItemsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellID, for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        cell.contentView.backgroundColor = UIColor.placeholderText
        return cell
    }
    
}

