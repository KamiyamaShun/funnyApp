//
//  ViewController.swift
//  funnyApp
//
//  Created by 神山駿 on 2021/02/16.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import Photos

class ViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var search: UITextField!
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.cornerRadius = 20.0
        PHPhotoLibrary.requestAuthorization{(status) in
            switch(status){
            case .authorized: break
            case .denied: break
            case .notDetermined: break
            case .restricted: break
            case .limited:break
            @unknown default: break
            }
        }
        getImage(keyword: "funny")
    }

    func getImage(keyword:String){
        let url = "https://pixabay.com/api/?key=20291175-d03b317b44f181fec5945ecfb&q=\(keyword)"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{
            (response)in
            switch response.result{
            case .success:
                let json:JSON = JSON(response.data as Any)
                var imageString = json["hits"][self.count]["webformatURL"].string
                
                if imageString == nil{
                    imageString = json["hits"][0]["webformatURL"].string
                    
                    self.imageView.sd_setImage(with: URL(string: imageString!), completed: nil)
                }else{
                    self.imageView.sd_setImage(with: URL(string: imageString!), completed: nil)
                }
                
            case .failure(let error):
                print("error")
                
            }
        }
    }


    @IBAction func next(_ sender: Any) {
        count += 1
        
        if search.text == ""{
        getImage(keyword: "funny")
        
        }else{
            getImage(keyword: search.text!)
        }
    
}

    @IBAction func search(_ sender: Any) {
        self.count = 0
        
        if search.text == ""{
        getImage(keyword: "funny")
        
        }else{
            getImage(keyword: search.text!)
        }
    }
    
    @IBAction func done(_ sender: Any) {
        performSegue(withIdentifier: "next", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let shareVC = segue.destination as? ShareViewController
        
        shareVC?.commentString = textView.text
        shareVC?.resultImage = imageView.image!
    }
}
