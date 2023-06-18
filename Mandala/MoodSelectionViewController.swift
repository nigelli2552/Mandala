//
//  MoodSelectionViewController.swift
//  Mandala
//
//  Created by nigelli on 2023/6/11.
//

import UIKit

class MoodSelectionViewController: UIViewController {
    @IBOutlet var moodSelector: ImageSelector!
    @IBOutlet var addMoodButton: UIButton!

    var moods: [Mood] = [] {
        didSet {
            curMood = moods.first
            moodSelector.images = moods.map { $0.image }
            moodSelector.highlightColors = moods.map { $0.color }
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

    @IBAction private func moodSelectionChanged(_ sender: ImageSelector) {
        let selectedIdx = sender.selectedIdx
        curMood = moods[selectedIdx]
    }

    var moodsConfigurable: MoodsConfigurable!

    // MARK: - View Lifecycle
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

    override func viewDidLoad() {
        super.viewDidLoad()
        moods = [.happy, .angry, .sad, .goofy, .crying, .confused, .sleepy, .meh]
        addMoodButton.layer.cornerRadius = addMoodButton.bounds.height / 2
    }

    // MARK: - Actions
    @IBAction func addMoodTapped(_ sender: Any) {
        guard let curMood = curMood else {
            return
        }
        let newMoodEntry = MoodEntry(mood: curMood, timestamp: Date())
        moodsConfigurable.add(newMoodEntry)
    }
}
