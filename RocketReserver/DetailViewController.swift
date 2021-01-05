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
    
    private var launch: LaunchDetailsQuery.Data.Launch? {
        didSet {
            self.configureView()
        }
    }
    private let launchID: GraphQLID
    
    private let stackView = UIStackView()
    private let missionPatchImageView = UIImageView()
    private let missionNameLabel = UILabel()
    private let rocketNameLabel = UILabel()
    private let launchSiteLabel = UILabel()
    private let bookCancelButton = UIBarButtonItem()
    
    init(launchID: GraphQLID) {
        self.launchID = launchID
        super.init(nibName: nil, bundle: nil)
        
        loadLaunchDetails()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        
        self.missionNameLabel.text = "Loading..."
        self.launchSiteLabel.text = nil
        self.rocketNameLabel.text = nil
        self.configureView()
    }
    
    private func configureView() {
        guard let launch = self.launch else {
                return
        }
        
        self.missionNameLabel.text = launch.mission?.name
        self.title = launch.mission?.name

        let placeholder = UIImage(named: "placeholder_logo")!
            
        if let missionPatch = launch.mission?.missionPatch {
            self.missionPatchImageView.sd_setImage(with: URL(string: missionPatch)!, placeholderImage: placeholder)
        } else {
            self.missionPatchImageView.image = placeholder
        }

        if let site = launch.site {
            self.launchSiteLabel.text = "Launching from \(site)"
        } else {
            self.launchSiteLabel.text = nil
        }
            
        if
            let rocketName = launch.rocket?.name ,
            let rocketType = launch.rocket?.type {
                self.rocketNameLabel.text = "🚀 \(rocketName) (\(rocketType))"
        } else {
            self.rocketNameLabel.text = nil
        }
            
        if launch.isBooked {
            self.bookCancelButton.title = "Cancel trip"
            self.bookCancelButton.tintColor = .red
        } else {
            self.bookCancelButton.title = "Book now!"
            self.bookCancelButton.tintColor = self.view.tintColor
        }
    }
    
    private func loadLaunchDetails() {
      guard launchID != self.launch?.id else {
            // This is the launch we're already displaying, or the ID is nil.
            return
      }
        
      Network.shared.apollo.fetch(query: LaunchDetailsQuery(id: launchID)) { [weak self] result in
            guard let self = self else {
                return
            }
        
            switch result {
            case .failure(let error):
                print("NETWORK ERROR: \(error)")
            case .success(let graphQLResult):
                if let launch = graphQLResult.data?.launch {
                    self.launch = launch
                }
        
                if let errors = graphQLResult.errors {
                    print("GRAPHQL ERRORS: \(errors)")
                }
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        stackView.axis = .vertical
        stackView.spacing = 16
        missionPatchImageView.contentMode = .scaleAspectFit
        view.addSubview(stackView)
        [missionPatchImageView, missionNameLabel, rocketNameLabel, launchSiteLabel].forEach(stackView.addArrangedSubview)
        stackView.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        
        missionPatchImageView.height(140)
        missionPatchImageView.width(140)
    }
}
