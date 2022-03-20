## How to use Result in Swift `$$ E= MC^2 $$`



[SE-0235](https://github.com/apple/swift-evolution/blob/master/proposals/0235-add-result.md) introduced a `Result` type into the standard library, giving us a simpler, clearer way of handling errors in complex code such as asynchronous APIs. This is something folks have been asking for since the very earliest days of Swift, so it's great to see it finally arrived in Swift 5!

- [ ] good to see it finally arrived in Swift 5!
- [x] great api by the way.

```swift
enum NetworkError: Error {
    case badURL
}
```
