//
//  Carro.swift
//  Estudo
//
//  Created by Diego Trevisan Lara on 03/06/14.
//  Copyright (c) 2014 Diego Trevisan Lara. All rights reserved.
//

import UIKit

enum TipoMotor : Int
{
    case MotorX
    case MotorY
    case MotorZ
    
    func stringDoMotor() -> String
    {
        switch self
        {
        case .MotorX:
            return "Tipo X"
        case .MotorY:
            return "Tipo Y"
        case .MotorZ:
            return "Tipo Z"
        }
    }
}

class Carro: NSObject
{
    // Properties
    var numRodas:Integer
    var strMarca:String
    var tipoMotor:TipoMotor
    
    // Init
    init(rodas:Integer, marca:String, motor:TipoMotor)
    {
        numRodas = 4
        strMarca = marca
        tipoMotor = motor
        super.init()
    }
    
    // Funcao que retorna string
    func resumoCarro() -> String
    {
        return "Meu carro é um(a) \(strMarca), tem motor \(tipoMotor.stringDoMotor()) e \(numRodas) rodas."
    }
}