//
//  CoreDataManager.swift
//  LetsEat
//
//  Created by Craig Clayton on 7/28/17.
//  Copyright © 2017 Cocoa Academy. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    let container:NSPersistentContainer
    
    override init() {
        container = NSPersistentContainer(name: "LetsEatModel")
        container.loadPersistentStores { (storeDesc, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
        }
        
        super.init()
    }
    
    func fetchReviews(by identifier:Int) -> [ReviewItem] {
        let moc = container.viewContext
        let request:NSFetchRequest<Review> = Review.fetchRequest()
        let predicate = NSPredicate(format: "restaurantID = %i", Int32(identifier))
        
        var items:[ReviewItem] = []
        
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.predicate = predicate
        
        do {
            for data in try moc.fetch(request) {
                items.append(ReviewItem(data: data))
            }
            
            return items
            
        } catch {
            fatalError("Failed to fetch reviews: \(error)")
        }
    }
    
    func fetchPhotos(by identifier:Int) -> [RestaurantPhotoItem] {
        let moc = container.viewContext
        let request:NSFetchRequest<RestaurantPhoto> = RestaurantPhoto.fetchRequest()
        let predicate = NSPredicate(format: "restaurantID = %i", Int32(identifier))
        
        var items:[RestaurantPhotoItem] = []
        
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.predicate = predicate
        
        do {
            for data in try moc.fetch(request) {
                items.append(RestaurantPhotoItem(data: data))
            }
            
            return items
            
        } catch {
            fatalError("Failed to fetch reviews: \(error)")
        }
    }
    
    
    func addReview(_ item:ReviewItem) {
        let review = Review(context: container.viewContext)
        if let rating = item.rating { review.rating = rating }
        review.name = item.name
        review.date = Date()
        review.title = item.title
        review.customerReview = item.customerReview
        review.uuid = item.uuid
        
        if let id = item.restaurantID {
            review.restaurantID = Int32(id)
            print("restaurant id \(id)")
            save()
        }
    }
    
    func addPhoto(_ item:RestaurantPhotoItem) {
        let photo = RestaurantPhoto(context: container.viewContext)
        photo.date = Date()
        photo.photo = item.photoData as Data
        photo.uuid = item.uuid
        
        if let id = item.restaurantID {
            photo.restaurantID = Int32(id)
            print("restaurant id \(id)")
            save()
        }
    }
    
    func fetchRestaurantRating(by identifier:Int) -> Float {
        let reviews = fetchReviews(by: identifier).map({ $0 })
        let sum = reviews.reduce(0, {$0 + ($1.rating ?? 0)})
        
        return sum / Float(reviews.count)
    }
    
    
    private func save() {
        do {
            if container.viewContext.hasChanges {
                try container.viewContext.save()
                print("saved")
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
}
