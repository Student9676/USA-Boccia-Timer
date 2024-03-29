//
//  InputScoreViewController.swift
//  USA Boccia Timer
//
//  Created by Fox on 3/24/24.
//

import Foundation
import UIKit

protocol InputScoreViewControllerDelegate: AnyObject
{
   func inputScoreViewControllerDidCancel(
      _ controller: InputScoreViewController)
   
   func inputScoreViewController(
      _ controller: InputScoreViewController,
      didFinishAdding item: EndsItem)
}

class InputScoreViewController: UIViewController
{
   
   var newMatchItem = MatchItem()
   var endsItem = [EndsItem]()
   //var endsItem: [EndsItem]?
   
   var currentEndItem = EndsItem()
   
   var currentEndNumber = 0
   var currentTimeRedTeamEnd = 0
   var currentTimeBlueTeamEnd = 0
   
   var redTeamCumulativeScore = 0
   var blueTeamCumulativeScore = 0
   
   weak var delegate: InputScoreViewControllerDelegate?
   
   @IBOutlet weak var endsButton: UIButton!
   @IBOutlet weak var redTeamNameLabel: UILabel!
   @IBOutlet weak var redTeamFlagImage: UIImageView!
   @IBOutlet weak var redTeamTimeRemainingLabel: UILabel!
   @IBOutlet weak var redTeamTimeRemainingStepper: UIStepper!
   @IBOutlet weak var redTeamBallsScored: UISegmentedControl!
   @IBOutlet weak var redTeamPenaltiesScored: UISegmentedControl!
   @IBOutlet weak var blueTeamNameLabel: UILabel!
   @IBOutlet weak var blueTeamFlagImage: UIImageView!
   @IBOutlet weak var blueTeamTimeRemainingLabel: UILabel!
   @IBOutlet weak var blueTeamTimeRemainingStepper: UIStepper!
   @IBOutlet weak var blueTeamBallsScored: UISegmentedControl!
   @IBOutlet weak var blueTeamPenaltiesScored: UISegmentedControl!

   
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      endsButton.showsMenuAsPrimaryAction = true
      endsButton.menu = addMenuItems()
      
      endsButton.setTitle(currentEndNumber.description, for: .normal)
      endsButton.titleLabel?.font = UIFont.systemFont(ofSize: 55)
      
      redTeamNameLabel.text = newMatchItem.redTeamName
      redTeamFlagImage.image = UIImage(named: newMatchItem.redTeamFlagName)
      redTeamTimeRemainingLabel.text = formatTimerMinutesSeconds(currentTimeRedTeamEnd)
      
      blueTeamNameLabel.text = newMatchItem.blueTeamName
      blueTeamFlagImage.image = UIImage(named: newMatchItem.blueTeamFlagName)
      blueTeamTimeRemainingLabel.text = formatTimerMinutesSeconds(currentTimeBlueTeamEnd)
      
      //Round Corners of the CountDown Timer and Penalty Labels, and their respective Buttons
      blueTeamTimeRemainingLabel.layer.masksToBounds = true
      blueTeamTimeRemainingLabel.layer.borderWidth = 2
      blueTeamTimeRemainingLabel.layer.cornerRadius = 15
      blueTeamTimeRemainingLabel.layer.borderColor = UIColor.black.cgColor
      
      redTeamTimeRemainingLabel.layer.masksToBounds = true
      redTeamTimeRemainingLabel.layer.borderWidth = 2
      redTeamTimeRemainingLabel.layer.cornerRadius = 15
      redTeamTimeRemainingLabel.layer.borderColor = UIColor.black.cgColor
      
