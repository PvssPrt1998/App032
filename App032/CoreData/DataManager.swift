import Foundation


final class DataManager {
    private let modelName = "DataModel"
    
    lazy var coreDataStack = CoreDataStack(modelName: modelName)
    
    func saveVideoId(_ id: String, isEffect: Bool) {
        let videoId = VideoID(context: coreDataStack.managedContext)
        videoId.videoID = id
        videoId.isEffect = isEffect
        coreDataStack.saveContext()
    }
    
    func fetchVideoIds() throws -> Array<Video> {
        var array: Array<Video> = []
        let ids = try coreDataStack.managedContext.fetch(VideoID.fetchRequest())
        ids.forEach { videoId in
            array.append(Video(id: videoId.videoID, isEffect: videoId.isEffect, url: videoId.url))
        }
        return array
    }
    
    func editVideo(_ id: String, url: String) {
        do {
            let videosCD = try coreDataStack.managedContext.fetch(VideoID.fetchRequest())
            videosCD.forEach { vcd in
                if vcd.videoID == id {
                    vcd.url = url
                }
            }
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func removeVideo(_ id: String) throws {
        let videosCD = try coreDataStack.managedContext.fetch(VideoID.fetchRequest())
        guard let videoCD = videosCD.first(where: {$0.videoID == id}) else { return }
        coreDataStack.managedContext.delete(videoCD)
        coreDataStack.saveContext()
    }
}
