## copy file from src to des

<button> Swift </button>

![shifu](./icon.png)

I have a greet idea `> echo hello`, and **then**, you get this...
```swift
let srcPath = Bundle.main.path(forResource: "1", ofType: "png") // get path in bundle
let src = URL(fileURLWithPath: srcPath!)
let desPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] // gt document path
let des = URL(fileURLWithPath:desPath).appendingPathComponent("0.png") // expand with string component
try? FileManager.default.copyItem(at: src, to: des) // copy from to with try?
```
```html
<body>
    <h2>
        abc
    </h2>
</body>
```
[google](http://google.com)

* https://www.google.com/search?q=change+p+tag+height&oq=change+p+tag+height&aqs=chrome..69i57j0l7.4110j0j7&sourceid=chrome&ie=UTF-8

```objective-c
- (NSString *)selectedText {
    return [self.webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
}
```