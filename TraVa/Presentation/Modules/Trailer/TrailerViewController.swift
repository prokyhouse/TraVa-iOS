import YouTubeiOSPlayerHelper
import AVKit
import Domain
import UIKit

protocol TrailerView: AnyObject { }

final class TrailerViewController: UIViewController {
    // MARK: - Views

    private let trailerView = YTPlayerView()

    let playerVars = [
        "playsinline": 1,
        "showinfo": 1,
        "rel": 0,
        "modestbranding": 1,
        "controls": 1,
        "iv_load_policy": 3,
        "origin": "https://wwww.example.com"
    ] as [AnyHashable: Any]?

    // MARK: - Initialization

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setupConstraints()
        setupViews()
    }
}

// MARK: - Private methods

private extension TrailerViewController {
    func addSubviews() {
        view.addSubview(trailerView)
    }

    func setupConstraints() {
        NSLayoutConstraint.useAndActivateConstraints([
            trailerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            trailerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            trailerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trailerView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    func setupViews() {
        view.backgroundColor = .white
        trailerView.load(withPlayerParams: playerVars)
        trailerView.load(withVideoId: "9LLOLEBlVIA", playerVars: playerVars)
        trailerView.layer.cornerRadius = 32.0
        trailerView.clipsToBounds = true
        trailerView.delegate = self
        // trailerView.playVideo()

    }
}

// MARK: - TrailerView

extension TrailerViewController: TrailerView { }

// MARK: - YTPlayerViewDelegate

extension TrailerViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        // trailerView.playVideo()
    }
}
