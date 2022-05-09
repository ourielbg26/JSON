//
//  ViewController.swift
//  JSON
//
//  Created by Ouriel Bennathan on 31/03/2022.
//

import UIKit
import SVGKit
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    struct Country : Decodable {
        var name = ""
        var code = ""
        var emoji = ""
        var unicode = ""
        var image = ""
    }
    
    var imageView = UIImage()
    var myUrl = "https://cdn.jsdelivr.net/npm/country-flag-emoji-json@2.0.0/dist/index.json"
    var countries = [Country]()
    var countryName = [String]()
    var firstLetter = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        JSONData()
        
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numOfRow = countryName.filter{$0.first == Character (firstLetter[section])}
        return numOfRow.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return firstLetter.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        firstLetter[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell{
            let countrySection = countryName.filter {String($0.prefix(1)) == firstLetter[indexPath.section]}
            let i = getIndex(countrie: countrySection[indexPath.row])
//            loadImageAsync(with: countries[i].image)
//            cell.imageFlag.image = imageView
            cell.imageFlag.loadImageUsingCache(withUrl: countries[i].image)
            cell.countryNameLbl.text = countrySection[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    fileprivate func JSONData(){
        guard let url = URL(string: myUrl) else {return}
        URLSession.shared.dataTask(with: url){
            (data,response,error) in
            if error != nil {
                let myError = error!  as NSError
                print (myError)
            }
            else {
                do {
                    guard let data = data else {return}
                    self.countries = try JSONDecoder().decode([Country].self, from: data)
                    self.arraySort()
                } catch let error as NSError {
                    print (error)
                }
            }
        }.resume()
    }
    
    fileprivate func loadImageAsync(with path: String) {
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: URL(string: path)!)
                if let image = SVGKImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView = image.uiImage
                    }
                }
            } catch {
                print("error is \(error.localizedDescription)")
            }
        }
    }
    
    fileprivate func arraySort(){
        countries = countries.sorted (by: {$0.name.lowercased() < $1.name.lowercased()})
        for country in countries {
            countryName.append(country.name)
            firstLetter.append(String(country.name.prefix(1)))
        }
        firstLetter = [String] (Set(firstLetter).sorted(by: {$0.lowercased() < $1.lowercased()}))
    }
    fileprivate func getIndex(countrie : String)-> Int{
        for i in 0...countries.count{
            if countrie == countries[i].name{return i}
        }
        return 0
    }

}

