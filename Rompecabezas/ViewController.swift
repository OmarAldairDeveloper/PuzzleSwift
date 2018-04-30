//
//  ViewController.swift
//  Rompecabezas
//
//  Created by Omar Aldair Romero Pérez on 23/04/18.
//  Copyright © 2018 Omar Aldair Romero Pérez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var board: UIView!
    
    
    
    var tileWidth : CGFloat = 0.0
    var tileCenterX : CGFloat = 0.0
    var tileCenterY : CGFloat = 0.0
    
    var tileArray : NSMutableArray = [] // Array para guardar los tiles
    var tileCenterArray : NSMutableArray = [] // Array para guardar los centros de los tiles
    var tileEmptyCenter: CGPoint = CGPoint(x: 0, y: 0)
    
    
    var orderTileArray : NSMutableArray = []
    
    @IBAction func restarGameBtn(_ sender: UIButton) {
        self.randomTiles()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTiles()
        randomTiles()
        
        
    }
    
    func makeTiles(){
        self.tileArray = []
        self.tileCenterArray = []
        let boardWith = self.board.frame.width // Calcular ancho del área de juego total
        self.tileWidth = boardWith / 4 // Cada tile tendrá el ancho de 1/4 del tablero
        self.tileCenterX = self.tileWidth / 2 // Centro del tile en x
        self.tileCenterY = self.tileWidth / 2 // Centro del tile en Y
        var tileNumber : Int = 1
        
        
        for _ in 0...3{
            
            for _ in 0...3{
                let tileFrame = CGRect(x: 0, y: 0, width: self.tileWidth - 2, height: self.tileWidth - 2) // Frame del tile
                let tile = CustomLabel(frame: tileFrame) // Tile en forma de label
                let currentCenter = CGPoint(x: self.tileCenterX, y: tileCenterY) // Calcular centro del tile
                tile.center = currentCenter // Centro del tile
                tile.originCenter = currentCenter // posición origen de cada tile
                self.tileCenterArray.add(currentCenter)
                //tile.backgroundColor = UIColor.blue
                self.board.addSubview(tile) // Agregar al board ese UILabel
                //tile.text = "\(tileNumber)"
                if tileNumber <= 16{
                    tile.backgroundColor = UIColor(patternImage: UIImage(named: "\(tileNumber).jpg")!)
                }else{
                    tile.backgroundColor = UIColor.gray
                }
                tile.textAlignment = NSTextAlignment.center
                tile.textColor = UIColor.white
                tile.isUserInteractionEnabled = true
                tileNumber = tileNumber + 1
                self.tileArray.add(tile) // Guardar el tile en el array
                self.tileCenterX = self.tileCenterX + self.tileWidth
            }
            
            self.tileCenterX = tileWidth / 2 // Reiniciar el centro en X
            self.tileCenterY = tileCenterY + self.tileWidth
        }
        
        let lastTile: CustomLabel = self.tileArray.lastObject as! CustomLabel  // el último elemento
        lastTile.removeFromSuperview() // eliminar el último tile de la interfáz
        self.tileArray.removeObject(at: 15) // También eliminarlo del array
        
        
    }
    
    
    
    func randomTiles(){
        
        let tempTileCenterArray : NSMutableArray = self.tileCenterArray.mutableCopy() as! NSMutableArray // Tener una copia del array para que no falle ni se quede sin elementos, porque más abajo vamos eliminando los elementos del array
        
        // Para hacer el random debemos recorrer el array de tiles e intercambiar aleatoriamente los centro de tiles obtenidos
        for anyTile in self.tileArray{
            let randomIndex : Int = Int(arc4random()) % tempTileCenterArray.count // obtener un entero aleatorio
            let randomCenter : CGPoint = tempTileCenterArray[randomIndex] as! CGPoint// Obtener un centro aleatorio
            (anyTile as! CustomLabel).center = randomCenter // asignarle a cada tile el centro aleatorio
            tempTileCenterArray.removeObject(at: randomIndex) // eliminar el elemento asignado para que no se repita y los va descartando
        }
        
        self.tileEmptyCenter = tempTileCenterArray[0] as! CGPoint // El elemento vacío es el único que queda en el array
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Función para captar el evento para mover los tiles
        
        let currentTouch: UITouch = touches.first! // Capturar el evento
        
        // Si el array está contenido en la vista que toqué entonces:
        if (self.tileArray.contains(currentTouch.view as Any)){ // currentTouch capta la pantalla y currentTouch.view la vista
            
            //currentTouch.view?.alpha = 0 // desapareciendo el elemento que se tocó
            // Sólo puedo moverlos elementos adyacentes al tile vacío
            
            let touchLabel: CustomLabel = currentTouch.view as! CustomLabel // Label que estoy tocando
            
            // Distancia entre 2 puntos, en este caso entre el centro del label que estoy tocando y el centro del label vacío, ya que así se calcula si son adyacentes
            let xDif: CGFloat = touchLabel.center.x - self.tileEmptyCenter.x
            let yDif: CGFloat = touchLabel.center.y - self.tileEmptyCenter.y
            let distance: CGFloat = sqrt(pow(xDif, 2) + pow(yDif, 2))
            
            
            if distance == self.tileWidth{
                // Puedo hacer el movimientoy voy a intercambiar los centros
                
                let tempCenter: CGPoint = touchLabel.center // Centro del label que estoy tocando
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.3)
                touchLabel.center = self.tileEmptyCenter // Centro del label tocado es igual al centro del vacío
                UIView.commitAnimations()
                self.tileEmptyCenter = tempCenter // Centro del label vacío es igual al label que toqué
            }
            
        }
    
        
        
        
    }

}

class CustomLabel : UILabel{
    // Clase que hereda de UILabel y que va a tener un atributo extra, el centro de cada label, para saber el centro de cada tile
    var originCenter: CGPoint = CGPoint(x: 0, y: 0)
}

