import Foundation
import CoreData


extension VideoID {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VideoID> {
        return NSFetchRequest<VideoID>(entityName: "VideoID")
    }

    @NSManaged public var videoID: String
    @NSManaged public var isEffect: Bool
    @NSManaged public var url: String?
}

extension VideoID : Identifiable {

}
