//
//  MyTableViewController.swift
//  SwiftyTableViewController
//
//  Created by 平松　亮介 on 2016/03/03.
//  Copyright © 2016年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit

//: Playground - noun: a place where people can play

import UIKit

struct Person {
    let name: String
    let city: String
    init(name: String, city: String) {
        self.name = name
        self.city = city
    }
}

let people = [Person(name: "Hxu", city: "China"),
    Person(name: "Kenji", city: "Tokyo"),
    Person(name: "Yuki", city: "Paris")]

struct UndoHistory<Item> {
    let initialValue: [Item]
    var history: [[Item]] = []
    
    init (_ initialValue: [Item]) {
        self.initialValue = initialValue
    }
    
    var currentValue: [Item] {
        get { return history.last ?? initialValue }
        set { history.append(newValue) }
    }
    
    var canUndo: Bool {
        return !history.isEmpty
    }
    
    mutating func undo() {
        history.popLast()
    }
}

struct TableViewConfiguration<Item> {
    let items: [Item]
    let style: UITableViewStyle
    let cellStyle: UITableViewCellStyle
    let editable: Bool
    let configureCell: (UITableViewCell, Item) -> ()
    
    init(items: [Item], style: UITableViewStyle, cellStyle: UITableViewCellStyle, editable: Bool, configureCell: (UITableViewCell, Item) -> ()) {
        self.items = items
        self.style = style
        self.cellStyle = cellStyle
        self.editable = editable
        self.configureCell = configureCell
    }
}

final class MyTableViewController<Item>: UITableViewController {
    var history: UndoHistory<Item> {
        didSet {
            tableView.reloadData()
            navigationItem.rightBarButtonItem = history.canUndo ? UIBarButtonItem(title: "Undo", style: .Plain, target: self, action: "undo:") : nil
        }
    }
    var items: [Item] {
        get { return history.currentValue }
        set { history.currentValue = newValue }
    }
    let cellStyle: UITableViewCellStyle
    let configureCell: (cell: UITableViewCell, item: Item) -> ()
    
    init(configuration: TableViewConfiguration<Item>) {
        self.history = UndoHistory<Item>(configuration.items)
        self.cellStyle = configuration.cellStyle
        self.configureCell = configuration.configureCell
        super.init(style: configuration.style)
        
        if configuration.editable {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit",
                style: .Plain,
                target: self,
                action: "edit:")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func edit(sender: AnyObject) {
        self.tableView.editing = !self.tableView.editing
    }
    
    func undo(sender: AnyObject) {
        history.undo()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: cellStyle, reuseIdentifier: nil)
        configureCell(cell: cell, item: items[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        guard editingStyle == .Delete else { return }
        
        items.removeAtIndex(indexPath.row)
    }
}

