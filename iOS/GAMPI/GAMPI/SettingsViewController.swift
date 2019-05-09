//
//  SettingsViewController.swift
//  GAMPI
//
//  Created by Dennis Lin on 5/9/19.
//  Copyright © 2019 TungHo Lin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //difficulty
    @IBOutlet weak var quit_button: UIButton!
    @IBOutlet weak var difficulty_picker: UIPickerView!
    var difficulty : GAMPIDifficulty = .easy
    var picker_data = [String]()
    
    //nightmode
    @IBOutlet var gradient_view: GradientView!
    var is_nightmode : Bool = false
    var background_colors : [UIColor] = [UIColor.purple, UIColor.white]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.picker_data = ["Debug", "Easy", "Medium", "Hard", "Difficult", "Impossible"]
        self.difficulty_picker.delegate = self
        self.difficulty_picker.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if is_nightmode {
            gradient_view.firstColor = UIColor.black
            gradient_view.secondColor = UIColor.black
        }
        else {
            gradient_view.firstColor = self.background_colors[0]
            gradient_view.secondColor = self.background_colors[1]
        }
    }
    
    @IBAction func quit(_ sender: UIButton) {
        self.quit_game()
    }
    
    private func quit_game() {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.picker_data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.picker_data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: self.picker_data[row], attributes: [NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 30.0)!, NSAttributedString.Key.foregroundColor: UIColor.white])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
            case 0:
                self.difficulty = .debug
            case 1:
                self.difficulty = .easy
            case 2:
                self.difficulty = .medium
            case 3:
                self.difficulty = .hard
            case 4:
                self.difficulty = .difficult
            case 5:
                self.difficulty = .impossible
            default:
                self.difficulty = .easy
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    


}
