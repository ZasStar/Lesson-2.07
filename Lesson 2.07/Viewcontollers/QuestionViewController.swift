//
//  ViewController.swift
//  Lesson 2.07
//
//  Created by Александр Захлыпа on 04.04.2023.
//

import UIKit

final class QuestionViewController: UIViewController {
    
    //    MARK: - IB Outlets
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var questionProgressView: UIProgressView!
    
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleButton: [UIButton]!
    
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var rangedLabels: [UILabel]!
    @IBOutlet var rangedSlider: UISlider!
    
    // MARK: - Private properties
    
    
    
    private let questions = Question.getQuestions()
    private var questionIndex = 0
    private var answersChosen:  [Answer] = []
    private var currentAnswers: [Answer] {
        questions[questionIndex].answers
    }
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        let answerCount = Float(currentAnswers.count - 1)
        rangedSlider.maximumValue = answerCount
        rangedSlider.value = answerCount / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultVC = segue.destination as? ResultViewController else { return }
        resultVC.answerChosen = answersChosen
    }
    
    // MARK: IB Action
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        guard let buttonIndex = singleButton.firstIndex(of: sender) else { return }
        let currentAnswer = currentAnswers[buttonIndex]
        answersChosen.append(currentAnswer)
        nextQuestion()
    }
    
    @IBAction func MultipleAnswerButtonPressed() {
        for (multipSwitch, answer) in zip(multipleSwitches, currentAnswers) {
            if multipSwitch.isOn {
                answersChosen.append(answer)
            }
        }
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let index = lrintf(rangedSlider.value)
        answersChosen.append(currentAnswers[index])
        nextQuestion()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let resultVC = segue.destination as? ResultViewController else { return }
//        resultVC.answersChosen = answersChosen
//    }
}
    
    // MARK: - Private methods
    private extension QuestionViewController {
        func updateUI() {
            // Hide everething
            for stackView in [singleStackView, multipleStackView, rangedStackView] {
                stackView?.isHidden = true
            }
//            Get current question
            let currentQuestion = questions[questionIndex]
            
//            Set current question for question label
            questionLabel.text = currentQuestion.title
            
//            Calculate progress
            let totalProgress = Float(questionIndex) / Float(questions.count)
            
//            Set progress for progress view
            questionProgressView.setProgress(totalProgress, animated: true)
            
//            Set navigation title
            title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
            
//            Show stacks corresponding to question type
            showCurrentAnswer(for: currentQuestion.type)
        }
        
        /// Show stackview wth single answer
        ///
        ///Display a stackview of single answer category
        ///
        /// - Parameter type: Specifies the category of responses
        func showCurrentAnswer(for type: ResponseType) {
            switch type  {
                
            case .single: showSingleStackView(with: currentAnswers)
            case .multiple: showMultipleStackView(with: currentAnswers)
            case .ranged: showRangedStackView(with: currentAnswers)
            }
        }
        
        func showSingleStackView(with answers: [Answer]) {
            singleStackView.isHidden.toggle()
            
            for (button, answer) in zip(singleButton, answers) {
                button.setTitle(answer.title, for: .normal)
            }
                    
        }
        
        func showMultipleStackView(with answers: [Answer]) {
            multipleStackView.isHidden.toggle()
            
            for (label, answer) in zip(multipleLabels, answers) {
                label.text = answer.title
            }
        }
        
        func showRangedStackView(with answer: [Answer]) {
            rangedStackView.isHidden.toggle()
            
            rangedLabels.first?.text = answer.first?.title
            rangedLabels.last?.text = answer.last?.title
        }
        
        func nextQuestion() {
            questionIndex += 1
            
            if questionIndex < questions.count {
                updateUI()
                return
            }
            
            performSegue(withIdentifier: "showResult", sender: nil)
        }
        
    }



