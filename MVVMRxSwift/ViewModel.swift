//
//  ViewModel.swift
//  MVVMRxSwift
//
//  Created by Ahmed Khalaf on 10/01/2022.
//

import Combine
import Foundation

private let defaultSelectedState = false

class ViewModel {
    class Output {
        var count: AnyPublisher<Int, Never> {
            _count.eraseToAnyPublisher()
        }
        
        func title(indexPath: IndexPath) -> AnyPublisher<String, Never> {
            title[indexPath, default: .init("")].eraseToAnyPublisher()
        }
        
        func isSelected(indexPath: IndexPath) -> AnyPublisher<Bool, Never> {
            if let subject = isSelected[indexPath] {
                return subject.eraseToAnyPublisher()
            } else {
                isSelected[indexPath] = .init(defaultSelectedState)
                return isSelected(indexPath: indexPath)
            }
        }
        
        fileprivate var _count: CurrentValueSubject<Int, Never> = .init(0)
        fileprivate var title: [IndexPath : CurrentValueSubject<String, Never>] = [:]
        fileprivate var isSelected: [IndexPath : CurrentValueSubject<Bool, Never>] = [:]
    }
    
    class Input {
        var isSelected: PassthroughSubject<IndexPath, Never> = .init()
    }
    
    let output: Output = .init()
    let input: Input = .init()
    private let data: [String] = [
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
        UUID().uuidString,
    ]
    private var cancelables: Set<AnyCancellable> = []
    
    init() {
        setUpOutputs()
        observeInput()
    }
    
    private func setUpOutputs() {
        output._count.send(data.count)
        data.enumerated().forEach { row, string in
            self.output.title[.init(row: row, section: .zero)] = .init(string)
        }
    }
    
    private func observeInput() {
        input.isSelected
            .compactMap({ $0 })
            .sink { [weak self] indexPath in
                guard let self = self else { return }
                let isCurrentlySelected = self.output.isSelected[indexPath]?.value ?? defaultSelectedState
                self.output.isSelected[indexPath]?.send(!isCurrentlySelected)
            }.store(in: &cancelables)
    }
    
}
