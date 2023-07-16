# NetworkService Package
This package provides a base class for network providers that handle network requests using enums. It also includes three libraries: `NetworkService`, `NetworkServiceInterface`, and `NetworkServiceMocks`.

## Libraries
NetworkService
This library contains the implementation of the `BaseNetworkProvider` class, which is the base class for network providers that handle network requests using endpoints. It also includes the `NetworkProvider` class, which is a subclass of `BaseNetworkProvider` that provides a default implementation of the request method. This target should only be used inside the Dependency Container and the snapshot tests. Otherwise, it should be injected.

## NetworkServiceInterface
This library contains the `Endpoint` protocol and the `HTTPMethod` and `RequestBody` enums, which define the structure of network requests. It also includes the `NetworkProviderFactoryProtocol` protocol, which provides a factory method to create instances of `BaseNetworkProvider` for a specific endpoint type.

## NetworkServiceMocks
This library contains mock implementations of the classes and protocols defined in the NetworkService and NetworkServiceInterface libraries.

## Usage
To use `NetworkService`, you need to:

Add the Dependency to your packages inside `Package.swift`:
```swift
.product(name: "NetworkServiceInterface", package: "NetworkService")
```

Then, import the `NetworkServiceInterface` modules in your source code:
```swift
import NetworkServiceInterface
```
You can then create an instance of NetworkProvider using the factory and use it to make network requests using async/await:

```swift
do {
    let response: MyResponse = try await networkProvider.request(.myEndpoint)
    // handle response
} catch {
    // handle error
}
```


Combine Usage
This package also includes a Combine-based API for making network requests using AnyPublisher. To use this API, call the request method with an endpoint as the parameter:

```swift
networkProvider.request(.myEndpoint)
    .sink(receiveCompletion: { completion in
        // handle completion
    }, receiveValue: { (response: MyResponse) in
        // handle response
    })
    .store(in: &cancellables)
```
Alternatively, you can create a custom subclass of `BaseNetworkProvider` to provide your own implementation of the request method.
