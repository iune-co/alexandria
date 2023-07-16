import NetworkServiceInterface
import Foundation
import Combine

extension URLSession: URLSessionProtocol {
    public func dataPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        dataTaskPublisher(for: request)
            .eraseToAnyPublisher()
    }
}
