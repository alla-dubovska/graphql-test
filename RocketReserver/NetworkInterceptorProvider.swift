//
//  NetworkInterceptorProvider.swift
//  RocketReserver
//
//  Created by Alla Dubovska on 05.01.2021.
//

import Foundation
import Apollo

class NetworkInterceptorProvider: LegacyInterceptorProvider {
    override func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(TokenAddingInterceptor(), at: 0)
        return interceptors
    }
}
