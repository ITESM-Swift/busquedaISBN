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
    
    func sync(isbn : String) -> String{
        var txt :String
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + isbn
        let url = NSURL(string: urls)
        let datos:NSData? = NSData(contentsOfURL: url!)
        if datos != nil{
            let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            txt = texto! as String
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func esconderTeclado(sender: AnyObject) {
        self.resignFirstResponder()
        //if txtISBN.text != nil {
            lblResultado.text="Resultado de la búsqueda"
            txtResultado.text = sync(txtISBN.text!)
        //}
        
    }
    
    

}

