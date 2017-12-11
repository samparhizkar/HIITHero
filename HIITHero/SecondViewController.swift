//
//  SecondViewController.swift
//  sweatTimer
//
//  Created by Sam Parhizkar on 2017-11-16.
//  Copyright © 2017 Sam Parhizkar. All rights reserved.
//

import UIKit

class SecondViewController: UITableViewController {
    
    @IBOutlet weak var finalMovesTV: UITableView!
    //    @IBOutlet weak var suggestedMovesTV: UITableView!
    
    var suggestedMoves : [String] = []
    var finalMoves  : [String] = []
    var mymodel  = workoutsModel()
    let userDefaults = UserDefaults()
    let userDefaultsKeyForMovesArray = "final moves array"
    override func viewDidLoad() {
        super.viewDidLoad()
     
        suggestedMoves = mymodel.readWorkouts().suggestedWorkoutNames
        finalMoves = userDefaults.array(forKey: userDefaultsKeyForMovesArray) as! [String]
        self.finalMovesTV.isEditing = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return finalMoves.count
        }
        else {
            return suggestedMoves.count
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Your Tabata"
        }
        else {
            return "Available Tabata"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if indexPath.section == 0 {
            cell?.textLabel?.text = finalMoves[indexPath.item]
        }
        else {
            cell?.textLabel?.text = suggestedMoves[indexPath.item]
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 0 {
            return UITableViewCellEditingStyle.delete
        } else {
            return UITableViewCellEditingStyle.insert
        }
        
        
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0{
            return true}
        return false
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == 0 {
            let rowToMove = finalMoves[sourceIndexPath.item]
            finalMoves.remove(at: sourceIndexPath.item)
            finalMoves.insert(rowToMove, at:destinationIndexPath.item)
            userDefaults.set(finalMoves, forKey: userDefaultsKeyForMovesArray)
//            mymodel.writeWorkouts(SuggestedMoves: suggestedMoves, selectionOfMoves: finalMoves)

        }
        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (finalMoves.count > 2) == true {
            finalMoves.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .top)
            }else {
                let alertController = UIAlertController(title: "Below Minimum", message: "You should at least have 3 workouts in your circuit ", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title:"OK" , style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
        if editingStyle == .insert {
            if (finalMoves.count < 11) == true {
            finalMoves.append("test workout")
            tableView.insertRows(at: [ IndexPath.init(item:
                finalMoves.count - 1, section: 0)], with: .bottom)
                
            }else {
                let alertController = UIAlertController(title: "Maximum reached", message: "You can add a total of 10 workouts to your circuit ", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title:"OK" , style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
            }
            
        }
        userDefaults.set(finalMoves, forKey: userDefaultsKeyForMovesArray)
//        mymodel.writeWorkouts(SuggestedMoves: suggestedMoves, selectionOfMoves: finalMoves)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        userDefaults.synchronize();
    }
}

