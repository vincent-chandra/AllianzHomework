//
//  Presenter.swift
//  AllianzHomework
//
//  Created by Vincent on 20/09/22.
//

import Foundation

protocol PresenterProtocol {
  func didFinishGettingDataFromPresenter(data: Any)
}

class Presenter: InteractorProtocol {
    
    var interactor: Interactor?
    
    var presenterProtocol: PresenterProtocol?
    
    func didFinishGettingDataFromInteractor(data: Any) {
        presenterProtocol?.didFinishGettingDataFromPresenter(data: data)
    }
}
