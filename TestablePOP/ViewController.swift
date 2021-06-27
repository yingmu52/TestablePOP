//
//  ViewController.swift
//  TestablePOP
//
//  Created by Xinyi Zhuang on 2021-06-27.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }
    }
    
    private(set) var items: [Item] = []
    private var service: ServiceProtocol = Service()
    
    static func makeInstance(with service: ServiceProtocol) -> ViewController? {
        let bundle = Bundle(for: ViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let viewController = storyboard.instantiateInitialViewController() as? ViewController
        viewController?.service = service
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        service.fetchItems { result in
            switch result {
            case .success(let items):
                self.items = items
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("error fetching items: \(error)")
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") else {
            return UITableViewCell()
        }
        
        let item = self.items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.completed ? "Completed" : "Not completed"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
