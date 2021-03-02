//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by SuShenghung on 2021/3/1.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get {
            self.title ?? "Unknown value"
        }
        
        set {
            self.title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? "Unknown value"
        }
        
        set {
            self.subtitle = newValue
        }
    }
}
