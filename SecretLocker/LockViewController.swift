//
//  LockViewController.swift
//  SecretLocker
//
//  Created by Sitthorn Ch on 21/1/2564 BE.
//

import Foundation
import UIKit
import AVKit

class LockViewController: BaseViewController{
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var lowerView: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var stackPin: UIStackView!
    @IBOutlet weak var topViewContraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewContraint: NSLayoutConstraint!
    
    private var secretPin: String = ""
    
    var typeSound = URL(fileURLWithPath: Bundle.main.path(forResource: "typing", ofType: "mp3") ?? "")
    var unlockSound = URL(fileURLWithPath: Bundle.main.path(forResource: "unlock", ofType: "mp3") ?? "")
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: typeSound, fileTypeHint: nil)
            audioPlayer.prepareToPlay()
        } catch{
            print(error)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupView()
    }
    
    private func animateViewSuccess(){
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: unlockSound, fileTypeHint: nil)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch{
            print(error)
        }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.iconImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
        } completion: { (finished) in
            UIView.animate(withDuration: 0.3) { [weak self] in
                
                self?.topViewContraint.constant = (self?.upperView.bounds.height ?? 0)
                self?.bottomViewContraint.constant = -(self?.lowerView.bounds.height ?? 0)
                self?.view.layoutIfNeeded()
                
            } completion: { (finish) in
                let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
                impactFeedbackgenerator.prepare()
                impactFeedbackgenerator.impactOccurred()
                self.performSegue(withIdentifier: "displayItemsView", sender: self)
            }
        }

        

    }
    
    private func animateViewFailed(){
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    private func setupView(){
        iconImageView.layer.cornerRadius = iconImageView.bounds.height / 2
        for view in stackPin.arrangedSubviews {
            view.layer.cornerRadius = view.bounds.height / 2
        }
        
        for stack in buttonStackView.arrangedSubviews {
            for view in (stack as! UIStackView).arrangedSubviews {
                view.layer.cornerRadius = view.bounds.height / 2
            }
        }
        iconImageView.layer.masksToBounds = false
        iconImageView.layer.shadowColor = UIColor.black.cgColor
        iconImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        iconImageView.layer.shadowRadius = 10.0
        iconImageView.layer.shadowOpacity = 0.6
        iconImageView.layer.shadowPath = UIBezierPath(roundedRect: iconImageView.bounds, cornerRadius: iconImageView.bounds.height / 2).cgPath
        
        let gradient = CAGradientLayer()
        gradient.frame = lowerView.bounds
        gradient.colors = [UIColor(rgb: 0x87246b).cgColor, UIColor(rgb: 0x000084).cgColor]
        lowerView.layer.insertSublayer(gradient, at: 0)
        let gradient2 = CAGradientLayer()
        gradient2.frame = upperView.bounds
        gradient2.colors = [ UIColor(rgb: 0x000084).cgColor, UIColor(rgb: 0x87246b).cgColor]
        upperView.layer.insertSublayer(gradient2, at: 0)
    }
    
    @IBAction func numberTapHandler(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        audioPlayer.play()
        secretPin.append("\(sender.tag)")
        if secretPin.count > 3 {
            animateViewSuccess()
        }
        
    }
}
