//
//  ViewController.swift
//  DrawingSample
//
//  Created by HuyNguyen on 9/28/17.
//  Copyright © 2017 Savvycom JSC. All rights reserved.
//

import UIKit



func distance(from: CGPoint, to: CGPoint) -> CGFloat {
    let deltaX = from.x - to.x
    let deltaY = from.y - to.y
    return sqrt(deltaX * deltaX - deltaY * deltaY)
}


protocol Regionable {
    var region: Region { get set }
}

struct Relationship {
    let color: UIColor
    let region: Region
    
}

struct Region {
    var center: CGPoint
    var radius: CGFloat
    
    
    func contains(point: CGPoint) -> Bool {
        return distance(from: self.center, to: point) <= self.radius
    }
    
    
    var frame: CGRect {
        return CGRect.init(x: self.center.x - self.radius, y: self.center.y - self.radius, width: self.radius * 2, height: self.radius * 2)
    }
}
extension Region {
    init(frame: CGRect) {
        let halfSize = frame.size.width / 2
        self.center = CGPoint.init(x: frame.origin.x + halfSize, y: frame.origin.y + halfSize)
        self.radius = halfSize
    }
}


protocol UIViewMoveable: class {
    var isMoveable: Bool { get set }
}

final class RegionView: UILabel, Regionable {
    
    var region: Region
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(self.moving(sender:)))
    }()
    
    
    override var center: CGPoint {
        didSet {
            self.region.center = self.center
        }
    }
    
    
    init(region: Region) {
        let frame = region.frame
        self.region = region
        
        super.init(frame: frame)

        self.textAlignment = .center
        self.backgroundColor = .yellow
        self.layer.cornerRadius = region.radius
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(self.panGesture)
        
    }
    
    
    @objc func moving(sender: UIPanGestureRecognizer) {
        let translate = sender.translation(in: self.superview)
        self.superview?.bringSubview(toFront: self)
        self.center = CGPoint(x: self.center.x + translate.x, y: self.center.y + translate.y)
        sender.setTranslation(.zero, in: self.superview)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension RegionView: UIViewMoveable {
    var isMoveable: Bool {
        get {
            return self.isUserInteractionEnabled && self.panGesture.isEnabled
        }
        set {
            self.isUserInteractionEnabled = newValue
            self.panGesture.isEnabled = newValue
        }
    }
}


final class ViewController: UIViewController {
    
    var regions: [RegionView] = []
    

    @IBAction func onValueChange(_ sender: UISwitch) {
        self.regions.forEach { $0.isMoveable = sender.isOn }
        
    }
    
    
    @IBAction func addingView(_ sender: Any) {
        
        let label = RegionView(region: Region(frame: CGRect(x: 0, y: 64, width: 50, height: 50)))
        label.text = String(self.regions.count)
        self.view.addSubview(label)
        self.regions.append(label)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

}

