//
//  ItemsInteractor.swift
//  SecretLocker
//
//  Created by Sitthorn Ch on 20/1/2564 BE.
//

import Foundation
import Photos
import RealmSwift
import UIKit
import RNCryptor

protocol ItemsIntoractorLogic {
    func getAllItems()
    func didReciepItems(assets: [PHAsset])
}

let realm = try! Realm()

class ItemsIntoractor: ItemsIntoractorLogic {
    var presenter: ItemsPresenter?
    
    func getAllItems(){
        let allItems = Array(realm.objects(VaultItem.self))
        presenter?.presentAllItems(items: allItems)
    }
    
    func didReciepItems(assets: [PHAsset]) {
        for asset in assets{
            let item = VaultItem()
            item.dateAdd = Date()
            item.itemID = UUID().uuidString
            item.filePath = Directory.FullResFolder + (item.itemID ?? "") + ".ml"
            item.thbFilePath = Directory.ThumbnailFolder + (item.itemID ?? "") + ".ml"
            try! realm.write {
                realm.add(item)
            }
            asset.getFullUIImage { [weak self] (image) in
                guard let data = image?.pngData() else{
                    return
                }
                let cipherText = RNCryptor.encrypt(data: data, withPassword: "MAXXX")
                self?.saveDataToFile(fileName:item.filePath, data: cipherText)
            }
            
            asset.getThumbnailUIImage { [weak self] (image) in
                guard let data = image?.pngData() else{
                    return
                }
                let cipherText = RNCryptor.encrypt(data: data, withPassword: "MAXXX")
                self?.saveDataToFile(fileName:item.thbFilePath, data: cipherText)
            }
        }
        getAllItems()
    }
    
    private func saveDataToFile(fileName:String?, data: Data){
        guard let name = fileName else{
            return
        }
        let fileManager = FileManager.default
        do{
            let documentDirectory  = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let folderURL = documentDirectory.appendingPathComponent(Directory.FullResFolder)
            if fileManager.fileExists(atPath: folderURL.path).revert {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            }
            let thumbFolderURL = documentDirectory.appendingPathComponent(Directory.ThumbnailFolder)
            if fileManager.fileExists(atPath: thumbFolderURL.path).revert {
                try fileManager.createDirectory(at: thumbFolderURL, withIntermediateDirectories: true, attributes: nil)
            }
            let finalFileURL = documentDirectory.appendingPathComponent(name)
            try data.write(to: finalFileURL)
        }catch{
            print(error)
        }
    }
}

extension PHAsset {
    func getFullUIImage(onComplete: @escaping (_ image: UIImage?) -> Void){
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.version = .original
        option.isSynchronous = true
        manager.requestImage(for: self,
                             targetSize: PHImageManagerMaximumSize,
                             contentMode: .default,
                             options: option) { (reciepeImage: UIImage?, _) in
            onComplete(reciepeImage)
        }
    }
    
    func getThumbnailUIImage(onComplete: @escaping (_ image: UIImage?) -> Void){
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.version = .current
        option.isSynchronous = true
        manager.requestImage(for: self,
                             targetSize: CGSize(width: 300, height: 300),
                             contentMode: .aspectFill,
                             options: option) { (reciepeImage: UIImage?, _) in
            onComplete(reciepeImage)
        }
    }
}

extension Bool{
    var revert:Bool {
        return !self
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
