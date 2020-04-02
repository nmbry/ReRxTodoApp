//
//  ViewController.swift
//  ReRxTodoApp
//
//  Created by 南部竜太郎 on 2020/04/02.
//  Copyright © 2020 nmbry. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class ViewController: UIViewController {

    // MARK: UI部品
    @IBOutlet weak var showTodoDialog: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    private let viewModel = ViewModel()
    private var disposeBag: DisposeBag?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        disposeBag = DisposeBag()
        bindInputFromViewStream()
        bindOutputToViewStream()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        disposeBag = nil
    }
    
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
}

