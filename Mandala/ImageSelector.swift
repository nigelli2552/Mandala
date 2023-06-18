//
//  ImageSelector.swift
//  Mandala
//
//  Created by nigelli on 2023/6/15.
//

import UIKit

class ImageSelector: UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewHierarchy()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViewHierarchy()
    }

    private let selectorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 12.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    var highlightView: UIView = {
        let view = UIView()
        view.backgroundColor = view.tintColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var imageButtons: [UIButton] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            imageButtons.forEach { selectorStackView.addArrangedSubview($0) }
        }
    }

    var images: [UIImage] = [] {
        didSet {
            imageButtons = images.map { image in
                let imageButton = UIButton()
                imageButton.setImage(image, for: .normal)
                imageButton.imageView?.contentMode = .scaleAspectFit
                imageButton.addTarget(self, action: #selector(imageButtonTapped(_:)),
                                      for: .touchUpInside)
                return imageButton
            }
            selectedIdx = 0
        }
    }

    private var highlightViewXConstrait: NSLayoutConstraint! {
        didSet {
            oldValue?.isActive = false
            highlightViewXConstrait.isActive = true
        }
    }

    private func configureViewHierarchy() {
        addSubview(selectorStackView)
        insertSubview(highlightView, belowSubview: selectorStackView)
        NSLayoutConstraint.activate([
            selectorStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectorStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectorStackView.topAnchor.constraint(equalTo: topAnchor),
            selectorStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            highlightView.heightAnchor.constraint(equalTo: highlightView.widthAnchor),
            highlightView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
            highlightView.centerYAnchor.constraint(equalTo: selectorStackView.centerYAnchor),
        ])
    }

    var highlightColors: [UIColor] = [] {
        didSet {
            highlightView.backgroundColor = highlightColor(forIndex: selectedIdx)
        }
    }

    private func highlightColor(forIndex index: Int) -> UIColor {
        guard index >= 0 && index < highlightColors.count else {
            return UIColor.blue.withAlphaComponent(0.6)
        }
        return highlightColors[index]
    }

    var selectedIdx = 0 {
        didSet {
            if selectedIdx < 0 {
                selectedIdx = 0
            }
            if selectedIdx >= images.count {
                selectedIdx = images.count - 1
            }
            let imageButton = imageButtons[selectedIdx]
            highlightViewXConstrait = highlightView.centerXAnchor.constraint(equalTo: imageButton.centerXAnchor)

            highlightView.backgroundColor = highlightColor(forIndex: selectedIdx)
        }
    }

    // MARK: - Actions
    @objc private func imageButtonTapped(_ sender: UIButton) {
        guard let buttonIdx = imageButtons.firstIndex(of: sender) else {
            preconditionFailure("The buttons and images are not parallel.")
        }
        let selectionAnimator = UIViewPropertyAnimator(
            duration: 0.3,
            dampingRatio: 0.7,
            animations: {
                self.selectedIdx = buttonIdx
                self.layoutIfNeeded()
            })
        selectionAnimator.startAnimation()
        sendActions(for: .valueChanged)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        highlightView.layer.cornerRadius = highlightView.bounds.width / 2.0
    }
}
