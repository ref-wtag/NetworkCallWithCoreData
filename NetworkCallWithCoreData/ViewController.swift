//
//  ViewController.swift
//  NetworkCallWithCoreData
//
//  Created by Refat E Ferdous on 12/4/23.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var tableView : UITableView!
    @IBOutlet var activityIndicator : UIActivityIndicatorView!
    
    var response : [Response] = []
    var modelData = [Products]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        
        let nib = UINib(nibName: "HelperTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let urlString = "https://fakestoreapi.com/products"
        fetchData(with : urlString)
       
    }
    
    func fetchData(with url : String){
        guard let url = URL(string : url) else{return}
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                print("something went wrong!")
                return
            }
            
            do{
                self.response = try JSONDecoder().decode([Response].self, from: data)
                self.saveData()
                self.getData()
                
            }catch{
                self.getData()
                print("falied to convert data")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
          //print(self.response[0].title)
         
        }.resume()
    }
    

    func saveData(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do{
            try context.execute(batchDeleteRequest)
            try context.save()
        }
        catch{
            print("no data to delete from database")
        }
        
        
        for i in response{
            let newProducts = Products(context: context)
            newProducts.pId = Int16(i.id)
            newProducts.title = i.title
            newProducts.price = i.price
            newProducts.descrip = i.description
            newProducts.category = i.category
            newProducts.image = i.image
            newProducts.rate = i.rating.rate
            newProducts.count = Int16(i.rating.count)
        }
        do{
            try context.save()
        }catch{
            print("failed to save data")
        }
    }
    
    func getData(){
        do {
            modelData = try context.fetch(Products.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.isHidden = true
            }
        }catch{
            print("could not get any data from database")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = tableView.cellForRow(at: indexPath)
        productDetails(indexPath)
       
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HelperTableViewCell
       
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        debugPrint(path[0])
        print("\n")
        
        if indexPath.row < modelData.count{
            
            cell.id.text =  String(response[indexPath.row].id)
            cell.title.text = response[indexPath.row].title
            cell.price.text = String(response[indexPath.row].price)
            cell.des.text = response[indexPath.row].description
            cell.category.text = response[indexPath.row].category
            cell.rate.text = String(response[indexPath.row].rating.rate)
            cell.count.text = String(response[indexPath.row].rating.count)
            
            let imageUrlString = response[indexPath.row].image
            let imageUrl = URL(string : imageUrlString)
            
            URLSession.shared.dataTask(with: imageUrl!) { data, _ , error in
                if let imageData = data, let image = UIImage(data : imageData){
                    DispatchQueue.main.async {
                        cell.myImage.image = image
                    }
                }
            }.resume()
        }
        return cell
    }
    
    
    func productDetails(_ index : IndexPath){
        
        let vc = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
       
        vc.productTitleVal = response[index.row].title
        vc.priceVal = response[index.row].price
        vc.desVal = response[index.row].description
        vc.rateVal = response[index.row].rating.rate
        vc.countVal = response[index.row].rating.count
        vc.myImageVal = response[index.row].image
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

struct Response : Codable {
    let id : Int
    let title : String
    let price : Double
    let description : String
    let category : String
    let image : String
    let rating : Rating
}

struct Rating : Codable {
    let rate : Double
    let count : Int
}

