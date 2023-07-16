@testable import NetworkService
import NetworkServiceInterface
import NetworkServiceMocks
import XCTest
import Combine

class NetworkProviderTests: XCTestCase {
    private let baseURL = "https://example.com"
    private var subjectUnderTest: NetworkProvider<MockEndpoint>!
    private var mockLogger: MockNetworkLogger!
    private var mockSession: MockURLSession!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        mockLogger = MockNetworkLogger()
        mockSession = MockURLSession()

        subjectUnderTest = NetworkProvider(
            baseURL: baseURL,
            logger: mockLogger,
            urlSession: mockSession
        )

    }

    func testSuccessfulRequest() async throws {
        // Given
        let expectedResponse = ["message": "Hello, world!"]
        let expectedPath = "/api/hello"
        let expectedRequest = URLRequest(url: URL(string: baseURL + expectedPath)!)
        let endpoint = EndpointBuilder()
            .withPath(expectedPath)
            .build()

        mockSession.stubData = try JSONSerialization.data(withJSONObject: expectedResponse, options: [])

        // When
        let response: [String: String] = try await subjectUnderTest.request(endpoint)

        // Then
        XCTAssertEqual(response, expectedResponse)
        XCTAssertEqual(mockSession.request, expectedRequest)
        XCTAssertTrue(mockLogger.didCallLogRequest)
        XCTAssertTrue(mockLogger.didCallLogResponse)
        XCTAssertFalse(mockLogger.didCallLogError)
    }

    func testSuccessfulRequest_EndpointHasBasURL() async throws {
        // Given
        let expectedResponse = ["message": "Hello, world!"]
        let expectedURLString = "www.google.com"
        let expectedPath = "/api/hello"
        let expectedRequest = URLRequest(url: URL(string: expectedURLString + expectedPath)!)
        let endpoint = EndpointBuilder()
            .withPath(expectedPath)
            .withBaseURL(expectedURLString)
            .build()

        mockSession.stubData = try JSONSerialization.data(withJSONObject: expectedResponse, options: [])

        // When
        let response: [String: String] = try await subjectUnderTest.request(endpoint)

        // Then
        XCTAssertEqual(response, expectedResponse)
        XCTAssertEqual(mockSession.request, expectedRequest)
        XCTAssertTrue(mockLogger.didCallLogRequest)
        XCTAssertTrue(mockLogger.didCallLogResponse)
        XCTAssertFalse(mockLogger.didCallLogError)
    }

    func testRequestFailure() async throws {
        // Given
        let expectedPath = "/api/hello"
        let expectedRequest = URLRequest(url: URL(string: baseURL + expectedPath)!)
        let endpoint = EndpointBuilder()
            .withPath(expectedPath)
            .build()
        let expectedError = NetworkError.parsingError
        mockSession.stubError = expectedError

        // When
        var resultError: Error?
        do {
            let _: [String: String] = try await subjectUnderTest.request(endpoint)
        } catch {
            resultError = error
        }

        XCTAssertEqual(resultError as? NetworkError, expectedError)
        XCTAssertEqual(mockSession.request, expectedRequest)
        XCTAssertTrue(mockLogger.didCallLogRequest)
        XCTAssertFalse(mockLogger.didCallLogResponse)
        XCTAssertTrue(mockLogger.didCallLogError)
    }

    func testSuccessfulRequest_Combine() throws {
        // Given
        let expectedResponse = ["message": "Hello, world!"]
        let expectedPath = "/api/hello"
        let expectedRequest = URLRequest(url: URL(string: baseURL + expectedPath)!)
        let endpoint = EndpointBuilder()
            .withPath(expectedPath)
            .build()

        mockSession.stubCombineData = try JSONSerialization.data(withJSONObject: expectedResponse, options: [])

        let expectation = expectation(description: "Result returned")
        expectation.expectedFulfillmentCount = 2

        // When
        var response: [String: String]?
        subjectUnderTest
            .request(endpoint)
            .sink { result in
                switch result {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    break
                }
            } receiveValue: { (result: [String: String]) in
                response = result
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Then
        waitForExpectations(timeout: 5)
        XCTAssertNotNil(response)
        XCTAssertEqual(response, expectedResponse)
        XCTAssertEqual(mockSession.combineRequest, expectedRequest)
        XCTAssertTrue(mockLogger.didCallLogRequest)
        XCTAssertTrue(mockLogger.didCallLogResponse)
        XCTAssertFalse(mockLogger.didCallLogError)
    }

    func testSuccessfulRequest_EndpointHasBasURL_Combine() throws {
        // Given
        let expectedResponse = ["message": "Hello, world!"]
        let expectedURLString = "www.google.com"
        let expectedPath = "/api/hello"
        let expectedRequest = URLRequest(url: URL(string: expectedURLString + expectedPath)!)
        let endpoint = EndpointBuilder()
            .withPath(expectedPath)
            .withBaseURL(expectedURLString)
            .build()

        mockSession.stubCombineData = try JSONSerialization.data(withJSONObject: expectedResponse, options: [])

        let expectation = expectation(description: "Result returned")
        expectation.expectedFulfillmentCount = 2

        // When
        var response: [String: String]?
        subjectUnderTest
            .request(endpoint)
            .sink { result in
                switch result {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    break
                }
            } receiveValue: { (result: [String: String]) in
                response = result
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(response)
        XCTAssertEqual(response, expectedResponse)
        XCTAssertEqual(mockSession.combineRequest, expectedRequest)
        XCTAssertTrue(mockLogger.didCallLogRequest)
        XCTAssertTrue(mockLogger.didCallLogResponse)
        XCTAssertFalse(mockLogger.didCallLogError)
    }

    func testRequestFailure_Combine() throws {
        // Given
        let expectedPath = "/api/hello"
        let expectedRequest = URLRequest(url: URL(string: baseURL + expectedPath)!)
        let endpoint = EndpointBuilder()
            .withPath(expectedPath)
            .build()
        let expectedError = URLError(.badURL)
        mockSession.stubCombineError = expectedError

        let expectation = expectation(description: "Request Failed")

        // When
        var response: [String: String]?
        var resultError: Error?
        subjectUnderTest
            .request(endpoint)
            .sink { result in
                switch result {
                case .finished:
                    break
                case let .failure(error):
                    resultError = error
                    expectation.fulfill()
                }
            } receiveValue: { (result: [String: String]) in
                response = result
            }
            .store(in: &cancellables)

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertNil(response)
        XCTAssertNotNil(resultError)
        XCTAssertEqual(resultError as? URLError, expectedError)
        XCTAssertEqual(mockSession.combineRequest, expectedRequest)
        XCTAssertTrue(mockLogger.didCallLogRequest)
        XCTAssertFalse(mockLogger.didCallLogResponse)
        XCTAssertTrue(mockLogger.didCallLogError)
    }

    func testRequestFailure_Combine_TypeMismatch() throws {
        // Given
        let expectedPath = "/api/hello"
        let expectedRequest = URLRequest(url: URL(string: baseURL + expectedPath)!)
        let endpoint = EndpointBuilder()
            .withPath(expectedPath)
            .build()

        let expectation = expectation(description: "Request Failed")
        mockSession.stubCombineData = try JSONSerialization.data(withJSONObject: ["Hello": 1], options: [])

        // When
        var response: [String: String]?
        var resultError: Error?
        subjectUnderTest
            .request(endpoint)
            .sink { result in
                switch result {
                case .finished:
                    break
                case let .failure(error):
                    resultError = error
                    expectation.fulfill()
                }
            } receiveValue: { (result: [String: String]) in
                response = result
            }
            .store(in: &cancellables)

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertNil(response)
        XCTAssertNotNil(resultError)
        XCTAssertTrue(resultError is DecodingError)
        XCTAssertEqual(mockSession.combineRequest, expectedRequest)
        XCTAssertTrue(mockLogger.didCallLogRequest)
        XCTAssertTrue(mockLogger.didCallLogResponse)
        XCTAssertTrue(mockLogger.didCallLogError)
    }

}
