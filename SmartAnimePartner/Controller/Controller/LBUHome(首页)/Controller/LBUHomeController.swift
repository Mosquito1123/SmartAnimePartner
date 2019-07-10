//
//  AppDelegate.swift
//  SmartAnimePartner
//
//  Created by Mosquito1123 on 11/07/2019.
//  Copyright © 2019 Cranberry. All rights reserved.
//

import UIKit

class LBUHomeController: LBUPageController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_search"),
                                                            target: self,
                                                            action: #selector(searchButtonClick))
    }
    
    @objc private func searchButtonClick() {
        navigationController?.pushViewController(LBUSearchController(), animated: true)
    }

}
