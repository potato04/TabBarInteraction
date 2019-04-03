//
//  FirstViewController.swift
//  TabBarInteraction
//
//  Created by potato04 on 2019/3/27.
//  Copyright © 2019 potato04. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, TabbarInteractable {

    private var wheelView: WheelView!
    
    @IBOutlet weak var tableView: UITableView!
    let data = Array(1...100).map { "\($0)" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.rowHeight = 44

        wheelView = WheelView(frame: CGRect.zero)
        wheelView.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        wheelView.borderWidth = 1
        wheelView.backgroundColor = UIColor.white
        wheelView.contents = data

        replaceSwappableImageViews(with: wheelView, and: CGSize(width: 25, height: 25))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollViewDidScroll(self.tableView)
        wheelView.tintColor = view.tintColor
    }
    override func viewDidDisappear(_ animated: Bool) {
        wheelView.tintColor = UIColor.gray
    }
}

// MARK: UITableViewDataSource
extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")
        cell?.textLabel?.text = data[indexPath.row]
        return cell!
    }
}

// MARK: UITableViewDelegate
extension FirstViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // progress 怎么计算取决于你需求，这里的是为了把`tableview`当前可见区域最底部的2个数字给显示出来。
        let progress = Float((scrollView.contentOffset.y + tableView.bounds.height - tableView.rowHeight) / scrollView.contentSize.height)
        wheelView.progress = progress
    }
}
