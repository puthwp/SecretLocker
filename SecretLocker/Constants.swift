//
//  Constants.swift
//  SecretLocker
//
//  Created by Sitthorn Ch on 7/1/2564 BE.
//

import Foundation
import UIKit

let photoCellID: String = "photoCellID"

class Design{
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
    static let itemSpace: CGFloat = 1
    static let itemsPerRow: Int = 3
}

enum FileType {
    case Photo
    case Video
    case Document
}
