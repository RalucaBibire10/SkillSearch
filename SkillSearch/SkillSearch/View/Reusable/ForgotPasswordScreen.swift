import SwiftUI
import ComposableArchitecture
import FirebaseAuth

struct ForgotPasswordScreen: View {
    
    var store: StoreOf<ResetPasswordReducer>
    
    init(store: StoreOf<ResetPasswordReducer>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe:  { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: .Spacing.small) {
                
                titleMessage
                
                emailField
                
                if !viewStore.message.isEmpty {
                    Text(viewStore.message)
                        .foregroundColor(viewStore.isError ? .red : Color.appGreen)
                        .font(.footnote)
                }
                
                sendEmailButton
                
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
    
    private var titleMessage: some View {
        Text(Localization.loginScreenForgotPassword)
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
                    send: { ResetPasswordAction.emailChanged(to: $0) }
                ),
                hideContent: false)
        }
    }
    
    private var sendEmailButton: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            CustomButton(title: Localization.sendEmail)
                .disabled(!viewStore.isFilled)
                .opacity(viewStore.isFilled ? 1 : 0.5)
                .padding(.vertical)
                .onTapGesture {
                    FirebaseClient.sendResetPasswordEmail(using: viewStore)
                }
        }
    }
}

struct ForgotPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordScreen(store: Store(initialState: ResetPasswordState(), reducer: ResetPasswordReducer()))
    }
}
