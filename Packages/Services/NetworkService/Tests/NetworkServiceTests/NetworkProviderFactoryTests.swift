@testable import NetworkService
import XCTest
import NetworkServiceMocks

final class NetworkProviderFactoryTests: XCTestCase {
    func testMake_ReturnsNetworkProvider_WithGivenBaseURLAndLogger() {
        // Given
        let baseURL = "https://example.com/api/"
        let factory = NetworkProviderFactory(baseURL: baseURL, logLevel: .all)

        // When
        let provider = factory.make(MockEndpoint.self)

        // Then
        XCTAssertTrue(provider is NetworkProvider<MockEndpoint>)
        XCTAssertNotNil(factory.networkLogger)
    }

    func testMake_ReturnsNetworkProvider_WithNilLogger_WhenLogLevelIsNone() async {
        // Given
        let baseURL = "https://example.com/api/"
        let factory = NetworkProviderFactory(baseURL: baseURL, logLevel: .none)

        // When
        let provider = factory.make(MockEndpoint.self)

        // Then
        XCTAssertTrue(provider is NetworkProvider<MockEndpoint>)
        XCTAssertNil(factory.networkLogger)
    }
}
