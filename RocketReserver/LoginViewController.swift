//
//  LoginViewController.swift
//  RocketReserver
//
//  Created by Alla Dubovska on 05.01.2021.
//

import UIKit
import KeychainSwift

class LoginViewController: UIViewController {
    
    static let loginKeychainKey = "login"
    
    private let stackView = UIStackView()
    private let emailTextField = UITextField()
    private let errorLabel = UILabel()
    private let submitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.errorLabel.text = nil
        self.enableSubmitButton(true)
        
        self.setupViews()
    }
    
    @objc private func submitTapped() {
        self.errorLabel.text = nil
        self.enableSubmitButton(false)

        guard let email = self.emailTextField.text else {
            self.errorLabel.text = "Please enter an email address."
            self.enableSubmitButton(true)
            return
        }

        guard self.validate(email: email) else {
            self.errorLabel.text = "Please enter a valid email."
            self.enableSubmitButton(true)
            return
        }
        
        Network.shared.apollo.perform(mutation: LoginMutation(email: email)) { [weak self] result in
            defer {
                self?.enableSubmitButton(true)
            }

            switch result {
            case .success(let graphQLResult):
                if let token = graphQLResult.data?.login {
                    let keychain = KeychainSwift()
                    keychain.set(token, forKey: LoginViewController.loginKeychainKey)
                    self?.dismiss(animated: true)
                }

                if let errors = graphQLResult.errors {
                    print("Errors from server: \(errors)")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func validate(email: String) -> Bool {
        return email.contains("@")
    }
    
    private func enableSubmitButton(_ isEnabled: Bool) {
        self.submitButton.isEnabled = isEnabled
        if isEnabled {
            self.submitButton.setTitle("Submit", for: .normal)
        } else {
            self.submitButton.setTitle("Submitting...", for: .normal)
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        stackView.axis = .vertical
        stackView.spacing = 16
        view.addSubview(stackView)
        [emailTextField, errorLabel, submitButton].forEach(stackView.addArrangedSubview)
        stackView.edgesToSuperview(excluding: .bottom, insets: .uniform(16), usingSafeArea: true)
        
        emailTextField.placeholder = "Email"
        errorLabel.textColor = .red
        submitButton.setTitleColor(.blue, for: .normal)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }
}
