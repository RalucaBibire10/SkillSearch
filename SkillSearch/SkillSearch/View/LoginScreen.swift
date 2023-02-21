import SwiftUI
import ComposableArchitecture
import FirebaseAuth

struct LoginScreen: View {
    var store: StoreOf<LoginReducer>
    
    init(store: StoreOf<LoginReducer>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: .Spacing.small) {
                
                welcomeMessage
                
                emailField
                
                passwordField
                
                forgotPasswordButton
                
                if !viewStore.error.isEmpty {
                    Text(viewStore.error)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
                logInButton
                
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
        Text(Localization.loginScreenWelcome)
            .font(.system(.title, weight: .bold))
            .frame(maxWidth: .infinity,
                   alignment: .leading)
            .padding(.vertical)
    }
    
    private var emailField: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            CustomTextField(
                placeHolder: Localization.loginScreenEmail,
                textInput: viewStore.binding(
                    get: \.email,
                    send: { LoginAction.emailChanged(to: $0) }
                ),
                hideContent: false)
        }
    }
    
    private var passwordField: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            CustomTextField(
                placeHolder: Localization.loginScreenPassword,
                isPassword: true,
                textInput: viewStore.binding(
                    get: \.password,
                    send: { LoginAction.passwordChanged(to: $0) }
                ),
                hideContent: true)
        }
    }
    
    private var forgotPasswordButton: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text(Localization.loginScreenForgotPassword)
                .foregroundColor(.appGreen)
                .font(.system(.body, weight: .bold))
                .padding(.vertical, .Padding.xxxSmall)
                .onTapGesture {
                    viewStore.send(.goToResetPasswordScreen)
                }
        }
    }
    
    private var logInButton: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            CustomButton(title: Localization.loginScreenSignIn)
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
struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen(store: Store(initialState: LoginState(), reducer: LoginReducer()))
    }
}
