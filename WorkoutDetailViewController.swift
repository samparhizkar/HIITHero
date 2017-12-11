//
//  WorkoutDetailViewController.swift
//  sweatTimer
//
//  Created by Sam Parhizkar on 2017-11-26.
//  Copyright © 2017 Sam Parhizkar. All rights reserved.
//

import UIKit

class WorkoutDetailViewController: UIViewController,UIScrollViewDelegate {
    @IBOutlet weak var workoutTitle: UILabel!
    @IBOutlet weak var workoutpg: UIPageControl!
    @IBOutlet weak var picturesscrollview: UIScrollView!
    var workoutName = ""
    var imageArray = [UIImage]()
    @IBOutlet weak var workoutBody: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        picturesscrollview.contentSize.width = self.picturesscrollview.frame.width * CGFloat(1)

        for index in 0...0{
            let imageView = UIImageView()
            imageView.image = imageArray[index]
            imageView.contentMode = .scaleToFill
            let xPosition = self.view.frame.width * CGFloat( index)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.picturesscrollview.frame.width, height: self.picturesscrollview.frame.height)
            picturesscrollview.addSubview(imageView)
        }
        // Do any additional setup after loading the view.
    }
 
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        workoutpg.currentPage =  Int(pageNumber)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
