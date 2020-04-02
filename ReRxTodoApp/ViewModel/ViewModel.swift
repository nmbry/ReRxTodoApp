//
//  ViewModel.swift
//  ReRxTodoApp
//
//  Created by 南部竜太郎 on 2020/04/02.
//  Copyright © 2020 nmbry. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ReSwift

class ViewModel {
    // MARK: Input Streams
    let showTodoDialogTapped = PublishRelay<String>()
    let inputTodoDialogTextField = PublishRelay<String>()
    let dialogOkCancelBtnTapped = PublishRelay<OkCancel>()
    let cellDeleteBtnTapped = PublishRelay<Int>()
    
    // MARK: Output Streams
    private let todoListOutputStream = PublishRelay<[String]>()
    var todoListOutput: Signal<[String]> {
        return self.todoListOutputStream.asSignal()
    }

    private var disposeBag: DisposeBag?
    
    init() {
        mainStore.subscribe(self)
        disposeBag = DisposeBag()
        bindInputFromViewControllerStream()
    }
    
    deinit {
        mainStore.unsubscribe(self)
        disposeBag = nil
    }

    private func bindInputFromViewControllerStream() {
        // MARK: ダイアログのTextFieldに入力時の処理
        self.inputTodoDialogTextField
            .subscribe(onNext: { text in
                mainStore.dispatch(TodoActionInput(todo: text))
            }).disposed(by: disposeBag!)
        
        // MARK: ダイアログのOKボタンまたはCANCELボタン押下時の処理
        self.dialogOkCancelBtnTapped
            .subscribe(onNext: { okCancel in
                mainStore.dispatch(TodoActionOkCancel(okCancel: okCancel))
            }).disposed(by: disposeBag!)

        // MARK: Deleteボタン押下時の処理
        self.cellDeleteBtnTapped
            .subscribe(onNext: { rowIndex in
                mainStore.dispatch(TodoActionDelete(rowIndex: rowIndex))
            }).disposed(by: disposeBag!)
    }
}

extension ViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    
    func newState(state: AppState) {
        self.todoListOutputStream.accept(state.todoList)
    }
}

enum OkCancel {
    case ok
    case cancel
}
