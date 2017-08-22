//
//  HeroDetailViewController.swift
//  MarvelDB
//
//  Created by Dario Fanjul on 22/08/2017.
//  Copyright © 2017 Dario Fanjul. All rights reserved.
//

import UIKit

class HeroDetailViewController: UIViewController {
    
    @IBOutlet weak var nameValue: UILabel!
    @IBOutlet weak var realNameValue: UILabel!
    @IBOutlet weak var heightValue: UILabel!
    @IBOutlet weak var powerValue: UILabel!
    @IBOutlet weak var abilityValue: UILabel!
    @IBOutlet weak var groupValue: UILabel!
    @IBOutlet weak var heroImageView: UIImageView!
    
    var hero: Hero!
    var imageProvider: ImageProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestPhoto()
        loadHeroInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        heroImageView.layer.cornerRadius = heroImageView.bounds.height/2
        heroImageView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: Helpers
extension HeroDetailViewController {
    
    fileprivate func loadHeroInfo() {
        nameValue.text = hero.name
        realNameValue.text = hero.realName
        heightValue.text = hero.height
        powerValue.text = hero.power
        abilityValue.text = hero.abilities
        groupValue.text = hero.groups
    }
    
    fileprivate func requestPhoto() {
        imageProvider?.fetchImage(url: hero.photo) {[weak self] (image) in
            DispatchQueue.main.async {
                self?.heroImageView.image = image
            }
        }
    }
    
}
