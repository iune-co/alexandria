import NetworkServiceInterface
import Foundation
import Combine

final class NetworkProvider<EndpointType: Endpoint>: BaseNetworkProvider<EndpointType> {
    private let baseURL: String
    private let logger: NetworkLoggerProtocol?
    private let urlSession: URLSessionProtocol

    init(
        baseURL: String,
        logger: NetworkLoggerProtocol?,
        urlSession: URLSessionProtocol = URLSession.shared
    ) {
        self.baseURL = baseURL
        self.logger = logger
        self.urlSession = urlSession

        super.init()
    }

    override func request<ResponseType: Decodable>(_ endpoint: EndpointType) async throws -> ResponseType {
        do {
            let urlRequest = try prepareUrlRequest(for: endpoint)
            logger?.log(request: urlRequest)
            let (data, httpResponse) = try await urlSession.data(for: urlRequest)
            logger?.log(response: httpResponse, data: data)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(ResponseType.self, from: data)
        } catch {
            logger?.log(error: error)
            throw error
        }
    }

    override func request<ResponseType: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<ResponseType, Error> {
        do {
            let urlRequest = try prepareUrlRequest(for: endpoint)
            logger?.log(request: urlRequest)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            // swiftlint:disable:next trailing_closure
            return urlSession.dataPublisher(for: urlRequest)
                .handleEvents(receiveOutput: { [weak self] data, response in
                    self?.logger?.log(response: response, data: data)
                })
                .map(\.data)
                .decode(type: ResponseType.self, decoder: decoder)
                .mapError { [weak self] error in
                    self?.logger?.log(error: error)
                    return error
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } catch {
            logger?.log(error: error)
            return Fail(error: error)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - Private Methods
extension NetworkProvider {
    private func prepareUrlRequest(for endpoint: EndpointType) throws -> URLRequest {
        let urlString = (endpoint.baseURL ?? baseURL) + endpoint.path

        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidUrl
        }

        var urlRequest = URLRequest(url: url)

        endpoint.headers?.forEach { header in
            guard let value = header.value else { return }
            urlRequest.addValue(value, forHTTPHeaderField: header.key)
        }

        urlRequest.httpMethod = endpoint.method.rawValue

        switch endpoint.body {
        case .plain:
            break
        case let .encodable(parameters):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            urlRequest.addValue("application/json", forHTTPHeaderField: HTTPHeaderName.contentType.rawValue)
        case let .queryParameter(parameters):
            guard var urlComponents = URLComponents(string: urlString) else {
                return urlRequest
            }

            let queryItem = parameters.compactMap { param -> URLQueryItem? in
                guard let value = param.value else { return nil }
                return URLQueryItem(name: param.key, value: String(describing: value))
            }
            urlComponents.queryItems = queryItem
            urlRequest.url = urlComponents.url
        }

        return urlRequest
    }
}
