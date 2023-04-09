//
//  ResultViewController.swift
//  Lesson 2.07
//
//  Created by Александр Захлыпа on 08.04.2023.
//

import UIKit

final class ResultViewController: UIViewController {
    
    
    @IBOutlet var resultPicteredAnimalLabel: UILabel!
    
    @IBOutlet var resultAnimalWrittenLabel: UILabel!
    
    var answerChosen: [Answer]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        renewResults()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    deinit {
        print("\(type(of: self)) has been deal located")
    }
    
}

private extension ResultViewController {
    func renewResults() {
        var animalQuantity: [Animal: Int] = [:]
        let animals = answerChosen.map { $0.animal }
        
        for animal in animals {
            animalQuantity[animal, default: 0] += 1
        }
        let sortedAnimals = animalQuantity.sorted { $0.value > $1.value }
        guard let moreChosenAnimal = sortedAnimals.first?.key else { return }
        updateUI(with: moreChosenAnimal)
    }
    func updateUI(with animal: Animal) {
        resultPicteredAnimalLabel.text = "Вы - \(animal.rawValue)!"
        resultAnimalWrittenLabel.text = animal.definition
    }
    
}