      //Round Corners of the CountDown Timer and Penalty Labels, and their respective Buttons
      endsButton.layer.masksToBounds = true
      endsButton.layer.cornerRadius = 15
   }
   
   
   //MARK:  - Actions
   
   @IBAction func done()
   {
      
//TODO:  - Add Save Code to save to P-List
      
      //Save Data into Array
      if let currentEndNumber = Int( (endsButton.titleLabel?.text)! )
      {
	 currentEndItem.endNumber = currentEndNumber
	 currentEndItem.classification = newMatchItem.classification
	 currentEndItem.endsTime = newMatchItem.endsTime
	 currentEndItem.redTeamName = newMatchItem.redTeamName
	 currentEndItem.blueTeamName = newMatchItem.blueTeamName
	 currentEndItem.redTeamFlagName = newMatchItem.redTeamFlagName
	 currentEndItem.blueTeamFlagName = newMatchItem.blueTeamFlagName
	 currentEndItem.redTeamFinalScore = redTeamBallsScored.selectedSegmentIndex
	 currentEndItem.blueTeamFinalScore = blueTeamBallsScored.selectedSegmentIndex
	 currentEndItem.redTeamPenaltiesScored = redTeamPenaltiesScored.selectedSegmentIndex
	 currentEndItem.blueTeamPenaltiesScored = blueTeamPenaltiesScored.selectedSegmentIndex
	 currentEndItem.redTeamPenaltyCount = 0
	 currentEndItem.blueTeamPenaltyCount = 0
	 
	 //endsItem[currentEndNumber].blueTeamEndTimeRemaining = 0
	 //endsItem[currentEndNumber].redTeamEndTimeRemaining = 0
      }
      
      //Check if Last Ends
      if ( currentEndNumber >= newMatchItem.numEnds )
      {
	 //Game Over
	 
	 let item = currentEndItem
	 delegate?.inputScoreViewController(self, didFinishAdding: item)
	 
	 //Close the previous screens before showing the Final Score Screen
	 //navigationController?.popViewController(animated: true)
	 //navigationController?.popViewController(animated: true)
	 //navigationController?.popViewController(animated: true)
	 //navigationController?.popViewController(animated: true)
	 
	 //Check if Tie Breaker is necessary (at the end of the last End Section)
	 if ( redTeamCumulativeScore == blueTeamCumulativeScore )
	 {
	    performSegue(withIdentifier: "StartTieBreak", sender: nil)
	 }
      }
      else
      {
	 currentEndNumber = currentEndNumber + 1
	 
	 let item = currentEndItem
	 delegate?.inputScoreViewController(self, didFinishAdding: item)
      }
   
      
   }
   
   
   @IBAction func redTeamEndTimeStepperChanged(_ sender: UIStepper)
   {
      currentTimeRedTeamEnd = Int( sender.value )
      redTeamTimeRemainingLabel.text = formatTimerMinutesSeconds( Int(sender.value) )
   }
   
   @IBAction func blueTeamEndTimeStepperChanged(_ sender: UIStepper)
   {
      currentTimeBlueTeamEnd = Int( sender.value )
      blueTeamTimeRemainingLabel.text = formatTimerMinutesSeconds( Int(sender.value) )
   }
   
   
   func addMenuItems() -> UIMenu
   {
	 let menuItems = UIMenu(title: "Choose an End", options: .displayInline, children: [
   
	    UIAction(title: "Ends 01", handler:
			{ [self] (_) in
			   print("Selected Item: ENDS 01 has been selected")
			   endsButton.setTitle("1", for: .normal)
			   endsButton.titleLabel?.font = UIFont.systemFont(ofSize: 55)
			   //endsItem[0].endNumber = 1
			   
			}),
	    UIAction(title: "Ends 02", handler:
			{ [self] (_) in
			   print("Selected Item: ENDS 02 has been selected")
			   endsButton.setTitle("2", for: .normal)
			   endsButton.titleLabel?.font = UIFont.systemFont(ofSize: 55)
			   //endsItem[1].endNumber = 2
			}),
	    UIAction(title: "Ends 03", handler:
			{ [self] (_) in
			   print("Selected Item: ENDS 03 has been selected")
			   endsButton.setTitle("3", for: .normal)
			   endsButton.titleLabel?.font = UIFont.systemFont(ofSize: 55)
			   //endsItem[2].endNumber = 3
			}),
	    UIAction(title: "Ends 04", handler:
			{ [self] (_) in
			   print("Selected Item: ENDS 04 has been selected")
			   endsButton.setTitle("4", for: .normal)
			   endsButton.titleLabel?.font = UIFont.systemFont(ofSize: 55)
			   //endsItem[3].endNumber = 4
			}),
	    UIAction(title: "Ends 05", handler:
			{ [self] (_) in
			   print("Selected Item: ENDS 05 has been selected")
			   endsButton.setTitle("5", for: .normal)
			   endsButton.titleLabel?.font = UIFont.systemFont(ofSize: 55)
			   //endsItem[4].endNumber = 5
			}),
	    UIAction(title: "Ends 06", handler:
			{ [self] (_) in
			   print("Selected Item: ENDS 06 has been selected")
			   endsButton.setTitle("6", for: .normal)
			   endsButton.titleLabel?.font = UIFont.systemFont(ofSize: 55)
			   //endsItem[5].endNumber = 6
			})
	 ])
      
      return menuItems
   }
   
   
   //MARK:  - Custom Functions
   
   //Custom Function for formatting Number of Seconds into Human-Readable Minutes:Seconds
   func formatTimerMinutesSeconds(_ totalSeconds: Int) -> String
   {
      let seconds: Int = totalSeconds % 60
      let minutes: Int = (totalSeconds / 60) % 60
      return String(format: "%02d:%02d", minutes, seconds)
   }
   
   
   
    // MARK: - Navigation
    
   override func prepare(
      for segue: UIStoryboardSegue,
      sender: Any?)
   {
      if segue.identifier == "StartTieBreak"
      {
	 let controller = segue.destination as! TieBreakViewController
	 
	 controller.newMatchItem = newMatchItem
      }
      
   }
   

}
