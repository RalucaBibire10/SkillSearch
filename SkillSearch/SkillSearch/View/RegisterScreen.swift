import SwiftUI
import PhotosUI
import FirebaseAuth
import ComposableArchitecture

struct RegisterScreen: View {
    let store: StoreOf<RegisterReducer>
    
    
    public init(store: StoreOf<RegisterReducer>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            VStack(spacing: .Spacing.medium) {
                welcomeMessage
                photoPicker
                emailField
                passwordField
                nameField
                skillsField
                
                if !viewStore.error.isEmpty {
                    Text(viewStore.error)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
                signUpButton
                Spacer()
            }
            .padding(.Padding.xSmall)
            .navigationBarBackButtonHidden()
            .navigationBarItems(leading: BackButton()
                .onTapGesture {
                    viewStore.send(.navigateBack)
                })
        }
        
    }
    
    private var welcomeMessage: some View {
        Text(Localization.registerScreenWelcome)
            .font(.system(.title, weight: .bold))
            .frame(maxWidth: .infinity,
                   alignment: .leading)
            .padding(.vertical)
    }
    
    private var addImage: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            if let data = viewStore.imageData {
                RoundImage(imageData: .constant(data), size: .Size.large,
                           placeholderImage: Image.add)
                    .padding(.vertical)
            } else {
                RoundImage(imageData: .constant(Data()), size: .Size.large, imageName: Image.add)
                    .padding(.vertical)
            }
        }
    }
    
    private var photoPicker: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            PhotosPicker(
                selection: viewStore.binding(
                    get: \.image,
                    send: { RegisterAction.imageChanged(to: $0) }),
                matching: .images,
                photoLibrary: .shared()
            ) {
                addImage
            }
            .onChange(of: viewStore.image) { newImage in
                viewStore.send(.onImageChange)
            }
        }
    }
    
    private var emailField: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            CustomTextField(
                placeHolder: Localization.registerScreenEmail,
                keyboardType: .emailAddress,
                textInput: viewStore.binding(
                    get: \.email,
                    send: { RegisterAction.emailChanged(to: $0) }
                ),
                hideContent: false)
        }
    }
    
    private var passwordField: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            CustomTextField(
                placeHolder: Localization.registerScreenPassword,
                isPassword: true,
                textInput: viewStore.binding(
                    get: \.password,
                    send: { RegisterAction.passwordChanged(to: $0)}
                ),
                hideContent: true)
        }
    }
    
    private var nameField: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            CustomTextField(
                placeHolder: Localization.registerScreenFullName,
                autocapitalization: .words,
                textInput: viewStore.binding(
                    get: \.name,
                    send: { RegisterAction.nameChanged(to: $0) }
                ),
                hideContent: false)
        }
    }
    
    private var skillsField: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            CustomTextField(
                placeHolder: Localization.registerScreenSkills,
                textInput: viewStore.binding(
                    get: \.skills,
                    send: { RegisterAction.skillsChanged(to: $0) }
                ),
                hideContent: false)
        }
    }
    
    private var signUpButton: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            CustomButton(title: Localization.registerScreenSignUp)
                .disabled(!viewStore.isFilled)
                .opacity(viewStore.isFilled ? 1 : 0.5)
                .padding(.vertical)
                .onTapGesture {
                    if viewStore.isFilled {
                        FirebaseClient.createUser(using: viewStore)
                    }
                }
        }
    }
    
    
}

struct RegisterScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegisterScreen(store: Store(initialState: RegisterState(), reducer: RegisterReducer()))
    }
}
