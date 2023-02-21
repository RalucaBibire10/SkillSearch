import SwiftUI

struct RoundImage: View {
    
    @Binding var imageData: Data?
    var size: CGFloat = .Size.xSmall
    var placeholderImage: String = Image.blankProfile
    var imageName: String?
    
    
    
    var body: some View {
        if let name = imageName {
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
        } else if let data = imageData {
            Image(uiImage: (UIImage(data: data)?.resizeImage(newWidth: 200) ??
                            UIImage(named: placeholderImage)!.resizeImage(newWidth: 200)))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipShape(Circle())
        } else {
            Image(placeholderImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
        }
    }
}

struct RoundImage_Previews: PreviewProvider {
    static var previews: some View {
        RoundImage(imageData: .constant(Data()))
    }
}
