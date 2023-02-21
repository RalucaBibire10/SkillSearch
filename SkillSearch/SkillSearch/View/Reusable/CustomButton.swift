import SwiftUI

struct CustomButton: View {
    let title: String
    let color: Color
    
    init(title: String, color: Color = .appGreen) {
        self.title = title
        self.color = color
    }
    
    var body: some View {
        Text(title)
            .font(.system(.title3, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, .Padding.xxSmall)
            .buttonStyle(.borderedProminent)
            .background(Rectangle()
                .foregroundColor(color)
                .cornerRadius(.CornerRadius.medium)
            )
    }
}

struct GetStartedButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(title: "Get Started")
    }
}
