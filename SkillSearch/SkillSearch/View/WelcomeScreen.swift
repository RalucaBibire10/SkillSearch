import SwiftUI
import ComposableArchitecture
import NavigationBackport

struct WelcomeScreen: View {
    private let store: StoreOf<AppReducer>
    
    public init(store: StoreOf<AppReducer>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    Spacer()
                    logoImage
                }
                Spacer()
                VStack(alignment: .leading) {
                    titleText
                    subtitleText
                    
                    registerButton
                    
                    loginButton
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .bottomLeading
                )
            }
            .padding()
        }
    }
    
    private var logoImage: some View {
        Image(Image.logo)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: .Size.xLarge, height: .Size.small)
            .padding(.top, .Padding.xSmall)
            .padding(.trailing, .Padding.large)
    }
    
    private var titleText: some View {
        Text(Localization.welcomeScreenSkillSearch)
            .font(.system(.title, weight: .semibold))
            .padding(.bottom)
    }
    
    private var subtitleText: some View {
        Text(Localization.welcomeScreenLoremIpsum)
            .font(.system(.title2, weight: .light))
            .foregroundColor(.secondary)
            .padding(.bottom, .Padding.xxLarge)
    }
    
    private var registerButton: some View {
        WithViewStore(store, observe:  { $0 }) { viewStore in
            CustomButton(title: Localization.welcomeScreenGetStarted)
                .padding(.bottom)
                .onTapGesture {
                    viewStore.send(.navigationUpdated(screen: Screen.register))
                }
        }
    }
    
    private var loginButton: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text(Localization.welcomeScreenHaveAccount)
                .frame(maxWidth: .infinity)
                .foregroundColor(.appGreen)
                .font(.system(.title3, weight: .semibold))
                .padding(.top)
                .onTapGesture {
                    viewStore.send(.navigationUpdated(screen: .login))
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen(store: Store(initialState: AppState(), reducer: AppReducer()))
    }
}
