## How to use Result in Swift 


![](https://i0.wp.com/dorkygeekynerdy.com/wp-content/uploads/2019/02/lord-of-the-rings-tolkien-trivia-header.jpg)
<!-- ![](https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_.jpg) -->

`$$ E= MC^2 $$`

[SE-0235](https://github.com/apple/swift-evolution/blob/master/proposals/0235-add-result.md) introduced a `Result` type into the standard library, giving us a simpler, clearer way of handling errors in complex code such as asynchronous APIs. This is something folks have been asking for since the very earliest days of Swift, so it's great to see it finally arrived in Swift 5!

- [ ] good to see it finally arrived in Swift 5!
- [x] great api by the way.

```swift
enum NetworkError: Error {
    case badURL
}
```
