# SoundWaveImageDemo

[Github: DSWaveformImage](https://github.com/dmrschmidt/DSWaveformImage)

```swift
func drawWave(){
    let waveformImageDrawer = WaveformImageDrawer()
    waveformImageDrawer.waveformImage(fromAudioAt: url, with: .init(
        size: CGSize(300, 150),
        style: .gradient([.red, .orange]),
        position: .middle,
        verticalScalingFactor: 0.5)) { image in
            // need to jump back to main queue
            DispatchQueue.main.async {
                if let image = image{
                    self.image = image
                }
            }
        }
}
```