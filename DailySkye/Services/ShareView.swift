import SwiftUI

struct ShareView: View {
    let shareContent: String

    var body: some View {
        ActivityViewController(shareContent: shareContent)
    }
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView(shareContent: "To be or not to be")
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    let shareContent: String
//    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        print("ActivityViewController.makeUIViewController() - activityItems=\([shareContent])")
        let controller = UIActivityViewController(activityItems: [shareContent], applicationActivities: applicationActivities)
        let subject = "A Great Quote"
        controller.setValue(subject, forKey: "subject")
        controller.excludedActivityTypes = [.airDrop, .assignToContact, .saveToCameraRoll, .addToReadingList, .postToVimeo, .postToWeibo, .postToFlickr, .postToFacebook]
//        controller.popoverPresentationController?.sourceView = (sender as! UIButton) // so that iPads won't crash
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}
