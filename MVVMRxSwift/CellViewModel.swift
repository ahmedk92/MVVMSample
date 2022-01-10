//
//  CellViewModel.swift
//  MVVMRxSwift
//
//  Created by Ahmed Khalaf on 10/01/2022.
//

import Combine
import Foundation

class CellViewModel {
    class Output {
        let title: AnyPublisher<String, Never>
        let isSelected: AnyPublisher<Bool, Never>
        let selectionAction: PassthroughSubject<IndexPath, Never>
        
        init(
            title: AnyPublisher<String, Never>,
            isSelected: AnyPublisher<Bool, Never>,
            selectionAction: PassthroughSubject<IndexPath, Never>
        ) {
            self.title = title
            self.isSelected = isSelected
            self.selectionAction = selectionAction
        }
    }
    
    class Input {
        var isSelected: PassthroughSubject<Void, Never> = .init()
    }
    
    let indexPath: IndexPath
    let output: Output
    let input: Input = .init()
    private var cancellables: Set<AnyCancellable> = []
    
    init(indexPath: IndexPath, output: CellViewModel.Output) {
        self.indexPath = indexPath
        self.output = output
        
        observeInput()
    }
    
    private func observeInput() {
        input.isSelected.sink { [weak self] in
            guard let self = self else { return }
            self.output.selectionAction.send(self.indexPath)
        }.store(in: &cancellables)
    }
}
