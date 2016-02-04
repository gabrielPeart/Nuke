// The MIT License (MIT)
//
// Copyright (c) 2016 Alexander Grebenyuk (github.com/kean).

#if os(OSX)
    import Cocoa
#else
    import UIKit
#endif

#if os(watchOS)
    import WatchKit
#endif

/** Decodes data into an image object.
 */
public protocol ImageDecoding {
    /* Decodes data into an image object.
     */
    func decode(data: NSData, response: NSURLResponse?) -> Image?
}

/** Decodes data into an image object. Image scale is set to the scale of the main screen.
 */
public class ImageDecoder: ImageDecoding {
    /** Initializes the receiver.
     */
    public init() {}

    /** Decodes data into an image object using native methods.
    */
    public func decode(data: NSData, response: NSURLResponse?) -> Image? {
        #if os(OSX)
            return NSImage(data: data)
        #else
            return UIImage(data: data, scale: self.imageScale)
        #endif
    }

    #if !os(OSX)
    /** The scale used when creating an image object. Return the scaleM of the main screen.
     */
    public var imageScale: CGFloat {
        #if os(iOS) || os(tvOS)
            return UIScreen.mainScreen().scale
        #else
            return WKInterfaceDevice.currentDevice().screenScale
        #endif
    }
    #endif
}

/** Composes multiple image decoders.
 */
public class ImageDecoderComposition: ImageDecoding {
    /** Image decoders that the receiver was initialized with.
     */
    public let decoders: [ImageDecoding]

    /** Composes multiple image decoders.
     */
    public init(decoders: [ImageDecoding]) {
        self.decoders = decoders
    }

    /** Decoders are applied in an order in which they are present in the decoders array. The decoding stops when one of the decoders produces an image.
     */
    public func decode(data: NSData, response: NSURLResponse?) -> Image? {
        for decoder in self.decoders {
            if let image = decoder.decode(data, response: response) {
                return image
            }
        }
        return nil
    }
}

/** Implements progressive image decoding. Decodes received data at a given thresholds (percentage of total data). If it can't keep up with a rate at which it receives data, it might skip some of the thresholds.
 */
internal class ProgressiveImageDecoder {
    private let decoder: ImageDecoding
    private let queue: NSOperationQueue
    private let threshold: Float
    private let totalBytesCount: Int64
    internal var handler: ((image: Image) -> Void)?

    private var executing = false
    private var decoding = false
    private var decodedByteCount: Int64 = 0
    private let data = NSMutableData()
    private let lock = NSRecursiveLock()

    internal init(decoder: ImageDecoding, queue: NSOperationQueue, threshold: Float, totalBytesCount: Int64) {
        self.decoder = decoder
        self.queue = queue
        self.threshold = threshold
        self.totalBytesCount = totalBytesCount
    }

    internal func append(data: NSData) {

    }

    /** Resumes decoding, safe to be called multiple times.
     */
    internal func resume() {

    }

    internal func invalidate() {

    }
}
