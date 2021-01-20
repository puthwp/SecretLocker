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
    func getAllItems() -> [VaultItem]
    func didReciepItems(assets: [PHAsset], onComplete: @escaping ()-> Void)
}

let realm = try! Realm()

class ItemsIntoractor: ItemsIntoractorLogic {
    
    func getAllItems() -> [VaultItem] {
        return Array(realm.objects(VaultItem.self))
    }
    
    func didReciepItems(assets: [PHAsset], onComplete: @escaping ()-> Void) {
        for asset in assets{
            let item = VaultItem()
            item.dateAdd = Date()
            item.itemID = UUID().uuidString
            item.filePath = "/scl/" + (item.itemID ?? "") + ".ml"
            try! realm.write {
                realm.add(item)
            }
            asset.getUIImage {[weak self] (image) in
                guard let data = image?.pngData() else{
                    return
                }
                let cipherText = RNCryptor.encrypt(data: data, withPassword: "MAXXX")
                self?.saveDataToFile(fileName:item.filePath, data: cipherText)
            }
        }
        onComplete()
    }
    
    private func saveDataToFile(fileName:String?, data: Data){
        guard let name = fileName else{
            return
        }
        let fileManager = FileManager.default
        do{
            let documentDirectory  = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let folderURL = documentDirectory.appendingPathComponent("scl/")
            if fileManager.fileExists(atPath: folderURL.path).revert {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            }
            let finalFileURL = documentDirectory.appendingPathComponent(name)
            try data.write(to: finalFileURL)
        }catch{
            print(error)
        }
    }
}

extension PHAsset {
    func getUIImage(onComplete: @escaping (_ image: UIImage?) -> Void){
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
}

extension Bool{
    var revert:Bool {
        return !self
    }
}
