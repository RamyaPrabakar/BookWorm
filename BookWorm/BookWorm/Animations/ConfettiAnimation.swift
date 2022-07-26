//
//  ConfettiAnimation.swift
//  BookWorm
//
//  Created by Ramya Prabakar on 7/26/22.
//

import Foundation
import UIKit

@objcMembers
public class ConfettiAnimation : NSObject {
    func playMatchAnimationForView(_ view: UIView){
        let layer = CAEmitterLayer()
        
        layer.emitterPosition = CGPoint(
            x: view.center.x,
            y: -100
        )
        
        let colors : [UIColor] = [
            .systemRed,
            .systemBlue,
            .systemOrange,
            .systemGreen,
            .systemPink,
            .systemYellow,
            .systemPurple
        ]
        
        let cells: [CAEmitterCell] = colors.compactMap {_ in
            let cell = CAEmitterCell()
            cell.scale = 0.02
            cell.birthRate = 50
            cell.emissionRange = .pi * 2
            cell.lifetime = 10
            cell.velocity = 150
            cell.contents = UIImage(named: "white square")!.cgImage
            return cell
        }
        
        
        layer.emitterCells = cells
        view.layer.addSublayer(layer);
        
        var dispatchAfter = DispatchTimeInterval.seconds(5)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchAfter, execute: {
            layer.removeFromSuperlayer();
        })
    }
}
