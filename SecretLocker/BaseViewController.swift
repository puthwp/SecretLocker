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
    var blurEffectView: UIVisualEffectView?
    func showLoading(){
        loading.center = view.center
        view.addSubview(loading)
        loading.startAnimating()
    }
    
    func hideLoading(){
        loading.removeFromSuperview()
        loading.stopAnimating()
    }
    
    func blinding(){
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = self.view.bounds
        blurEffectView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(blurEffectView ?? UIView())
    }
    
    func unblind(){
        blurEffectView?.removeFromSuperview()
    }
}
