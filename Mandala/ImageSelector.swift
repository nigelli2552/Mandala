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

    var hightlighView: UIView = {
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

    private var hightlightViewXConstrait: NSLayoutConstraint! {
        didSet {
            oldValue?.isActive = false
            hightlightViewXConstrait.isActive = true
        }
    }

    private func configureViewHierarchy() {
        addSubview(selectorStackView)
        insertSubview(hightlighView, belowSubview: selectorStackView)
        NSLayoutConstraint.activate([
            selectorStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectorStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectorStackView.topAnchor.constraint(equalTo: topAnchor),
            selectorStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            hightlighView.heightAnchor.constraint(equalTo: hightlighView.widthAnchor),
            hightlighView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
            hightlighView.centerYAnchor.constraint(equalTo: selectorStackView.centerYAnchor),
        ])
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
            hightlightViewXConstrait = hightlighView.centerXAnchor.constraint(equalTo: imageButton.centerXAnchor)
        }
    }

    // MARK: - Actions
    @objc private func imageButtonTapped(_ sender: UIButton) {
        guard let buttonIdx = imageButtons.firstIndex(of: sender) else {
            preconditionFailure("The buttons and images are not parallel.")
        }
        selectedIdx = buttonIdx
        sendActions(for: .valueChanged)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        hightlighView.layer.cornerRadius = hightlighView.bounds.width / 2.0
    }
}
