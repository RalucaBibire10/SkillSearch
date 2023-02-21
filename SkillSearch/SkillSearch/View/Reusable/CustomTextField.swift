import SwiftUI

struct CustomTextField: View {
    var placeHolder: String
    var borderColor: Color = .gray
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .never
    var isPassword: Bool = false
    
    @Binding var textInput: String
    @State var hideContent: Bool = false
    @FocusState var isInFocus: Bool
    
    var body: some View {
        HStack {
            if hideContent {
                SecureField(placeHolder, text: $textInput)
                    .focused($isInFocus, equals: true)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(autocapitalization)
            } else {
                TextField(placeHolder, text: $textInput)
                    .focused($isInFocus)
                    .opacity(hideContent ? 0 : 1)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(autocapitalization)
                    .autocorrectionDisabled()
            }
            
            Spacer()
            
            if isPassword {
                (hideContent ? Image.show : Image.hide)
                    .foregroundColor(isInFocus ? .appGreen : .gray)
                    .onTapGesture {
                        hideContent.toggle()
                    }
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: .CornerRadius.small)
                .stroke(isInFocus ? Color.appGreen : .gray)
        )
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(placeHolder: "Email", isPassword: true, textInput: .constant(""), hideContent: true)
    }
}
