//
//  VaultItem.swift
//  SecretLocker
//
//  Created by Sitthorn Ch on 20/1/2564 BE.
//

import Foundation
import UIKit
import RealmSwift
import RNCryptor

class VaultItem: Object{
    @objc dynamic var itemID: String?
    @objc dynamic var filePath: String?
    @objc dynamic var thbFilePath: String?
    @objc dynamic var dateAdd: Date?
}

struct PresentItem {
    var itemID: String?
    var thumbnail: UIImage?
    var filePath: String?
    var dateAdd: Date?
    
    init(with item: VaultItem) {
        self.itemID = item.itemID
        self.filePath = item.filePath
        self.dateAdd = item.dateAdd
        let filePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? "") + (item.thbFilePath ?? "")
        let imageUrl = URL(fileURLWithPath: filePath)
        do{
            let encryptedImageData = try Data(contentsOf: imageUrl)
            let rawImage = try! RNCryptor.decrypt(data: encryptedImageData, withPassword: "MAXXX")
            self.thumbnail = UIImage(data: rawImage)
        }catch{
            print(error)
        }
    }
}
