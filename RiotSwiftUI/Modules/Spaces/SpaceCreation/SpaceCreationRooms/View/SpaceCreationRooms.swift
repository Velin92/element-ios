// File created from SimpleUserProfileExample
// $ createScreen.sh Spaces/SpaceCreation/SpaceCreationRooms SpaceCreationRooms
// 
// Copyright 2021 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI

@available(iOS 14.0, *)
struct SpaceCreationRooms: View {

    // MARK: - Properties
    
    // MARK: Private
    
    @Environment(\.theme) private var theme: ThemeSwiftUI
    
    // MARK: Public
    
    @ObservedObject var viewModel: SpaceCreationRoomsViewModel.Context
    
    var body: some View {
        VStack {
            ThemableNavigationBar(title: nil, showBackButton: true) {
                viewModel.send(viewAction: .back)
            } closeAction: {
                viewModel.send(viewAction: .cancel)
            }
            mainView
        }
        .background(theme.colors.background)
        .navigationBarHidden(true)
    }
    
    // MARK: - Private
    
    @ViewBuilder
    private var mainView: some View {
        VStack {
            GeometryReader { reader in
                ScrollView {
                    ScrollViewReader { scrollViewReader in
                        VStack(spacing: 20) {
                            Text(VectorL10n.spacesCreationNewRoomsTitle)
                                .multilineTextAlignment(.center)
                                .font(theme.fonts.title3SB)
                                .foregroundColor(theme.colors.primaryContent)
                            Text(VectorL10n.spacesCreationNewRoomsMessage)
                                .multilineTextAlignment(.center)
                                .font(theme.fonts.body)
                                .foregroundColor(theme.colors.secondaryContent)
                            Spacer()
                            ForEach(viewModel.rooms.indices) { index in
                                RoundedBorderTextField(title: VectorL10n.spacesCreationNewRoomsRoomNameTitle, placeHolder: viewModel.rooms[index].defaultName, text: $viewModel.rooms[index].name, footerText: .constant(nil), isError: .constant(false), configuration: UIKitTextInputConfiguration( returnKeyType: index < viewModel.rooms.endIndex - 1 ? .next : .done), onEditingChanged: { editing in
                                    if editing {
//                                        scrollViewReader.scrollTo("roomTextField\(viewModel.rooms.count-1)", anchor: .bottom)
                                    }
                                })
                                    .accessibility(identifier: "roomTextField")
                                    .id("roomTextField\(index)")
                            }
                        }
                        .padding(.horizontal, 2)
                        .padding(.bottom)
                        .frame(minHeight: reader.size.height - 2)
                    }
                }
            }
            ThemableButton(icon: nil, title: VectorL10n.next) {
                ResponderManager.resignFirstResponder()
                viewModel.send(viewAction: .done)
            }
        }
        .padding(EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16))
    }
}

// MARK: - Previews

@available(iOS 14.0, *)
struct SpaceCreationRooms_Previews: PreviewProvider {
    static let stateRenderer = MockSpaceCreationRoomsScreenState.stateRenderer
    static var previews: some View {
        stateRenderer.screenGroup(addNavigation: true).theme(.light).preferredColorScheme(.light)
        stateRenderer.screenGroup(addNavigation: true).theme(.dark).preferredColorScheme(.dark)
    }
}
