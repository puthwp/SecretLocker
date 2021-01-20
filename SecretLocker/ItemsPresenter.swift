//
//  ItemsPresenter.swift
//  SecretLocker
//
//  Created by Sitthorn Ch on 21/1/2564 BE.
//

import Foundation

protocol ItemsPresenterLogic {
    func presentAllItems(items: [VaultItem])
}

class ItemsPresenter: ItemsPresenterLogic{
    var viewController: ItemsViewLogic?
    func presentAllItems(items: [VaultItem]) {
        let presentingItems = items.map{ PresentItem(with: $0) }
        viewController?.displayItems(items: presentingItems)
    }
}
