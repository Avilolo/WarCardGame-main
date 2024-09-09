import UIKit

class ViewController: UIViewController {
    
    // UI elements
    @IBOutlet weak var player1ScoreLabel: UILabel!
    @IBOutlet weak var player2ScoreLabel: UILabel!
    @IBOutlet weak var player1CardImageView: UIImageView!
    @IBOutlet weak var player2CardImageView: UIImageView!
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var winnerScoreLabel: UILabel!

    @IBOutlet weak var backToMenuButton: UIButton!
    

    @IBOutlet weak var player1NameLabel: UILabel!
    @IBOutlet weak var player2NameLabel: UILabel!
    
    
    
    
    var gameManager: GameManager
    var ticker: Ticker
    var isRunning: Bool = true
    var roundCount: Int = 0
    let maxRounds = 5
    
    let MIDDLE = 34.817549168324334
    var userName: String?
    var latitude: Double?
    
    required init?(coder: NSCoder) {
        gameManager = GameManager()
        ticker = Ticker()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial values for scores and names
        player1ScoreLabel.text = "0"
        player2ScoreLabel.text = "0"
        
        
        updatePlayerDetails()

        
        winnerLabel.isHidden = true
        winnerScoreLabel.isHidden = true
        backToMenuButton.isHidden = true
        
        // Set initial card images to back of the card
        player1CardImageView.image = UIImage(named: "back")
        player2CardImageView.image = UIImage(named: "back")
        
        // Set initial button image to stop
        controlButton.setImage(UIImage(named: "stop"), for: .normal)
        
        // Ensure constraints
        setConstraints()
        
        ticker.stateChangeHandler = { [weak self] state in
            self?.handleStateChange(state)
        }
        ticker.start()
        
    }
    
    @IBAction func controlButtonTapped(_ sender: UIButton) {
        if isRunning {
            ticker.stop()
            controlButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            ticker.start()
            controlButton.setImage(UIImage(named: "stop"), for: .normal)
        }
        isRunning.toggle()
    }
    
    func handleStateChange(_ state: Ticker.GameState) {
        print("Handling state change to: \(state)")
        switch state {
        case .initial:
            break
        case .flip:
            let result = gameManager.dealCards()
            player1CardImageView.image = UIImage(named: result.player1Card)
            player2CardImageView.image = UIImage(named: result.player2Card)
        case .evaluate:
            let result = gameManager.evaluateCards()
            updateScores(result: result)
        case .scoreUpdate:
            player1CardImageView.image = UIImage(named: "back")
            player2CardImageView.image = UIImage(named: "back")
            player1ScoreLabel.font = UIFont.systemFont(ofSize: 17)
            player2ScoreLabel.font = UIFont.systemFont(ofSize: 17)
            roundCount += 1
        case .checkEnd:
            if roundCount >= maxRounds {
                ticker.triggerGameEnd()
                showWinner()
            } else {
                ticker.updateStateTo(state.nextState)
            }
        case .gameEnd:
            print("State: Game End")
        }
    }
    
    @IBAction func backToMenuTapped(_ sender: UIButton) {
        // Reset the game state
            roundCount = 0
            player1ScoreLabel.text = "0"
            player2ScoreLabel.text = "0"

            // Hide winner labels and button
            winnerLabel.isHidden = true
            winnerScoreLabel.isHidden = true
            backToMenuButton.isHidden = true

            // Show game-related elements
            player1ScoreLabel.isHidden = false
            player2ScoreLabel.isHidden = false
            player1CardImageView.isHidden = false
            player2CardImageView.isHidden = false
            controlButton.isHidden = false

            // Reset card images to back
            player1CardImageView.image = UIImage(named: "back")
            player2CardImageView.image = UIImage(named: "back")

            // Reset the ticker
            ticker.stop()
            ticker.start()
            
            // Create a new instance of HomeController
            if let homeController = storyboard?.instantiateViewController(withIdentifier: "HomeController") as? HomeController {
                // Set the HomeController as the root view controller, clearing the stack
                let navigationController = UINavigationController(rootViewController: homeController)
                
                // Set the navigation controller as the root of the window to reset the stack
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let sceneDelegate = windowScene.delegate as? SceneDelegate,
                   let window = sceneDelegate.window {
                    window.rootViewController = navigationController
                    window.makeKeyAndVisible()
                }
            }

            print("Back to Menu button tapped and game reset")
    }
    
    func updateScores(result: (winner: Int, player1Card: String, player2Card: String)) {
        if result.winner == 1 {
            player1ScoreLabel.text = "\(Int(player1ScoreLabel.text!)! + 1)"
            player1ScoreLabel.font = UIFont.boldSystemFont(ofSize: 24)
            print("Player 1 wins this round")
        } else if result.winner == 2 {
            player2ScoreLabel.text = "\(Int(player2ScoreLabel.text!)! + 1)"
            player2ScoreLabel.font = UIFont.boldSystemFont(ofSize: 24)
            print("Player 2 wins this round")
        } else {
            print("This round is a draw")
        }
    }
    
    func showWinner() {
        let player1Score = Int(player1ScoreLabel.text!)!
        let player2Score = Int(player2ScoreLabel.text!)!

        if player1Score > player2Score {
            winnerLabel.text = player1NameLabel.text
        } else if player2Score > player1Score {
            winnerLabel.text = player2NameLabel.text
        } else {
            winnerLabel.text = "It's a Tie!"
        }
        winnerScoreLabel.text = "Score: \(max(player1Score, player2Score))"
        winnerLabel.isHidden = false
        winnerScoreLabel.isHidden = false
        backToMenuButton.isHidden = false
        
        // Hide game-related elements
        player1ScoreLabel.isHidden = true
        player2ScoreLabel.isHidden = true
        player1CardImageView.isHidden = true
        player2CardImageView.isHidden = true
        controlButton.isHidden = true
        player1NameLabel.isHidden = true
        player2NameLabel.isHidden = true
    }
    
    func setConstraints() {
        player1CardImageView.translatesAutoresizingMaskIntoConstraints = false
        player2CardImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // player1CardImageView constraints
            player1CardImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            player1CardImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),

            // player2CardImageView constraints
            player2CardImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            player2CardImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),

            // Spacing between player1CardImageView and player2CardImageView
            player1CardImageView.trailingAnchor.constraint(equalTo: player2CardImageView.leadingAnchor, constant: -20)
        ])
    }
    
    func updatePlayerDetails() {
        guard let latitude = latitude else {
            print("Latitude is nil")
            return
        }
        
        let direction = checkEastOrWest(latitude: latitude)
        
        if direction == 2 {
            player1NameLabel.text = userName
            player2NameLabel.text = "PC"
        } else {
            player1NameLabel.text = "PC"
            player2NameLabel.text = userName
        }
    }
    
    func checkEastOrWest(latitude: Double) -> Int {
        return latitude < MIDDLE ? 1 : 2
    }
}
