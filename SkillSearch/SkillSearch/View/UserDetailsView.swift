import SwiftUI
import ComposableArchitecture

struct UserDetailsView: View {
    var store: StoreOf<HomeReducer>
    
    init(store: StoreOf<HomeReducer>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            if let user = viewStore.selectedUser {
                VStack(spacing: .Spacing.large) {
                    RoundImage(imageData: viewStore.binding(get: \.selectedUserImageData,
                                                            send: .none),
                               size: .Size.medium)
                    Text(user.name)
                        .font(.title2)
                    
                    Text(user.email)
                        .foregroundColor(.black)
                        .font(.title3)
                    
                    Text(user.skills.joined(separator: ", "))
                        .foregroundColor(.appGreen)
                        .font(.title3)
                    
                    Spacer()
                }
                .fontWeight(.medium)
                .padding(.top, .Padding.xLarge)
                .navigationBarItems(leading: BackButton()
                    .onTapGesture {
                        viewStore.send(.navigateBack)
                    })
            }
        }
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView(store: Store(initialState: HomeState(), reducer: HomeReducer()))
    }
}
