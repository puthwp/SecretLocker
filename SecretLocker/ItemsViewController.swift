//
//  ViewController.swift
//  SecretLocker
//
//  Created by Sitthorn Ch on 7/1/2564 BE.
//

import UIKit
import BouncyLayout
import Tatsi
import Photos
import RNCryptor
import ANActivityIndicator

class ItemsViewController: BaseViewController {

    @IBOutlet weak var itemCollection: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    
    var itemWidth: CGFloat {
        let spaces: CGFloat = Design.itemSpace * CGFloat(Design.itemsPerRow - 1)
        return  floor((Design.screenWidth - spaces) / CGFloat(Design.itemsPerRow))
    }
    
    var itemSize: CGSize {
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    let intoractor = ItemsIntoractor()
    
    private var allItems: [VaultItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        itemCollection.dataSource = self
        itemCollection.delegate = self
    
        let layout = BouncyLayout(style: .subtle)
        itemCollection.setCollectionViewLayout(layout, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allItems = intoractor.getAllItems()
        itemCollection.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButton.layer.cornerRadius = addButton.bounds.width / 2
    }
    
    @IBAction func addButtonHandler(_ sender: UIButton) {
        addFileToVault()
    }
    
    private func animateAddButton(onComplete: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.addButton.setImage(nil, for: .normal)
            self?.addButton.backgroundColor = UIColor(white: 1, alpha: 0.7)
            self?.addButton.transform = CGAffineTransform.init(scaleX: 30, y: 30)
        } completion: { [weak self] (finished) in
            self?.addButton.transform = CGAffineTransform.identity
            self?.addButton.backgroundColor = .systemGreen
            self?.addButton.setImage(.add, for: .normal)
            onComplete()
        }

    }
    
    private func addFileToVault() {
//        let config = TatsiConfig()
//        config.maxNumberOfSelections = 20
        let pickerController = TatsiPickerViewController()
        pickerController.pickerDelegate = self
        animateAddButton{ [weak self] in
            self?.present(pickerController, animated: false, completion: nil)
        }
    }


}

extension ItemsViewController: TatsiPickerViewControllerDelegate, UINavigationControllerDelegate{
    func pickerViewController(_ pickerViewController: TatsiPickerViewController, didPickAssets assets: [PHAsset]) {
        showLoading()
        pickerViewController.dismiss(animated: true, completion:{
            self.intoractor.didReciepItems(assets: assets,onComplete: { [weak self] in
                self?.allItems = self?.intoractor.getAllItems()
                self?.itemCollection.reloadData()
                self?.hideLoading()
            })            
        })
        
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
        return allItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellID, for: indexPath) as? PhotoCell,
              let item = allItems?[indexPath.row] else {
            return UICollectionViewCell()
        }
        let filePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? "") + (item.filePath ?? "")
        let imageUrl = URL(fileURLWithPath: filePath)
        do{
            let encryptedImageData = try Data(contentsOf: imageUrl)
            let rawImage = try! RNCryptor.decrypt(data: encryptedImageData, withPassword: "MAXXX")
            let image = UIImage(data: rawImage)
            cell.thumbnail.image = image
        }catch{
            print(error)
        }
        
        cell.contentView.backgroundColor = UIColor.placeholderText
        return cell
    }
    
}

