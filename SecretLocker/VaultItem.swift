//
//  VaultItem.swift
//  SecretLocker
//
//  Created by Sitthorn Ch on 20/1/2564 BE.
//

import Foundation
import RealmSwift

class VaultItem: Object{
    @objc dynamic var itemID: String?
    @objc dynamic var filePath: String?
    @objc dynamic var dateAdd: Date?
}
