//
//  ViewController.swift
//  NetworkCallWithCoreData
//
//  Created by Refat E Ferdous on 12/4/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var tableView : UITableView!
    var response : [Response] = []
    var modelData = [Products]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "HelperTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let urlString = "https://fakestoreapi.com/products"
        fetchData(with : urlString)
        //getData()
       
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
                
            }catch{
                self.getData()
                print("falied to convert data")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            print(self.response[0].title)
            
        }.resume()
    }
    
    func getData(){
        do {
            modelData = try context.fetch(Products.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch{
            print("could not get any data from database")
        }
    }
    
    func saveData(){
        let newProducts = Products(context: context)
        newProducts.title = response[0].title
        newProducts.price = response[0].price
        newProducts.descrip = response[0].description
        newProducts.category = response[0].category
        newProducts.image = response[0].image
        newProducts.rate = response[0].rating.rate
        newProducts.count = response[0].rating.count
        
        do{
            try context.save()
        }catch{
            
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HelperTableViewCell
        if indexPath.row < response.count{
            cell.id.text = String(response[indexPath.row].id)
            cell.title.text = String(response[indexPath.row].title)
            cell.price.text = String(response[indexPath.row].price)
            cell.des.text = response[indexPath.row].description
            cell.category.text = response[indexPath.row].category
            cell.rate.text = String(response[indexPath.row].rating.rate)
            cell.count.text = String(response[indexPath.row].rating.count)
            //cell.myImage.image = UIImage(String(res[indexPath.row].image))
            cell.myImage.backgroundColor = .red
            //print("executing this block")
        }
        return cell
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
    let count : Double
}

