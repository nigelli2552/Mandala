//
//  MoodSelectionViewController.swift
//  Mandala
//
//  Created by nigelli on 2023/6/11.
//

import UIKit

class MoodSelectionViewController: UIViewController {
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var addMoodButton: UIButton!

    var moods: [Mood] = [] {
        didSet {
            moodButtons = moods.map({ mood in
                let moodButton = UIButton()
                moodButton.setImage(mood.image, for: .normal)
                moodButton.imageView?.contentMode = .scaleAspectFit
                moodButton.addTarget(self, action: #selector(moodSelectionChanged(_:)), for: .touchUpInside)
                return moodButton
            })
        }
    }

    var moodButtons: [UIButton] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            moodButtons.forEach { stackView.addArrangedSubview($0) }
        }
    }

    var curMood: Mood? {
        didSet {
            guard let curMood = curMood else {
                addMoodButton?.setTitle(nil, for: .normal)
                addMoodButton?.backgroundColor = nil
                return
            }
            addMoodButton?.setTitle("I'm \(curMood.name)", for: .normal)
            addMoodButton?.backgroundColor = curMood.color
        }
    }

    @objc func moodSelectionChanged(_ sender: UIButton) {
        guard let selectedIdx = moodButtons.firstIndex(of: sender) else {
            preconditionFailure(
                "Unable to find the tapped button in the buttons array.")
        }
        curMood = moods[selectedIdx]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        moods = [.happy, .angry, .sad, .goofy, .crying, .confused, .sleepy, .meh]
        addMoodButton.layer.cornerRadius = addMoodButton.bounds.height / 2
    }

    var moodsConfigurable: MoodsConfigurable!

    // MARK: View Lifecycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "embedContainerViewController":
            guard let moodsConfigurable = segue.destination as? MoodsConfigurable else {
                preconditionFailure(
                    "View controller expected to conform to MoodsConfigurable")
            }
            self.moodsConfigurable = moodsConfigurable
            segue.destination.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 160, right: 0)
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }

    // MARK: Actions
    @IBAction func addMoodTapped(_ sender: Any) {
        guard let curMood = curMood else {
            return
        }
        let newMoodEntry = MoodEntry(mood: curMood, timestamp: Date())
        moodsConfigurable.add(newMoodEntry)
    }
}
