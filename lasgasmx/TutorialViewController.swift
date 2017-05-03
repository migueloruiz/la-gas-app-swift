//
//  TutorialViewController.swift
//  lasgasmx
//
//  Created by Desarrollo on 5/3/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    
    init() { super.init(nibName: nil, bundle: nil) }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        setupNavigationBar()
        
    }
    
    func setupNavigationBar() {
        guard let nav = self.navigationController else { return }
        nav.isNavigationBarHidden = true
    }
    
}

