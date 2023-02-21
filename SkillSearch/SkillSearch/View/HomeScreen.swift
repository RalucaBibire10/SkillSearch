import SwiftUI
import FirebaseStorage
import FirebaseAuth
import ComposableArchitecture

struct HomeScreen: View {
    var store: StoreOf<HomeReducer>
    
    init(store: StoreOf<HomeReducer>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                topBar
                searchBar
                peopleList
                Spacer()
            }
            .onAppear {
                viewStore.send(.setCurrentUser)
                FirebaseClient.fetchUsers(using: viewStore)
            }
            .padding(.horizontal, .Padding.medium)
        }
    }
    
    
    
    private var topBar: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
                RoundImage(imageData:
                            viewStore.binding(get:  \.imageData,
                                              send: { .none }()))
                .onTapGesture {
                    viewStore.send(.goToUserProfile)
                }
                
                Spacer()
                logOutButton
            }
        }
    }
    
    private var searchBar: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
                Image.search
                TextField(String.empty,
                          text: viewStore.binding(get: \.filterText,
                                                  send: { .filterTextChanged(to: $0) })
                )
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .placeholder(when: viewStore.filterText.isEmpty) {
                    Text(Localization.searchBarPlaceHolder)
                }
            }
            .foregroundColor(.darkGray)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: .CornerRadius.large)
                    .fill(Color.lightGray)
            )
            .padding(.vertical, .Padding.medium)
        }
    }
    
    private var peopleList: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                ForEach(viewStore.filteredUsers, id: \.self) { user in
                    HStack(spacing: .Spacing.small) {
                        RoundImage(imageData:
                                    viewStore.binding(get:  \.usersImageData[user.uid],
                                                      send: { .none }()))
                        
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .fontWeight(.semibold)
                            Text(user.skills.joined(separator: ", "))
                                .foregroundColor(.darkGray)
                        }
                        Spacer()
                        
                        Image.forwardArrow
                            .foregroundColor(.darkGray)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewStore.send(.selectUser(user: user,
                                                   data: viewStore.usersImageData[user.uid] ?? Data()))
                    }
                    .padding(.bottom, .Padding.xxSmall)
                }
            }
        }
    }
    
    private var logOutButton: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Image.logOut
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: .Size.xxSmall)
                .onTapGesture {
                    viewStore.send(.showAlert(true))
                }
                .alert(isPresented: viewStore.binding(get: \.showAlert, send: { .showAlert($0)} )) {
                    Alert(title: Text(Localization.alertTitle),
                          message: Text(Localization.alertMessage),
                          primaryButton: .destructive(Text(Localization.alertButton)) {
                        viewStore.send(.logOut)
                    },
                          secondaryButton: .cancel() {
                        viewStore.send(.showAlert(false))
                    })
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(store: Store(initialState: HomeState(), reducer: HomeReducer()))
    }
}
