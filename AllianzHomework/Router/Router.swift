//
//  Router.swift
//  AllianzHomework
//
//  Created by Vincent on 20/09/22.
//

import Foundation
import UIKit

class Router {
    
    class func showView() -> ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let presenter = setUpPresenter(forViewController: vc)
        setUpInteractor(forPresenter: presenter)
        vc.presenter = presenter
        return vc
    }
    
    private class func setUpPresenter(forViewController vc : ViewController) -> Presenter{
        let presenter = Presenter()
        presenter.presenterProtocol = vc
        return presenter
      }
      
      private class func setUpInteractor(forPresenter presenter : Presenter){
        let interactor = Interactor()
        interactor.interactorProtocol = presenter
        presenter.interactor = interactor
      }
}
