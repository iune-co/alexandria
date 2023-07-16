import NetworkServiceInterface

public class EndpointBuilder {
    private var baseURL: String?
    private var path: String = ""
    private var method: HTTPMethod = .get
    private var headers: [String: String?]?
    private var body: RequestBody = .plain

    public init() {}

    public func withBaseURL(_ baseURL: String?) -> EndpointBuilder {
        self.baseURL = baseURL
        return self
    }

    public func withPath(_ path: String) -> EndpointBuilder {
        self.path = path
        return self
    }

    public func withMethod(_ method: HTTPMethod) -> EndpointBuilder {
        self.method = method
        return self
    }

    public func withHeaders(_ headers: [String: String?]?) -> EndpointBuilder {
        self.headers = headers
        return self
    }

    public func withBody(_ body: RequestBody) -> EndpointBuilder {
        self.body = body
        return self
    }

    public func build() -> MockEndpoint {
        return MockEndpoint(
            baseURL: baseURL,
            path: path,
            method: method,
            headers: headers,
            body: body
        )
    }
}
