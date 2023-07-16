import NetworkServiceInterface
import Combine

public final class NetworkProviderMock<EndpointType: Endpoint>: BaseNetworkProvider<EndpointType> {
    public override init() {}

    public var stubResponse: Decodable = ""
    public var stubError: Error?
    public private(set) var didCallRequest = false
    public override func request<ResponseType: Decodable>(
        _ endpoint: EndpointType
    ) async throws -> ResponseType {
        didCallRequest = true
        if let stubError {
            throw stubError
        }

        guard let response = stubResponse as? ResponseType else {
            throw NetworkError.parsingError
        }

        return response
    }

    public var stubCombineResponse: Decodable = ""
    public var stubCombineError: Error?
    public private(set) var didCallCombineRequest = false
    public override func request<ResponseType: Decodable>(
        _ endpoint: EndpointType
    ) -> AnyPublisher<ResponseType, Error> {
        didCallCombineRequest = true
        if let stubCombineError {
            return Fail(error: stubCombineError)
                .eraseToAnyPublisher()
        }

        guard let response = stubCombineResponse as? ResponseType else {
            return Fail(error: NetworkError.parsingError)
                .eraseToAnyPublisher()
        }

        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
