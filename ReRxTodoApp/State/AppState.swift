//
//  AppState.swift
//  ReRxTodoApp
//
//  Created by 南部竜太郎 on 2020/04/02.
//  Copyright © 2020 nmbry. All rights reserved.
//

import ReSwift

struct AppState: StateType {
    var todoList = [String]()
    var todo = String()
    var ok = false
    var cancel = false
}
