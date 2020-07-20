//
//  TableViewCell.swift
//  InterviewTask
//
//  Created by Admin on 18/07/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData


class TableViewCell: UITableViewCell {
      
    // create a uielements
    var factsImageView = UIImageView()
    var factsTitle = UILabel()
    var factsDescription = UILabel()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(factsImageView)
        addSubview(factsTitle)
        addSubview(factsDescription)
        configurationLable()
        configurationImageview()
        setImageConstraint()
        setTitleLableConstraints()
        setDescriptionLableConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(row:Rows){
        factsTitle.text        = row.title ?? "-"
        factsDescription.text  = row.description ?? "-"
        if Reachability.isConnectedToNetwork(){
            factsImageView.sd_setImage(with: URL(string:row.imageHref ?? "" ), placeholderImage: UIImage(named: "defaultImg.png")) { (image, error, cacheType, url) in
                
                let context = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
                if self.someEntityExists(titleString: row.title ?? ""){
                    print("added")
                }
                else
                {
                    // Saving a value to core data
                    let entity = NSEntityDescription.entity(forEntityName: "Interview", in: context)
                    let eachInterview = Interview(entity: entity!, insertInto: context)
                    let urlOfImage = self.saveImagesToFileManager(imageReceived: self.factsImageView.image!, name: self.factsTitle.text!)
                    eachInterview.titlestring = row.title ?? "-"
                    eachInterview.descriptionstring =  row.description ?? "-"
                    eachInterview.imagePath = urlOfImage
                    print(urlOfImage)
                    do {
                        try context.save()
                        
                    } catch let error as NSError {
                        print(error.description)
                    }
                }
            }
        }else{
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            var fileName = row.title ?? ""
            fileName += ".jpg"
            // create the destination file url to save your image
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            print(fileURL)
            let image    = UIImage(contentsOfFile: fileURL.path)
            factsImageView.image = image
            
        }
        
        
    }
    
    func someEntityExists(titleString: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Interview")
        fetchRequest.predicate = NSPredicate(format: "titlestring = %@", titleString)
        let context = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
        var results: [NSManagedObject] = []
        do {
            results = try context.fetch(fetchRequest)
            //            print(results)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
    }
    
    func saveImagesToFileManager(imageReceived : UIImage, name : String) -> String {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = name + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = imageReceived.jpegData(compressionQuality:  1.0),
            !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
                print("file saved")
                return fileURL.absoluteString
            } catch {
                print("error saving file:", error)
            }
        }
        return ""
    }
    
    func configurationImageview(){
        factsImageView.layer.cornerRadius = 5
        factsImageView.clipsToBounds      = true
    }
    func configurationLable(){
        factsDescription.numberOfLines    = 0
        factsTitle.numberOfLines          = 0
    }
    func setImageConstraint(){
        factsImageView.translatesAutoresizingMaskIntoConstraints  = false
        // factsImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        factsImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        factsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        factsImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        factsImageView.widthAnchor.constraint(equalToConstant: 100).isActive  = true
    }
    func setTitleLableConstraints(){
        factsTitle.translatesAutoresizingMaskIntoConstraints  = false
        factsTitle.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        factsTitle.leadingAnchor.constraint(equalTo: factsImageView.trailingAnchor, constant: 8).isActive = true
        factsTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        
    }
    func setDescriptionLableConstraints(){
        factsDescription.translatesAutoresizingMaskIntoConstraints    = false
        factsDescription.topAnchor.constraint(equalTo: factsTitle.bottomAnchor, constant: 8).isActive = true
        factsDescription.leadingAnchor.constraint(equalTo: factsTitle.leadingAnchor).isActive = true
        factsDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        factsDescription.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        factsDescription.heightAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true
    }
    
}
