//
//  BaseViewController.swift
//  SecretLocker
//
//  Created by Sitthorn Ch on 20/1/2564 BE.
//

import Foundation
import UIKit
import ANActivityIndicator

class BaseViewController: UIViewController {
    let loading = ANActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150),
                                          animationType: .pacman,
                                          color: .white,
                                          padding: 0)
    func showLoading(){
        loading.center = view.center
        view.addSubview(loading)
        loading.startAnimating()
    }
    
    func hideLoading(){
        loading.removeFromSuperview()
        loading.stopAnimating()
    }
}
