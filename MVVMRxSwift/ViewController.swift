//
//  ViewController.swift
//  MVVMRxSwift
//
//  Created by Ahmed Khalaf on 10/01/2022.
//

import UIKit
import Combine

private let reuseId = "reuseId"

class ViewController: UITableViewController {
    
    private let viewModel: ViewModel
    private var cancellables: Set<AnyCancellable> = []
    var count: Int = .zero
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        observeViewModel()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! Cell
        cell.viewModel = .init(
            indexPath: indexPath,
            output: .init(
                title: viewModel.output.title(indexPath: indexPath),
                isSelected: viewModel.output.isSelected(indexPath: indexPath),
                selectionAction: viewModel.input.isSelected
            )
        )
        return cell
    }
    
    private func setUpTableView() {
        tableView.register(Cell.self, forCellReuseIdentifier: reuseId)
    }
    
    private func observeViewModel() {
        viewModel.output.count.sink { [weak self] count in
            self?.count = count
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
}

