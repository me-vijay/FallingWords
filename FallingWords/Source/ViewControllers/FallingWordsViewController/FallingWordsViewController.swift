//
//  ViewController.swift
//  FallingWords
//
//  Created by Vijay Kumar on 27/06/2019.
//  Copyright © 2019 Vijay. All rights reserved.
//

import UIKit

class FallingWordsViewController: UIViewController {
    // IBOutlets
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var lifelinesLabel: UILabel!
    @IBOutlet weak var translationLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    var viewModel: FallingWordsViewModelProtocol?
    var timer: Timer? = nil
    var leapSize: CGFloat = 0.0
    var counter = 10 {
        didSet {
            // if counter below zero, no point of moving translation further down
            if counter < 0 {
                // stop timer
                timer?.invalidate()
                
                // hide translation
                translationLabel.isHidden = true
                
                // notify view model
                viewModel?.wordReachedBottom()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel == nil {
            do {
                viewModel = try FallingWordsViewModel()
            } catch  {
                let errorAlert = UIAlertController(title: "An Error Occurred While Starting Game", message: "Please try later", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                errorAlert.addAction(okAction)
                
                present(errorAlert, animated: true, completion: nil)
            }
        }
        // bind code blocks
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set view initial state
        setInitialViewState()
        
        // start game
        viewModel?.start()
    }
    
    func setInitialViewState() {
        // set score to zero
        scoreLabel.text = "0"
        
        // set lifeline count
        lifelinesLabel.text = String(viewModel?.lifelines ?? 0)
        
        // set countdown
        counterLabel.text = String(counter)
        
        // set translation
        translationLabel.numberOfLines = 0
    }

    func bindViewModel() {
        viewModel?.showWordTranslation = { [weak self] (word, translation) in
            self?.showWord(word)
            self?.showTranslation(translation)
        }
        
        viewModel?.onScoreChange = { [weak self] (score) in
            self?.scoreLabel.text = String(score)
        }
        
        viewModel?.onLifelinesChange = { [weak self] (lifelines) in
            self?.lifelinesLabel.text = String(lifelines)
        }
        
        viewModel?.onGameOver = { [weak self] in  self?.setGameOverView() }
        
        viewModel?.onGameCompletion = { [weak self] in self?.setGameCompletionView() }
    }
    
    func showWord(_ word: String) {
        // set word
        wordLabel.text = word
    }
    
    func showTranslation(_ translation: String) {
        // reset translation
        resetTranslation(text: translation)
        
        // reset view for new translation
        setupForNewTranslation()
        
        // start timer to move down translation
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
    }
    
    func setGameCompletionView() {
        setViewForFinishedGame()
        
        // show game completion alert
        let message = (scoreLabel.text != nil) ? "You Scored: \(scoreLabel.text!)" : nil
        let gameOverAlert = UIAlertController(title: "Congratulations!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        gameOverAlert.addAction(okAction)
        
        present(gameOverAlert, animated: true, completion: nil)
    }
    
    func setGameOverView() {
        setViewForFinishedGame()
        
        // set game over in red in word label
        wordLabel.text = "Game Over"
        wordLabel.textColor = UIColor.red
        
        // show game over alert
        let message = (scoreLabel.text != nil) ? "You Scored: \(scoreLabel.text!)" : nil
        let gameOverAlert = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        gameOverAlert.addAction(okAction)
        
        present(gameOverAlert, animated: true, completion: nil)
    }

    // MARK: - Private Methods
    private func setupForNewTranslation() {
        // reset timer
        timer?.invalidate()
        
        // reset counter
        counter = 10
        counterLabel.text = String(counter)
    }
    
    private func  resetTranslation(text: String) {
        // set translation
        translationLabel.text = text
        translationLabel.sizeToFit()

        // reset translation to view top
        var frame = translationLabel.frame
        let viewCenterX = view.center.x
        frame.origin.x = viewCenterX
        frame.origin.y = -(frame.size.height)
        frame.size.width = viewCenterX
        translationLabel.frame = frame
        
        // calculate new leap size of translation
        calculateLeapSize()
        
        translationLabel.isHidden = false
    }
    
    private func calculateLeapSize() {
        // get view height after removing translation label height
        let viewHeight = view.frame.size.height - translationLabel.frame.size.height
        
        // size of one leap in 10
        leapSize = viewHeight/10.0
    }
    
    private func setViewForFinishedGame() {
        // hide translation
        translationLabel.isHidden = true
        
        // stop timer
        timer?.invalidate()
        
        // set counter to zero
        counter = 0
        counterLabel.text = String(counter)
    }

    // MARK: - Event Methods
    
    @objc func onTimer() {
        // set counter value
        counterLabel.text = String(counter)
        
        // update translation frame
        let frame = translationLabel.frame
        translationLabel.frame = CGRect(x: frame.origin.x, y: frame.origin.y + leapSize, width: frame.size.width, height: frame.size.height)
        
        // decrement counter
        // when counter goes below zero, didSet will notify viewmodel for new word
        counter = counter - 1
    }
    
    @IBAction func noButtonTapped(_ sender: Any) {
        viewModel?.userAnswered(as: false)
    }
    
    @IBAction func yesButtonTapped(_ sender: Any) {
        viewModel?.userAnswered(as: true)
    }
}

