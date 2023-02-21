import SwiftUI
import ComposableArchitecture
import FirebaseAuth


struct SplashScreen: View {
    @State var isActive = false
    let store: Store<AppState, AppAction>
    
    init() {
        store = Store(initialState: AppState(), reducer: AppReducer())
    }
    
    let style = StrokeStyle(lineWidth: 6, lineCap: .square)
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack(path: viewStore.binding(get: \.navigationPath, send: { .navigationUpdated(screen: $0.last) })) {
                VStack {
                    if isActive {
                        if viewStore.user != nil {
                            HomeScreen(store: store
                                .scope(state: { $0.homeState },
                                       action: AppAction.homeAction))
                            .onAppear {
                                if !viewStore.isUserSet {
                                    FirebaseClient.fetchProfilePicture(using: viewStore)
                                }
                                FirebaseClient.fetchCurrentUser(using: viewStore)
                            }
                        } else {
                            WelcomeScreen(store: store)
                        }
                    } else {
                        Circle()
                            .trim(from: 0, to: 0.7)
                            .stroke(Color.appGreen,
                                    style: style)
                            .rotationEffect(Angle(degrees: viewStore.animate ? 360 : 0))
                            .frame(width: 40, height: 40)
                            .onAppear {
                                _ = withAnimation(Animation.linear(duration: 0.9).repeatForever(autoreverses: false)) {
                                    viewStore.send(.toggleAnimate)
                                }
                                isActive.toggle()
                            }
                    }
                }
                .navigationDestination(for: Screen.self) { screen in
                    switch screen {
                    case .register:
                        RegisterScreen(store: store
                            .scope(state: { $0.registerState },
                                   action: AppAction.registerAction))
                        
                    case .login:
                        LoginScreen(store: store
                            .scope(state: { $0.loginState },
                                   action: AppAction.loginAction))
                        
                    case .home: HomeScreen(store: store
                        .scope(state: { $0.homeState },
                               action: AppAction.homeAction))
                    .navigationBarBackButtonHidden()
                    .navigationBarItems(leading: EmptyView())
                        
                    case .welcome: WelcomeScreen(store: store)
                        
                    case .forgotPassword:
                        ForgotPasswordScreen(store: store
                            .scope(state: { $0.resetPasswordState },
                                   action: AppAction.resetPasswordAction))
                        
                    case .userDetails:
                        UserDetailsView(store: store
                            .scope(state: { $0.homeState },
                                   action: AppAction.homeAction))
                        .navigationBarBackButtonHidden()
                        .navigationBarItems(leading: EmptyView())
                        
                    case .myProfile:
                        MyProfileScreen(store: store
                            .scope(state: { $0.myProfileState },
                                   action: AppAction.myProfileAction))
                        .navigationBarBackButtonHidden()
                        .navigationBarItems(leading: EmptyView())
                    }
                }
            }
        }
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
