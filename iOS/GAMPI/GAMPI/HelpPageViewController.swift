//
//  HelpPageViewController.swift
//  GAMPI
//
//  Created by Dennis Lin on 5/9/19.
//  Copyright © 2019 TungHo Lin. All rights reserved.
//

import UIKit

class HelpPageViewController: UIViewController {

    
    @IBOutlet var gradient_view: GradientView!
    var is_nightmode : Bool = false
    var background_colors : [UIColor] = [UIColor.purple, UIColor.white]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        dismiss(animated: false, completion: nil)
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
