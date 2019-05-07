//
//  MainPageViewController.swift
//  GAMPI
//
//  Created by Dennis Lin on 4/19/19.
//  Copyright © 2019 TungHo Lin. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {

    @IBOutlet weak var singleplayer_btn: UIButton!
    @IBOutlet weak var multiplayer_btn: UIButton!
    var is_nightmode : Bool = false
    @IBOutlet var gradient_view: GradientView!
    var background_colors : [UIColor] = [UIColor.purple, UIColor.white]
    
    @IBOutlet weak var nightmode_button: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.background_colors = [self.gradient_view.firstColor, self.gradient_view.secondColor]
        // Do any additional setup after loading the view.
    }
    
    @IBAction func toggle_nightmode(_ sender: UIButton) {
        self.is_nightmode = !self.is_nightmode
        if is_nightmode {
            gradient_view.firstColor = UIColor.black
            gradient_view.secondColor = UIColor.black
        }
        else {
            gradient_view.firstColor = self.background_colors[0]
            gradient_view.secondColor = self.background_colors[1]
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let id = segue.identifier {
            switch (id) {
            case "toSinglePlayer":
                let singlevc = segue.destination as! GamePageViewController
                singlevc.is_nightmode = self.is_nightmode
                singlevc.background_colors = self.background_colors
                break
            case "toMultiPlayer":
                let multivc = segue.destination as! MultiplayerGamePageViewController
                multivc.is_nightmode = self.is_nightmode
                multivc.background_colors = self.background_colors
                break
            default:
                break
            }
        }
    }
 

}
