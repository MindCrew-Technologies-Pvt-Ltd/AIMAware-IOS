import CoreData
import SwiftUI

class ActiveSessionTracker: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    static let shared = ActiveSessionTracker()
    
    @Published var hasActiveSession = false
    @Published var isLeftHand : Bool? = nil
    
    
    /*
    var fetchedResultsController: NSFetchedResultsController<Session>?
    var coreDataManager = CoreDataManager.shared

    override init() {
        super.init()
        setupFetchedResultsController()
    }

    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "endTime == nil")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
        // Configure fetchRequest sort descriptors if needed

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: coreDataManager.viewContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self

        do {
            try fetchedResultsController?.performFetch()
            updateActiveSessionStatus()
        } catch {
            print("Fetch failed")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateActiveSessionStatus()
    }

    private func updateActiveSessionStatus() {
        if let sessions = fetchedResultsController?.fetchedObjects, !sessions.isEmpty {
            hasActiveSession = true
        } else {
            hasActiveSession = false
        }
    }*/
}
