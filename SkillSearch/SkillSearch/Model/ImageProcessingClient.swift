import SwiftUI
import PhotosUI
import ComposableArchitecture

struct ImageProcessingClient {
    var transformImage: (PhotosPickerItem) -> EffectTask<Data?>
    
    static let live = Self { image in
        EffectTask.task {
            let data = try? await image.loadTransferable(type: Data.self)
            return data
        }
        .eraseToEffect()
    }
}
