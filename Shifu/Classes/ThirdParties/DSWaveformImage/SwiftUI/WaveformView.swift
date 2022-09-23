import SwiftUI

@available(iOS 15.0, *)
public struct WaveformView: View {
    public static let defaultConfiguration = Waveform.Configuration(dampening: .init(percentage: 0.125, sides: .both))

    @Binding public var audioURL: URL
    @Binding public var configuration: Waveform.Configuration

    @StateObject private var waveformDrawer = WaveformImageDrawer()
    @State private var waveformImage: UIImage = UIImage()

    public init(
        audioURL: Binding<URL>,
        configuration: Binding<Waveform.Configuration> = .constant(defaultConfiguration)
    ) {
        _audioURL = audioURL
        _configuration = configuration
    }

    public var body: some View {
        GeometryReader { geometry in
            Image(uiImage: waveformImage)
                .resizable()
                .onAppear {
                    guard waveformImage.size == .zero else { return }
                    update(geometry: geometry)
                }
                .onChange(of: audioURL) { _ in update(geometry: geometry) }
                .onChange(of: configuration) { _ in update(geometry: geometry) }
                .onChange(of: geometry.size) { _ in update(geometry: geometry) }
        }
    }

    private func update(geometry: GeometryProxy) {
        waveformDrawer.waveformImage(fromAudioAt: audioURL, with: configuration.with(size: geometry.size)) { waveformImage in
            guard let newImage = waveformImage else { return }
            DispatchQueue.main.async {
                self.waveformImage = newImage
            }
        }
    }
}
