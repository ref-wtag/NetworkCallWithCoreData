//
//  ProductDetailsViewController.swift
//  NetworkCallWithCoreData
//
//  Created by Refat E Ferdous on 12/7/23.
//

import UIKit

class ProductDetailsViewController: UIViewController {

    
    @IBOutlet var productTitle : UILabel!
    @IBOutlet var price : UILabel!
    @IBOutlet var des : UILabel!
    @IBOutlet var rate : UILabel!
    @IBOutlet var count : UILabel!
    @IBOutlet var myImage : UIImageView!
    
    
    var productTitleVal : String = ""
    var priceVal : Double = 0.0
    var desVal : String = ""
    var rateVal : Double = 0.0
    var countVal : Int = 0
    var myImageVal : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productTitle.text = productTitleVal
        price.text = String(priceVal)
        des.text = desVal
        rate.text = String(rateVal)
        count.text = "\(countVal)"
    
        
        let imageUrlString = myImageVal
        let imageUrl = URL(string : imageUrlString)
        
        URLSession.shared.dataTask(with: imageUrl!) { data, _, error in
            
            if let imageData = data , let image = UIImage(data: imageData) {
                DispatchQueue.main.async{
                    self.myImage.image = image
                }
            }
        }.resume()
        
       
    }
    

    

}
