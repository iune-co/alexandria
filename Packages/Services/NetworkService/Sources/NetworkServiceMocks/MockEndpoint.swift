import NetworkServiceInterface

public struct MockEndpoint: Endpoint {
    public let baseURL: String?
    public let path: String
    public let method: HTTPMethod
    public let headers: [String: String?]?
    public let body: RequestBody

    public init(
        baseURL: String?,
        path: String,
        method: HTTPMethod,
        headers: [String: String?]?,
        body: RequestBody
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.body = body
    }
}
