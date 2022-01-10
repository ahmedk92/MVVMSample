//
//  Cell.swift
//  MVVMRxSwift
//
//  Created by Ahmed Khalaf on 10/01/2022.
//

import UIKit
import Combine

class Cell: UITableViewCell {
    var viewModel: CellViewModel! {
        didSet {
            observeViewModel()
        }
    }
    private var cancellables: Set<AnyCancellable> = []
    private var titleLabel: UILabel!
    private var isSelectedButton: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        titleLabel = .init()
        contentView.addSubview(titleLabel)
        
        isSelectedButton = .init()
        isSelectedButton.addTarget(self, action: #selector(isSelectedButtonTapped), for: .touchUpInside)
        contentView.addSubview(isSelectedButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        isSelectedButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            isSelectedButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            isSelectedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            isSelectedButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
    
    private func observeViewModel() {
        cancellables.forEach {
            $0.cancel()
        }
        viewModel.output.title.sink { [weak self] title in
            self?.titleLabel.text = title
        }.store(in: &cancellables)
        
        viewModel.output.isSelected.sink { [weak self] isSelected in
            self?.isSelectedButton.backgroundColor = isSelected ? .green : .red
        }.store(in: &cancellables)
    }
    
    @objc private func isSelectedButtonTapped() {
        viewModel.input.isSelected.send(())
    }
}
