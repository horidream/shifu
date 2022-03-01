## How to use Result in Swift

[SE-0235](https://github.com/apple/swift-evolution/blob/master/proposals/0235-add-result.md) introduced a `Result` type into the standard library, giving us a simpler, clearer way of handling errors in complex code such as asynchronous APIs. This is something folks have been asking for since the very earliest days of Swift, so it's great to see it finally arrived in Swift 5!

Swift's `Result` type is implemented as an enum that has two cases: `success` and `failure`. Both are implemented using generics so they can have an associated value of your choosing, but `failure` must be something that conforms to Swift's `Error` type. If you want, you can use a specific error type of your making, such as `NetworkError` or `AuthenticationError`, allowing us to have typed throws for the first time in Swift, but this isn't required.

To demonstrate `Result`, we could write a function that connects to a remote server to figure out how many unread messages are waiting for the user. In this example code we're going to have just one possible error, which is that the requested URL string isn't valid:

```swift
enum NetworkError: Error {
    case badURL
}
```

The fetching function will accept a URL string as its first parameter, and a completion handler as its second parameter. That completion handler will itself accept a `Result`, where the success case will store an integer saying how many unread messages there are, and the failure case will be some sort of `NetworkError`. We're not actually going to connect to a server here, but using a completion handler at least lets us simulate asynchronous code -- trying to return a value directly would cause the UI to freeze if we were doing real networking.

Here's the code:

```swift
func fetchUnreadCount1(from urlString: String, completionHandler: @escaping (Result<Int, NetworkError>) -> Void)  {
    guard let url = URL(string: urlString) else {
        completionHandler(.failure(.badURL))
        return
    }

    // complicated networking code here
    print("Fetching \(url.absoluteString)...")
    completionHandler(.success(5))
}
```