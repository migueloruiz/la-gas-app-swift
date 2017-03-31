//
//  EditLocationViewController.swift
//  lasgasmx
//
//  Created by Miguelo Ruiz on 30/03/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class EditLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        if let nav = self.navigationController {
            print("nav")
            nav.isNavigationBarHidden = false
            nav.navigationBar.backItem?.title = ""
        } else {
            print("no nav")
        }
    }

}
