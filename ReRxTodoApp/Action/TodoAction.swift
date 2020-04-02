//
//  TodoAction.swift
//  ReRxTodoApp
//
//  Created by 南部竜太郎 on 2020/04/02.
//  Copyright © 2020 nmbry. All rights reserved.
//

import ReSwift

struct TodoActionInput: Action {
    let todo: String
}
struct TodoActionOkCancel: Action {
    let okCancel: OkCancel
}

struct TodoActionDelete: Action {
    let rowIndex: Int
}
