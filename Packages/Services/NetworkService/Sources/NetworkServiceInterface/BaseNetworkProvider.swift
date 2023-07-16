import Combine

// swiftlint:disable line_length
/// A base class for network providers that handle network requests using endpoints.
///
/// This class should not be used directly to make network requests.
/// Instead, its subclass `NetworkProvider` is supposed to handke network requests.
/// Subclasses can use endpoint enums to define the structure of their network requests.
open class BaseNetworkProvider<EndpointType: Endpoint> {

    /// Initializes a new instance of `BaseNetworkProvider`.
    ///
    /// - Note: This class should not be used directly to make network requests.
    /// - Note: Instead, use the subclass `NetworkProvider` to handle network requests.
    public init() {}

    /// Performs a network request using the specified endpoint.
    ///
    /// Subclasses should override this method to provide custom behavior for network requests.
    /// The default implementation throws a `NetworkError.requestFunctionNotImplemented` error.
    ///
    /// - Parameter endpoint: The endpoint to use for the network request.
    /// - Returns: A decoded response object of the specified type.
    /// - Throws: A `Error` if there was an error with the network request or response.
    open func request<ResponseType: Decodable>(_ endpoint: EndpointType) async throws -> ResponseType {
        throw NetworkError.requestFunctionNotImplemented
    }

    /**
     Performs a network request to the server using the given endpoint and returns the response object as a `AnyPublisher` that emits a single value and then completes.

     - Parameter endpoint: The `EndpointType` object that defines the details of the API request to be made.
     - Returns: An `AnyPublisher` object that emits a response object of type `ResponseType` that conforms to the `Decodable` protocol.
     - Note: This implementation uses `Combine` framework to handle the asynchronous network requests and decoding of the response.
     */
    open func request<ResponseType: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<ResponseType, Error> {
        Fail(error: NetworkError.requestFunctionNotImplemented)
            .eraseToAnyPublisher()
    }
}
