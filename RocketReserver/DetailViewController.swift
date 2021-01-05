//
//  DetailViewController.swift
//  RocketReserver
//
//  Created by Alla Dubovska on 04.01.2021.
//

import UIKit
import Apollo
import TinyConstraints

class DetailViewController: UIViewController {
    
    private let launchID: GraphQLID
    
    private let label = UILabel()
    
    init(launchID: GraphQLID) {
        self.launchID = launchID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(label)
        label.edgesToSuperview()
        configureView()
    }
    
    func configureView() {
      label.text = "Launch \(launchID)"
    }
}
