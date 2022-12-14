//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Jasper on 25/12/2022.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    @Environment(\.undoManager) var undoManager
    
    @State var SelectedEmojis: Set<EmojiArtModel.Emoji.ID> = Set()
    
    @ScaledMetric var defaultEmojiFontSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            PaletteChooser(emojiFontSize: defaultEmojiFontSize)
        }
    }
    
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                OptionalImage(uiImage: document.backgroundImage)
                    .scaleEffect(zoomScale)
                    .position(convertFromEmojiCoordinates((0,0), in: geometry))
                    .gesture(doubleTapToZoom(in: geometry.size).simultaneously(with: tapToUnselectAll()))
                if document.backgroundImageFetchStatus == .fetching {
                    ProgressView().scaleEffect(2.0)
                } else {
                    ForEach(document.emojis) { emoji in
                        Text(emoji.text)
                            .font(.system(size: fontSize(for: emoji)))
                            .selectionEffect(for: emoji, in: SelectedEmojis)
                            .scaleEffect(zoomScale(for: emoji))
                            .position(position(for: emoji, in: geometry))
                            .gesture(selectionGesture(on: emoji).simultaneously(with: panEmojiGesture()).simultaneously(with: longPressDeleteGesture(on: emoji)))
                    }
                }
            }
            .clipped()
            .onDrop(of: [.plainText,.url,.image], isTargeted: nil) { providers, location in
                return drop(providers, at: location, in: geometry)
            }
            .gesture(panGesture().simultaneously(with: SelectedEmojis.isEmpty ? zoomGesture() : nil).simultaneously(with: SelectedEmojis.isEmpty ? nil : zoomEmojisGesture()))
            .alert(item: $alertToShow) { alertToShow in
                alertToShow.alert()
            }
            .onChange(of: document.backgroundImageFetchStatus) { status in
                switch status {
                case .failed(let url):
                    showBackgroundImageFetchFailedAlert(url)
                default: break
                }
            }
            .onReceive(document.$backgroundImage) { image in
                if autozoom {
                    zoomToFit(image, in: geometry.size)
                }
            }
            .compactableToolbar {
                UndoButton(
                    undo: undoManager?.optionalUndoMenuItemTitle,
                    redo: undoManager?.optionalRedoMenuItemTitle
                )
                AnimatedActionButton(title: "Paste Background", systemImage: "doc.on.clipboard") {
                    pasteBackground()
                }
                if Camera.isAvailable {
                    AnimatedActionButton(title: "Take Photo", systemImage: "camera") {
                        backgroundPicker = .camera
                    }
                }
                if PhotoLibrary.isAvailable {
                    AnimatedActionButton(title: "Choose Photo", systemImage: "photo") {
                        backgroundPicker = .library
                    }
                }
                if let undoManager = undoManager {
                    if undoManager.canUndo {
                        AnimatedActionButton(title: undoManager.undoActionName, systemImage: "arrow.uturn.backward") {
                            undoManager.undo()
                        }
                    }
                    if undoManager.canRedo {
                        AnimatedActionButton(title: undoManager.undoActionName, systemImage: "arrow.uturn.forward") {
                            undoManager.redo()
                        }
                    }
                }
            }
            .sheet(item: $backgroundPicker) { pickerType in
                switch pickerType {
                case .camera: Camera(handlePickedImage: { image in handlePickedBackgroundImage(image) })
                case .library: PhotoLibrary(handlePickedImage: { image in handlePickedBackgroundImage(image) })
                }
            }
        }
    }
    
    private func handlePickedBackgroundImage(_ image: UIImage?) {
        autozoom = true
        if let imageData = image?.jpegData(compressionQuality: 1.0) {
            document.setBackground(.imageData(imageData), undoManager: undoManager)
        }
        backgroundPicker = nil
    }
    
    @State private var backgroundPicker: BackgroundPickerType?
    
    enum BackgroundPickerType: Identifiable {
        case camera
        case library
        var id: BackgroundPickerType { self }
    }
    
    private func pasteBackground() {
        autozoom = true
        if let imageData = UIPasteboard.general.image?.jpegData(compressionQuality: 1.0) {
            document.setBackground(.imageData(imageData), undoManager: undoManager)
        } else if let url = UIPasteboard.general.url?.imageURL {
            document.setBackground(.url(url), undoManager: undoManager)
        } else {
            alertToShow = IdentifiableAlert(title: "Paste Background", message: "There is no image currently on the pasteboard")
        }
    }
    
    @State private var autozoom = false
    
    @State private var alertToShow: IdentifiableAlert?
    
    private func showBackgroundImageFetchFailedAlert(_ url: URL) {
        alertToShow = IdentifiableAlert {
            Alert(
                title: Text("Background Image Fetch"),
                message: Text("Couldn't load image from \(url)."),
                dismissButton: Alert.Button.cancel(Text("OK"))
            )
        }
    }
    
    private func drop(_ providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        var found = providers.loadObjects(ofType: URL.self) { url in
            autozoom = true
            document.setBackground(.url(url.imageURL), undoManager: undoManager)
        }
        
        if !found {
            found = providers.loadObjects(ofType: UIImage.self) { image in
                if let data = image.jpegData(compressionQuality: 1.0) {
                    document.setBackground(.imageData(data), undoManager: undoManager)
                }
            }
        }
        
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                if let emoji = string.first, emoji.isEmoji {
                    document.addEmoji(
                        String(emoji),
                        at: convertToEmojiCoordinates(location, in: geometry),
                        size: defaultEmojiFontSize / zoomScale,
                        undoManager: undoManager
                    )
                }
            }
        }
        
        return found
    }
    
    private func borderWidth(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(Double(emoji.size) * 0.05)
    }
    
    private func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
    private func zoomScale(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        SelectedEmojis.isEmpty ? zoomScale : SelectedEmojis.contains(emoji.id) ? zoomScale * zoomEmojiScale : zoomScale
    }
    
    private func position(for emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
        if SelectedEmojis.contains(emoji.id) {
            return convertFromEmojiCoordinates((emoji.x + Int(panEmojiOffset.width), emoji.y + Int(panEmojiOffset.height)), in: geometry)
        } else {
            return convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
        }
    }
    
    private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x + CGFloat(location.x) * zoomScale + panOffset.width,
            y: center.y + CGFloat(location.y) * zoomScale + panOffset.height
        )
    }
    
    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(
            x: (location.x - panOffset.width - center.x) / zoomScale,
            y: (location.y - panOffset.height - center.y) / zoomScale
        )
        return (Int(location.x), Int(location.y))
    }
    
    private func selectionGesture(on emoji: EmojiArtModel.Emoji) -> some Gesture {
        TapGesture(count: 1)
            .onEnded {
                if let index = SelectedEmojis.firstIndex(where: { $0 == emoji.id }) {
                    SelectedEmojis.remove(at: index)
                } else {
                    SelectedEmojis.insert(emoji.id)
                }
            }
    }
    
    @SceneStorage("EmojiArtDocument.steadyPanOffset")
    private var steadyPanOffset: CGSize = CGSize.zero
    @GestureState private var gesturePanOffset: CGSize = CGSize.zero
    
    private var panOffset: CGSize {
        (steadyPanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestsGestureValue, gesturePanOffset, _ in
                gesturePanOffset = latestsGestureValue.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                steadyPanOffset = steadyPanOffset + (finalDragGestureValue.translation / zoomScale)
            }
    }
    
    @State private var steadyEmojiPanOffset: CGSize = CGSize.zero
    @GestureState private var gestureEmojiPanOffset: CGSize = CGSize.zero
    
    private var panEmojiOffset: CGSize {
        (steadyEmojiPanOffset + gestureEmojiPanOffset) * zoomScale
    }
    
    private func panEmojiGesture() -> some Gesture {
        DragGesture()
            .updating($gestureEmojiPanOffset) { latestGestureValue, gestureEmojiPanOffset, _ in
                gestureEmojiPanOffset = latestGestureValue.translation / zoomScale
            }
            .onEnded { finalEmojiDragGestureValue in
                for emoji in document.emojis {
                    if (SelectedEmojis.contains(emoji.id)) {
                        document.moveEmoji(emoji, by: finalEmojiDragGestureValue.translation / zoomScale, undoManager: undoManager)
                    }
                }
                steadyEmojiPanOffset = CGSize.zero
            }
    }
    
    
    @SceneStorage("EmojiArtDocument.steadyZoomScale")
    private var steadyZoomScale: CGFloat = 1
    @GestureState private var gestureZoomScale: CGFloat = 1
    
    private var zoomScale: CGFloat {
        steadyZoomScale * gestureZoomScale
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestsGestureScale, gestureZoomScale, _ in
                gestureZoomScale = latestsGestureScale
            }
            .onEnded { gestureScaleAtEnd in
                steadyZoomScale *= gestureScaleAtEnd
            }
    }
    
    @State private var steadyEmojiScale: CGFloat = 1
    @GestureState private var gestureEmojiScale: CGFloat = 1
    
    private var zoomEmojiScale: CGFloat {
        steadyEmojiScale * gestureEmojiScale
    }
    
    private func zoomEmojisGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureEmojiScale) { latestsGestureScale, gestureEmojiScale, _ in
                gestureEmojiScale = latestsGestureScale
            }
            .onEnded { gestureScaleAtEnd in
                for emoji in document.emojis {
                    if (SelectedEmojis.contains(emoji.id)) {
                        document.scaleEmoji(emoji, by: gestureScaleAtEnd, undoManager: undoManager)
                    }
                }
                steadyEmojiScale = 1
            }
    }
    
    private func tapToUnselectAll() -> some Gesture {
        TapGesture(count: 1)
            .onEnded {
                SelectedEmojis = Set()
            }
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0, size.width > 0, size.height > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyPanOffset = CGSize.zero
            steadyZoomScale = min(hZoom, vZoom)
        }
    }
    
    private func longPressDeleteGesture(on emoji: EmojiArtModel.Emoji) -> some Gesture {
        LongPressGesture(minimumDuration: 1)
            .onEnded { longPressStateAtEnd in
                if longPressStateAtEnd {
                    showDeleteEmojiButton(for: emoji)
                }
            }
    }
    
    private func showDeleteEmojiButton(for emojiToDelete: EmojiArtModel.Emoji) {
        alertToShow = IdentifiableAlert(id: UUID()) {
            Alert(
                 title: Text("Delete \(emojiToDelete.text)"),
                 primaryButton: .destructive(
                     Text("Yes"),
                     action: {
                         if (SelectedEmojis.contains(emojiToDelete.id)) { SelectedEmojis.remove(emojiToDelete.id) }
                         document.removeEmoji(emojiToDelete, undoManager: undoManager)
                     }
                 ),
                 secondaryButton: .cancel(
                     Text("Cancel")
                 )
             )
        }
    }
}




















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let document = EmojiArtDocument()
        EmojiArtDocumentView(document: document)
    }
}
