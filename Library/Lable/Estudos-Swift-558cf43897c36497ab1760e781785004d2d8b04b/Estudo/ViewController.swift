//
//  ViewController.swift
//  Estudo
//
//  Created by Diego Trevisan Lara on 03/06/14.
//  Copyright (c) 2014 Diego Trevisan Lara. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet var lblCarro: UILabel
                            
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.arrumaView(true)

        let meuCarro = Carro(rodas: 4, marca: "BMW", motor: TipoMotor.MotorY)
        let str = meuCarro.resumoCarro()
        lblCarro.text = str
    }
    
    
    func arrumaView(animacao:Bool) -> Void
    {
        let vRed: CGFloat = 0.5
        let vGreen: CGFloat = 0.5
        let vBlue: CGFloat = 0.8
        
        if animacao
        {
            view.backgroundColor = UIColor.blackColor()
            
            UIView.animateWithDuration(3.0, animations:
                {
                    //println(String(randomRed) + " " + String(randomGreen) + " " + String(randomBlue))
                    self.view.backgroundColor = UIColor(red: vRed, green: vGreen, blue: vBlue, alpha: 1.0)
                })
        }
        else
        {
            view.backgroundColor = UIColor(red: vRed, green: vGreen, blue: vBlue, alpha: 1.0)
        }
        
        lblCarro.textAlignment = NSTextAlignment.Center
        lblCarro.adjustsFontSizeToFitWidth = true
        lblCarro.shadowOffset = CGSizeMake(1, 1)
        lblCarro.textColor = UIColor.whiteColor()
        lblCarro.shadowColor = UIColor.blackColor()
        lblCarro.numberOfLines = 0
    }
    
}