//
//  Network.swift
//  RocketReserver
//
//  Created by Alla Dubovska on 04.01.2021.
//

import Foundation
import Apollo

class Network {
  static let shared = Network()
    
  private(set) lazy var apollo = ApolloClient(url: URL(string: "https://apollo-fullstack-tutorial.herokuapp.com")!)
}
