//
//  NetworkManager.swift
//  CryptoApp
//
//  Created by mk.pwnz on 31.05.2021.
//

import Foundation
import Combine

class NetworkManager {
    enum NetworkError: LocalizedError {
        case badURLResponse(url: URL)
        case unkown
        
        var errorDescription: String? {
            switch self {
                case .badURLResponse(url: let url):
                    return "[🔥] Bad response from URL. \(url)"
                default:
                    return "[⚠️] Unknown error"
            }
        }
    }
    
    static func download(from url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ try handleURLRespons(output: $0, url: url) })
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func handleURLRespons(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkError.badURLResponse(url: url)
        }
        return output.data
    }
    
    static func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        switch completion {
            case .finished:
                break
            case .failure(let err):
                print(err.localizedDescription)
        }
    }
}
