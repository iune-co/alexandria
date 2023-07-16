import NetworkServiceInterface

public final class NetworkProviderFactory: NetworkProviderFactoryProtocol {
    private let baseURL: String
    let networkLogger: NetworkLoggerProtocol?

    public init(
        baseURL: String,
        logLevel: LogLevel = .all
    ) {
        self.baseURL = baseURL

        #if DEBUG
            switch logLevel {
            case .none:
                networkLogger = nil
            case .all:
                networkLogger = NetworkLogger()
            }
        #else
            networkLogger = nil
        #endif
    }

    public func make<EndpointType: Endpoint>(_: EndpointType.Type) -> BaseNetworkProvider<EndpointType> {
        NetworkProvider(baseURL: baseURL, logger: networkLogger)
    }
}

public enum LogLevel {
    case none
    case all
}
