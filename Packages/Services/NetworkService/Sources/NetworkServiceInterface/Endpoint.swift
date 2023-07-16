public protocol Endpoint {
    /// The base URL for the API endpoint.
    ///
    /// This property specifies the base URL for the API endpoint. The base URL should include
    /// the protocol (http or https), the domain name, and any other necessary components of the URL
    /// that are shared across multiple endpoints. The value of this property must be provided by
    /// each individual endpoint in order to form a complete URL.
    ///
    var baseURL: String? { get }

    /// The path component of the API endpoint's URL.
    ///
    /// This property specifies the path component of the API endpoint's URL. This is typically
    /// the part of the URL that comes after the domain name, but before any query parameters.
    /// The value of this property must be provided by each individual endpoint in order to
    /// form a complete URL.
    ///
    var path: String { get }

    /// The HTTP method used for this endpoint.
    ///
    /// This property determines the HTTP method that will be used when making a network request
    /// using this endpoint. The default value is `.get`, which specifies that the HTTP `GET`
    /// method should be used.
    ///
    var method: HTTPMethod { get }

    /// The HTTP headers to include in the request.
    ///
    /// This property specifies any HTTP headers that should be included in the request
    /// when using this endpoint. The default value is `nil`, indicating that no headers
    /// should be included.
    ///
    var headers: [String: String?]? { get }

    /// The request body to include in the request.
    ///
    /// This property specifies the request body that should be included in the request when
    /// using this endpoint. The default value is `.plain`, indicating that no body should be
    /// included.
    ///
    var body: RequestBody { get }
}

// MARK: - Default values
public extension Endpoint {
    var baseURL: String? {
        nil
    }

    var method: HTTPMethod {
        .get
    }

    var headers: [String: String?]? {
        nil
    }

    var body: RequestBody {
        .plain
    }
}
