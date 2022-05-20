## How to use Result in Swift 


![](https://cdn.i-scmp.com/sites/default/files/styles/1200x800/public/d8/video/thumbnail/2021/08/14/lotr.jpg?itok=y_dh_Rrp)
`$$ E= MC^2 $$`

[SE-0235](https://github.com/apple/swift-evolution/blob/master/proposals/0235-add-result.md) introduced a `Result` type into the standard library, giving us a simpler, clearer way of handling errors in complex code such as asynchronous APIs. This is something folks have been asking for since the very earliest days of Swift, so it's great to see it finally arrived in Swift 5!

- [ ] good to see it finally arrived in Swift 5!
- [x] great api by the way.

```swift
enum NetworkError: Error {
    case badURL
}
```
