public protocol NetworkProviderFactoryProtocol {
    func make<EndpointType: Endpoint>(_: EndpointType.Type) -> BaseNetworkProvider<EndpointType>
}
