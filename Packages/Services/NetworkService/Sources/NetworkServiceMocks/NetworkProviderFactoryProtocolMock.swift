import NetworkServiceInterface

public final class NetworkProviderFactoryProtocolMock: NetworkProviderFactoryProtocol {
    public init() {}

    public private(set) var didCallMake = false
    public var stubNetworkProvider: AnyObject?
    public func make<EndpointType: Endpoint>(_: EndpointType.Type) -> BaseNetworkProvider<EndpointType> {
        didCallMake = true
        return (stubNetworkProvider as? BaseNetworkProvider<EndpointType>) ?? NetworkProviderMock<EndpointType>()
    }
}
