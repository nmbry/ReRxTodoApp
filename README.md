## ポイント

### AppDelegate.swift
~~~swift
import UIKit
import ReSwift

let mainStore = {
    return Store<AppState> (
        reducer: todoInputReducer,
        state: AppState(),// <--- `nil`にするとデータが保持されないので注意
        middleware:[
            LoggerMiddleware().myLogger() // Middlewareを定義
        ]
    )
}() // <--- ()をつけないと呼び出す側で`mainStore().dispatch(...)`となる
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
~~~

---

### ViewController.swift
~~~swift
    private func bindInputFromViewStream() {
        // MARK: 「＋」ボタン
        self.showTodoDialog.rx.tap
            .subscribe({ _ in
                self.showDialog()
            }).disposed(by: self.disposeBag!)
        
        // MARK: Deleteボタン
        self.tableView.rx.itemDeleted
            .subscribe({ event in
                self.viewModel.cellDeleteBtnTapped.accept(event.element!.row)
            }).disposed(by: self.disposeBag!)
        
    }
    
    private func bindOutputToViewStream() {
        // 以下はSignal-emitでは解決できなかったので、Observableに変換してbindしないといけない
        // MARK: TableViewに反映させる
        self.viewModel.todoListOutput.asObservable()
            .bind(to: self.tableView.rx.items(cellIdentifier: "cell")) { row, element, cell in
                cell.textLabel?.text = element
            }.disposed(by: disposeBag!)
    }

    /// 以下、ダイアログを生成するメソッドである
    ///
    /// - TextField
    /// - OKボタン
    /// - CANCELボタン
    private func showDialog() {
        let alert = UIAlertController(title: "Todo追加", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.viewModel.dialogOkCancelBtnTapped.accept(.ok)
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { _ in
            self.viewModel.dialogOkCancelBtnTapped.accept(.cancel)
        }))
        alert.addTextField(configurationHandler: { textField in
            textField.rx.text
                .filter {$0 != nil}
                .map {$0!}
                .subscribe(onNext: { text in
                    self.viewModel.inputTodoDialogTextField.accept(text)
                }).disposed(by: self.disposeBag!)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
~~~

### ViewModel.swift
~~~swift
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

        // 以下を定義するだけで、Deleteができるようになる
        // MARK: Deleteボタン押下時の処理
        self.cellDeleteBtnTapped
            .subscribe(onNext: { rowIndex in
                mainStore.dispatch(TodoActionDelete(rowIndex: rowIndex))
            }).disposed(by: disposeBag!)
    }
~~~

### ss
~~~swift
~~~

