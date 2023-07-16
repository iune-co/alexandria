@testable import NetworkService
import Foundation

final class MockNetworkLogger: NetworkLoggerProtocol {
    private(set) var loggedRequest: URLRequest?
    private(set) var didCallLogRequest = false
    func log(request: URLRequest) {
        loggedRequest = request
        didCallLogRequest = true
    }

    private(set) var loggedResponse: (URLResponse, Data?)?
    private(set) var didCallLogResponse = false
    func log(response: URLResponse, data: Data?) {
        loggedResponse = (response, data)
        didCallLogResponse = true
    }

    private(set) var loggedError: Error?
    private(set) var didCallLogError = false
    func log(error: Error) {
        loggedError = error
        didCallLogError = true
    }
}
