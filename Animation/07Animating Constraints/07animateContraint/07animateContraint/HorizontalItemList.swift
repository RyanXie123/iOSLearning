//
//  HorizontalItemList.swift
//  07animateContraint
//
//  Created by 谢汝 on 2018/4/7.
//  Copyright © 2018年 谢汝. All rights reserved.
//

import UIKit

class HorizontalItemList: UIScrollView {

    var didSelectItem:((_ index:Int)->())?
    let buttonWidth: CGFloat = 60.0
    let padding: CGFloat = 10.0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(inView:UIView) {
        let rect = CGRect(x: inView.bounds.size.width, y: 120, width: inView.bounds.size.width, height: 80.0)
        self.init(frame: rect)
        alpha = 0;
        
        for i in 0..<10 {
            let image = UIImage(named: "summericons_100px_0\(i).png")
            let imageView = UIImageView(image: image)
            imageView.center = CGPoint(x: CGFloat(i) * buttonWidth + buttonWidth/2, y: buttonWidth/2)
            imageView.tag = i
            imageView.isUserInteractionEnabled = true
            addSubview(imageView)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage(_:)))
            imageView.addGestureRecognizer(tap)
        }
        
        contentSize = CGSize(width: 10 * buttonWidth, height: buttonWidth + 2 * padding)
        
    }
    
    @objc func didTapImage(_ tap:UITapGestureRecognizer) {
        didSelectItem?(tap.view!.tag)
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard superview !== nil else {
            return
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseIn, animations: {
            self.alpha = 1.0
            self.center.x -= self.bounds.size.width
        }, completion: nil)
        
        
        
        
    }
    
}
