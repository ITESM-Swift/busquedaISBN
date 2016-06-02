//
//  ViewController.swift
//  busquedaISBN
//
//  Created by Paco Alvizo on 4/6/16.
//  Copyright © 2016 Paco Alvizo. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    @IBOutlet weak var txtISBN: UITextField!
    @IBOutlet weak var txtResultado: UITextView!
    @IBOutlet weak var lblResultado: UILabel!
    @IBOutlet weak var imgPortada: UIImageView!
    
    func sync(isbn : String) -> String{
        //Guardamos la cadena URL de la consulta a JSON
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + isbn
        //Casteamos la cadena de string al tipo NSURL para que pueda ser leida por NSData
        let url = NSURL(string: urls)
        //Obtenemos el contenido de la consulta JSON y lo almacenamos en datos (tipo NSData)
        let datos = NSData(contentsOfURL: url!)
        var autoresLibro = ""
        var txt  = ""
        if datos != nil{
            //let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)   //Convertimos el contenido obtenido al tipo NSString
            //txt = texto! as String //Lo convertimos a Sring.
            

            do {
                
                let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                let dico1 = json as! NSDictionary
                let dico2 = dico1 ["ISBN:"+isbn] as! NSDictionary
                let titulo = dico2 ["title"] as! NSString as String //Título
                let autoresArray = dico2["authors"] as! NSArray //Arreglo de autores
                for autorLibro in autoresArray {
                    let autorTemp = (autorLibro as! NSDictionary)["name"] as! NSString as String //Autor por autor
                    autoresLibro += autorTemp
                    autoresLibro += "; "
                }
                //Verificamos si la cadena JSON contiene la llave "cover"
                var keys = dico2.allKeys
                for _ in keys{
                    if keys.popLast() as! String == "cover"{
                        //si encontró cover
                        let dico3 = dico2 ["cover"] as! NSDictionary //Portada
                        var keysCover = dico3.allKeys //Obtenemos la cantidad de portadas
                        //Verificamos si contiene una portada mediana
                        for _ in keysCover{
                            if keysCover.popLast() as! String == "medium"{
                                //Obtenemos el link de la portada mediana
                                let mediCover = dico3 ["medium"] as! NSString as String
                                let imgURL = mediCover
                                let urlImage = NSURL(string: imgURL)
                                let datos = NSData(contentsOfURL: urlImage!)
                                if datos != nil {
                                    imgPortada.image=UIImage(data: datos!)
                                }else{
                                    imgPortada.image=nil
                                }
                                
                            }
                        }
                    }
                }

                txt = "Título: \(titulo) \nAutor(es): \(autoresLibro)"
            }
            catch _{
                
            }
            if txt == "{}"{
                txt = "No se encontró el libro con el ISBN indicado"
            }
        }else{
            txt = "No se cuenta con acceso a Internet"
        }
        return txt
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lblResultado.text=""
    }
    @IBAction func eliminarContenidoTxtField(sender: AnyObject) {
        txtResultado.text=""
        lblResultado.text=""
        imgPortada.image=nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func esconderTeclado(sender: AnyObject) {
        self.resignFirstResponder()
            lblResultado.text="Resultado de la búsqueda"
            txtResultado.text = sync(txtISBN.text!)
    }
    
    

}

