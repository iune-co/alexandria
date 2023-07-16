import Foundation
import NetworkServiceInterface
import Combine

class MockURLSession: URLSessionProtocol {
    var stubData = Data()
    var stubResponse = URLResponse()
    var stubError: Error?
    private(set) var request: URLRequest?
    private(set) var didCallDataForRequest = false

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        self.request = request
        didCallDataForRequest = true
        if let stubError {
            throw stubError
        }
        return (stubData, stubResponse)
    }

    var stubCombineData = Data()
    var stubCombineResponse = URLResponse()
    var stubCombineError: URLError?
    private(set) var combineRequest: URLRequest?
    private(set) var didCalldataTaskPublisher = false

    func dataPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        self.combineRequest = request
        didCalldataTaskPublisher = true

        if let stubCombineError {
            return Fail(error: stubCombineError)
                .eraseToAnyPublisher()

        }
        return Just((stubCombineData, stubCombineResponse))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}
