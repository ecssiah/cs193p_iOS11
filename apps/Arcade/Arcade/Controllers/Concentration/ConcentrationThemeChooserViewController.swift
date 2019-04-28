//
//  ConcentrationThemeChooserViewController.swift
//  Arcade
//
//  Created by Michael Chapman on 4/26/19.
//  Copyright © 2019 Gauge Structures. All rights reserved.
//

import UIKit

class ConcentrationThemeViewController: UIViewController, UISplitViewControllerDelegate
{
    let themes = [
        "Faunal":   "🐅🦂🦓🐘🐪🐎🐏🦢",
        "Floral":   "💐🌷🌹🥀🌺🌸🌼🌻",
        "Ethereal": "🧞‍♀️🧞‍♂️🧜🏻‍♀️🧜🏽‍♂️🧚🏽‍♀️🧚🏿‍♂️🐉🐲"
    ]
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
        ) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        
        return false
    }
    
    private var splitViewDetailConcentrationViewController : ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSequedToConcentrationViewController : ConcentrationViewController?
    
    @IBAction func chooseTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSequedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSequedToConcentrationViewController = cvc
                }
            }
        }
    }
}
