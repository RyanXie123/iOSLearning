//
//  ViewController.swift
//  07animateContraint
//
//  Created by 谢汝 on 2018/4/7.
//  Copyright © 2018年 谢汝. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: IB outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleCenterX: NSLayoutConstraint!
    @IBOutlet weak var titleCenterY: NSLayoutConstraint!
    
    
    
    var slider: HorizontalItemList!
    var isMenuOpen = false
    var items: [Int] = [5, 6, 7]
    
    
    // MARK: class methods
    @IBAction func actionToggleMenu(_ sender: Any) {
        isMenuOpen = !isMenuOpen
        
        titleCenterX.constant = isMenuOpen ? -100:0
        menuHeightContraint.constant = isMenuOpen ? 200:60
        
        
        
        titleCenterY.isActive = false;
        let newTitleLabelCenterY = NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: titleLabel.superview!, attribute: .centerY, multiplier: isMenuOpen ? 0.6:1.0, constant: 0)
        newTitleLabelCenterY.isActive = true
        titleCenterY = newTitleLabelCenterY
        
        
        titleLabel.text = isMenuOpen ? "Select Item":"Packing List"
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
            
            let angel : CGFloat = self.isMenuOpen ? .pi/4:0.0;
            self.buttonMenu.transform = CGAffineTransform(rotationAngle: angel)
        }, completion: nil)
        
        if isMenuOpen {
            slider = HorizontalItemList(inView: titleLabel.superview!)
            slider.didSelectItem = {index in
                self.items.append(index)
                self.tableView.reloadData()
                self.actionToggleMenu(self)
            }
            self.titleLabel.superview!.addSubview(slider)
        }else {
            slider.removeFromSuperview()
        }
    }
    
    
    func showItems(_ index:Int) {
        print("tapped item \(index)")
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

let itemTitles = ["Icecream money", "Great weather", "Beach ball", "Swim suit for him", "Swim suit for her", "Beach games", "Ironing board", "Cocktail mood", "Sunglasses", "Flip flops"]


extension ViewController:UITableViewDataSource,UITableViewDelegate {
    
    
    // MARK: View controller method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 54.0
    }
    
    
    // MARK: table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = itemTitles[items[indexPath.row]]
        cell.imageView?.image = UIImage(named: "summericons_100px_0\(items[indexPath.row]).png")
        
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItems(items[indexPath.row])
    }
}


