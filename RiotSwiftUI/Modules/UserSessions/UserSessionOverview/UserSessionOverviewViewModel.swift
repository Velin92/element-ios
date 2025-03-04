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

typealias UserSessionOverviewViewModelType = StateStoreViewModel<UserSessionOverviewViewState, UserSessionOverviewViewAction>

class UserSessionOverviewViewModel: UserSessionOverviewViewModelType, UserSessionOverviewViewModelProtocol {
    private let sessionInfo: UserSessionInfo
    private let service: UserSessionOverviewServiceProtocol
    
    var completion: ((UserSessionOverviewViewModelResult) -> Void)?
    
    // MARK: - Setup
    
    init(sessionInfo: UserSessionInfo, service: UserSessionOverviewServiceProtocol) {
        self.sessionInfo = sessionInfo
        self.service = service
        
        let cardViewData = UserSessionCardViewData(sessionInfo: sessionInfo)
        let state = UserSessionOverviewViewState(cardViewData: cardViewData,
                                                 isCurrentSession: sessionInfo.isCurrent,
                                                 isPusherEnabled: service.pusherEnabledSubject.value,
                                                 remotelyTogglingPushersAvailable: service.remotelyTogglingPushersAvailableSubject.value,
                                                 showLoadingIndicator: false)
        super.init(initialViewState: state)
        
        startObservingService()
    }
    
    private func startObservingService() {
        service
            .pusherEnabledSubject
            .sink(receiveValue: { [weak self] pushEnabled in
                self?.state.showLoadingIndicator = false
                self?.state.isPusherEnabled = pushEnabled
            })
            .store(in: &cancellables)
        
        service
            .remotelyTogglingPushersAvailableSubject
            .sink(receiveValue: { [weak self] remotelyTogglingPushersAvailable in
                self?.state.remotelyTogglingPushersAvailable = remotelyTogglingPushersAvailable
            })
            .store(in: &cancellables)
    }

    // MARK: - Public
    
    override func process(viewAction: UserSessionOverviewViewAction) {
        switch viewAction {
        case .verifyCurrentSession:
            completion?(.verifyCurrentSession)
        case .viewSessionDetails:
            completion?(.showSessionDetails(sessionInfo: sessionInfo))
        case .togglePushNotifications:
            self.state.showLoadingIndicator = true
            service.togglePushNotifications()
        case .renameSession:
            completion?(.renameSession(sessionInfo))
        case .logoutOfSession:
            completion?(.logoutOfSession(sessionInfo))
        }
    }
}
