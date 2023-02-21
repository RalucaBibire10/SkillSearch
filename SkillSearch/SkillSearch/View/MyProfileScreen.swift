import SwiftUI
import ComposableArchitecture
import PhotosUI

struct MyProfileScreen: View {
    var store: StoreOf<MyProfileReducer>
    
    init(store: StoreOf<MyProfileReducer>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: .Spacing.medium) {
                photoPicker
                
                nameField
                skillsField
                    .padding(.bottom, .Padding.small)
                
                saveButton
                logOutButton
                
                Spacer()
            }
            .padding(.top, .Padding.xLarge)
            .padding(.horizontal, .Padding.xSmall)
            .navigationBarItems(leading: BackButton()
                .onTapGesture {
                    viewStore.send(.navigateBack)
                })
        }
    }
    
    private var photoPicker: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            PhotosPicker(
                selection: viewStore.binding(
                    get: \.image,
                    send: { MyProfileAction.imageChanged(to: $0) }),
                matching: .images,
                photoLibrary: .shared()
            ) {
                RoundImage(imageData: viewStore.binding(get: \.imageData,
                                                        send: .none),
                           size: .Size.medium)
                .padding(.bottom, .Padding.xLarge)
            }
            .onChange(of: viewStore.image) { newImage in
                viewStore.send(.onImageChange)
            }
        }
    }
    
    private var nameField: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            CustomTextField(
                placeHolder: Localization.registerScreenFullName,
                autocapitalization: .words,
                textInput: viewStore.binding(
                    get: \.name,
                    send: { MyProfileAction.nameChanged(to: $0) }
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
                    send: { MyProfileAction.skillsChanged(to: $0) }
                ),
                hideContent: false)
        }
    }
    
    private var saveButton: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            CustomButton(title: Localization.myProfileScreenSave)
                .onTapGesture {
                    FirebaseClient.updateUser(using: viewStore)
                }
        }
    }
    
    private var logOutButton: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            CustomButton(title: Localization.myProfileScreenLogOut, color: .darkRed)
                .onTapGesture {
                    viewStore.send(.logOut)
                }
        }
    }
}

struct MyProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileScreen(store: Store(initialState: MyProfileState(), reducer: MyProfileReducer()))
    }
}
