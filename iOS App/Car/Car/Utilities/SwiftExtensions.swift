//
//  SwiftExtensions.swift
//  SwiftExtensions
//
//  Created by Manas Sharma on 11/09/19.
//  Copyright © 2019 Manas. All rights reserved.
//

import UIKit

extension String {
    
    /// Validates a string using regular expression.
    var isValidEmailAddress : Bool {
        get{
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: self)
        }
    }
    
    private func replace(string: String, replacement: String) -> String {
        return replacingOccurrences(of: string, with: replacement, options: .literal, range: nil)
    }
    
    /// Removes white spaces from a string.
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}

extension UIView {
    
    /// Sets corner radius of a view to the provided value and sets `clipsToBounds` to `true`.
    func setCornerRadius(_ radius: Int){
        clipsToBounds = true
        layer.cornerRadius = CGFloat(radius)
    }
    
    /// Sets corner radius of a view to the provided value and sets `clipsToBounds` to `true`.
    func setCornerRadius(_ radius: CGFloat){
        clipsToBounds = true
        layer.cornerRadius = radius
    }
    
    /// Add multiple subviews.
    func addSubviews(_ views: UIView...){
        views.forEach { (view) in
            addSubview(view)
        }
    }
    
    /// Sets translatesAutoresizingMaskIntoConstraints to the provided value.
    var useAutoLayout : Bool {
        get{
            return translatesAutoresizingMaskIntoConstraints
        }
        set{
            translatesAutoresizingMaskIntoConstraints = !newValue
        }
    }
    
    /// Gives the view a circular shape, returns if the height and width of the view are not equal.
    func roundView(){
        if frame.size.width == frame.size.height || heightAnchor == widthAnchor {
            clipsToBounds = true
            layer.cornerRadius = frame.size.width/2
        }else { return }
    }
    
    /// Sets border color of a view.
    func setBorderColor(_ color: UIColor){
        layer.borderColor = color.cgColor
    }
    
    /// Sets border width of a view.
    func setBorderWidth(_ width: CGFloat){
        layer.borderWidth = width
    }
    
    /// Sets border width of a view.
    func setBorderWidth(_ width: Int){
        layer.borderWidth = CGFloat(width)
    }
    
    /// Returns subviews.count .
    var subviewsCount : Int {
        get {
            return subviews.count
        }
    }
    
    /// Removes all constraints from a view.
    func removeAllConstraints(){
        constraints.forEach { (constraint) in
            removeConstraint(constraint)
        }
    }
    
    /// Shakes the view. Pass translation "x" to shake the view horizontally. Pass translation "y" to shake the view vertically.
    func shake(translation: String = "x"){
        if translation == "x" || translation == "y"{
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.\(translation)")
            animation.timingFunction = CAMediaTimingFunction(name: .linear)
            animation.duration = 0.5
            animation.values = [-18.0, 18.0, -18.0, 18.0, -10.0, 10.0, -5.0, 5.0, 0.0]
            layer.add(animation, forKey: nil)
        }
    }
    
    /// Shrinks and expands the view for 0.2 seconds.
    func shrinkAndExpand(withScaleX x: CGFloat = 0.90, withScaleY y: CGFloat = 0.90, completionHandler completion: (() -> Void)? = nil){
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: x, y: y)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = .identity
            },completion: {
                (_) in
                completion?()
            })
        }
    }
    
    /// Pushes from bottom.
    func bottomAnimation(duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = duration
        animation.type = .push
        animation.subtype = .fromTop
        layer.add(animation, forKey: nil)
    }
    
    /// Pushes from top.
    func topAnimation(duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = duration
        animation.type = .push
        animation.subtype = .fromBottom
        layer.add(animation, forKey:  nil)
    }
    
    /// Adds a flash animation to the view's layer.
    func flash(){
        let pulseAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        layer.add(pulseAnimation, forKey: nil)
    }
    
    /// Pins edges of the view to it's superview. Returns if no superview is found.
    func pinEdgesToSuperview(
        leftPadding left: CGFloat = 0,
        paddingRight right: CGFloat = 0,
        paddingTop top: CGFloat = 0,
        paddingBottom bottom: CGFloat = 0
    ){
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: superview.leftAnchor, constant: left),
            rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -right),
            topAnchor.constraint(equalTo: superview.topAnchor, constant: top),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom)
        ])
    }
    
    /// Centers the view. Returns if no superview is found.
    func centerInSuperview(withHeightConstant height: CGFloat, withWidthConstant width: CGFloat){
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: 0),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: 0),
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height)
        ])
    }
}

extension UIViewController {
    
    func async(block: @escaping () -> Void){
        DispatchQueue.main.async {
            block()
        }
    }
    
    /// Checks validity of the text fields and returns a boolean value.
    func checkValidityOfTextFields(_ textFields: UITextField...) -> Bool{
        for field in textFields {
            if !field.isValid(){
                return false
            }
        }
        return true
    }
    
    func showErrorMessage(withText text: String =  "An error occurred"){
        
        removeAllErrorMessages()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            let messageView = UIView()
            messageView.tag = 666
            messageView.alpha = 0
            messageView.backgroundColor = .red
            messageView.setCornerRadius(5)
            messageView.translatesAutoresizingMaskIntoConstraints = false
            
            let messageLabel = UILabel()
            messageLabel.backgroundColor = .clear
            messageLabel.text = text
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.textColor = .black
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.font = UIFont(name: "Avenir-Heavy", size: 15)!
            
            self.view.addSubview(messageView)
            messageView.addSubview(messageLabel)
            
            let topConstraint =  messageView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: -55)
            
            NSLayoutConstraint.activate([
                topConstraint,
                messageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16) ,
                messageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16) ,
                messageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 55) ,
                messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 8),
                messageLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -8),
                messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 8),
                messageLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -8)
            ])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                topConstraint.constant = 8
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                    messageView.alpha = 1
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                topConstraint.constant = -55
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                    messageView.alpha = 0
                }) { (_) in
                    self.view.viewWithTag(666)?.removeFromSuperview()
                    self.view.viewWithTag(999)?.removeFromSuperview()
                }
            }
        }
    }
    
    func showSuccessMessage(withText text: String =  "Task completed successfully"){
        
        removeAllErrorMessages()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            let messageView = UIView()
            messageView.tag = 999
            messageView.alpha = 0
            messageView.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            messageView.setCornerRadius(5)
            messageView.translatesAutoresizingMaskIntoConstraints = false
            
            let messageLabel = UILabel()
            messageLabel.backgroundColor = .clear
            messageLabel.text = text
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.textColor = .white
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.font = UIFont(name: "Avenir-Heavy", size: 15)!
            
            self.view.addSubview(messageView)
            messageView.addSubview(messageLabel)
            
            let topConstraint =  messageView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: -55)
            
            NSLayoutConstraint.activate([
                topConstraint,
                messageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16) ,
                messageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16) ,
                messageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 55) ,
                messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 8),
                messageLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -8),
                messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 8),
                messageLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -8)
            ])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                topConstraint.constant = 8
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                    messageView.alpha = 1
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                topConstraint.constant = -55
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                    messageView.alpha = 0
                }) { (_) in
                    self.view.viewWithTag(666)?.removeFromSuperview()
                    self.view.viewWithTag(999)?.removeFromSuperview()
                }
            }
        }
    }
    
    /// Removes all Progress HUD views.
    private func removeAllErrorMessages(){
        UIView.animate(withDuration: 0.3, animations: {
            self.view.viewWithTag(666)?.alpha = 0
            self.view.viewWithTag(999)?.alpha = 0
        }){ (_) in
            self.view.viewWithTag(666)?.removeFromSuperview()
            self.view.viewWithTag(999)?.removeFromSuperview()
        }
    }
    
    /// Presents a UIAlertController Alert with a cancel button and a custom button.
    func showTwoOptionsAlert(title: String?, message: String?, buttonStyle: UIAlertAction.Style, buttonTitle: String, block: (()->Void)?){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: buttonStyle) { (action) in
            block?()
            alert.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert,animated: true)
    }
    
    /// Presents a UIAlertController Alert with a custom button.
    func showSingleOptionAlert(title: String?, message: String?, buttonStyle: UIAlertAction.Style, buttonTitle: String, block: (()->Void)?){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: buttonStyle) { (action) in
            block?()
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert,animated: true)
    }
    
    /// Presents a UIAlertController Action Sheet with a cancel button and two custom buttons.
    func showThreeOptionsActionSheet(title: String?, message: String?, buttonOneStyle: UIAlertAction.Style, buttonOneTitle: String, buttonOneBlock: (()->Void)?, buttonTwoStyle: UIAlertAction.Style, buttonTwoTitle: String, buttonTwoBlock: (()->Void)?){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let buttonOne = UIAlertAction(title: buttonOneTitle, style: buttonOneStyle) { (action) in
            buttonOneBlock?()
            alert.dismiss(animated: true)
        }
        
        let buttonTwo = UIAlertAction(title: buttonTwoTitle, style: buttonTwoStyle) { (action) in
            buttonTwoBlock?()
            alert.dismiss(animated: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(buttonOne)
        alert.addAction(buttonTwo)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
}

extension UITableView {
    
    enum Position {
        case top
        case bottom
    }
    
    /// Scrolls the table view.
    func scroll(to: Position, animated: Bool) {
        let sections = numberOfSections
        let rows = numberOfRows(inSection: numberOfSections - 1)
        switch to {
        case .top:
            if rows > 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                self.scrollToRow(at: indexPath, at: .top, animated: animated)
            }
            break
        case .bottom:
            if rows > 0 {
                let indexPath = IndexPath(row: rows - 1, section: sections - 1)
                self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
            break
        }
    }
}

extension UITextField {
    
    func setLeftView(image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 5, y: 10, width: 18, height: 20)) // set your Own size
        iconView.image = image
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 40))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
    func setRightView(image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: -10, y: 10, width: 45, height: 25)) // set your Own size
        iconView.image = image
        iconView.contentMode = .scaleAspectFit
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        iconContainerView.addSubview(iconView)
        rightView = iconContainerView
        rightViewMode = .always
    }
    
    /// Validates text field's text and returns a boolean value.
    func isValid() -> Bool {
        return text != nil && !text!.isEmpty && text != "" && text!.count != 0 && !text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && hasText
    }
}

extension UITextView  {
    
    /// Validates text view's text and returns a boolean value.
    func isValid() -> Bool {
        return text != nil && !text!.isEmpty && text != "" && text!.count != 0 && !text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && hasText
    }
}

extension String {
    /// Validates a string and returns a boolean value.
    var isValid : Bool {
        get{
            return !isEmpty && self != "" && count != 0 && !trimmingCharacters(in: .whitespacesAndNewlines).isEmpty 
        }
    }
}

extension Collection {
    
    /// Prints all the elements in the collection in a formatted manner.
    func printAll(){
        for (i,j) in enumerated() {
            print("\n\n\(i):  \(j)")
        }
    }
}

extension Date {
    
    /// 1 - Sunday, 2 - Monday, 3 - Tuesday, 4 - Wednesday,5 - Thursday, 6 - Friday, 7 - Saturday.
    static func getDayNameFromDateNumber(_ number: Int) -> String {
        switch number {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return "No day"
        }
    }
    
    static func customDateFromString(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: string) ?? Date()
    }
    
    static func getTimeTextfromTimeInterval(timeInterval: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        let fullDate = Date(timeIntervalSince1970: timeInterval)
        let now = Date()
        let difference = now.timeIntervalSince1970-timeInterval
        var dateText = dateFormatter.string(from: fullDate)
        if difference <= 60 {
            dateText = "Now"
        } else if difference > 60 && difference <= 3600 {
            let n = Int(difference) / 60
            dateText = "\(n)m"
        } else if difference > 3600 && difference <= 3600*6 {
            let n = Int(difference) / 3600
            dateText = "\(n)h"
        } else if Calendar.current.isDate(fullDate, inSameDayAs:now) {
            dateText = "Today"
        } else if Calendar.current.isDate(Calendar.current.date(byAdding:.hour, value: -24, to: now)!, inSameDayAs:fullDate) {
            dateText = "Yesterday"
        }
        return dateText
    }
    
    
    /// 0..<12 returns Good Morning, 12..<17 returns Good Afternoon, 17...23 returns Good Evening.
    static func getCurrentTimeWithMessage(defaultMessage message: String?) -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        switch hour {
        case 0..<12 : return "Good Morning"
        case 12..<17 : return "Good Afternoon"
        case 17...23 : return "Good Evening"
        default : return message ?? "Hello There!"
        }
    }
    
    /// Returns a tuple with hour, minute and second.
    static func getCurrentTime() -> (hour: Int,minute: Int,second: Int) {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        let time = (hour: hour, minute: minute, second: second)
        return time
    }
}

extension UIAlertController {
    
    /// Add multiple UIAlertActions.
    func addActions(_ actions: UIAlertAction...){
        actions.forEach { (action) in
            addAction(action)
        }
    }
}

struct Platform {}

extension Platform {
    
    enum platforms {
        case simulator
        case physicalPhone
    }
    
    enum OSs {
        case iOS
        case tvOS
        case Linux
        case macOS
        case iPadOS
        case watchOS
    }
    
    static var deviceType : platforms {
        #if targetEnvironment(simulator)
        return .simulator
        #else
        return .physicalPhone
        #endif
    }
    
    static var OSType : OSs {
        #if os(iOS)
        return .iOS
        #elseif os(tvOS)
        return .tvOS
        #elseif os(watchOS)
        return .watchOS
        #elseif os(macOS)
        return .macOS
        #elseif os(Linux)
        return .Linux
        #endif
    }
    
    static func isRunningSwift5OrLater() -> Bool {
        #if swift(>=5.0)
        return true
        #else
        return false
        #endif
    }
    
    static func currentThread() -> Thread {
        return Thread.current
    }
    
    static func isMainThread() -> Bool {
        return Thread.isMainThread
    }
    
    static func isMultiThread() -> Bool {
        return Thread.isMultiThreaded()
    }
    
    static func currentThermalState() -> ProcessInfo.ThermalState {
        return ProcessInfo.processInfo.thermalState
    }
}

extension Double {
    
    /// Converts Degrees to Radians
    static func convertDegreesToRadians(_ number: Double) -> Double {
        return number * .pi / 180
    }
}

extension String {
    
    func estimatedFrameForRect(_ text: String) -> CGRect {
        let size = CGSize(width: 300, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)], context: nil)
    }
}

extension UITabBarController {
    /**
     Show or hide the tab bar.
     - Parameter hidden: `true` if the bar should be hidden.
     - Parameter animated: `true` if the action should be animated.
     - Parameter transitionCoordinator: An optional `UIViewControllerTransitionCoordinator` to perform the animation
     along side with. For example during a push on a `UINavigationController`.
     */
    func setTabBar(
        hidden: Bool,
        animated: Bool = true,
        along transitionCoordinator: UIViewControllerTransitionCoordinator? = nil
    ) {
        guard isTabBarHidden != hidden else { return }
        let offsetY = hidden ? tabBar.frame.height : -tabBar.frame.height
        let endFrame = tabBar.frame.offsetBy(dx: 0, dy: offsetY)
        let vc: UIViewController? = viewControllers?[selectedIndex]
        var newInsets: UIEdgeInsets? = vc?.additionalSafeAreaInsets
        let originalInsets = newInsets
        newInsets?.bottom -= offsetY
        /// Helper method for updating child view controller's safe area insets.
        func set(childViewController cvc: UIViewController?, additionalSafeArea: UIEdgeInsets) {
            cvc?.additionalSafeAreaInsets = additionalSafeArea
            cvc?.view.setNeedsLayout()
        }
        // Update safe area insets for the current view controller before the animation takes place when hiding the bar.
        if hidden, let insets = newInsets { set(childViewController: vc, additionalSafeArea: insets) }
        guard animated else {
            tabBar.frame = endFrame
            return
        }
        // Perform animation with coordinato if one is given. Update safe area insets _after_ the animation is complete,
        // if we're showing the tab bar.
        weak var tabBarRef = self.tabBar
        if let tc = transitionCoordinator {
            tc.animateAlongsideTransition(in: self.view, animation: { _ in tabBarRef?.frame = endFrame }) { context in
                if !hidden, let insets = context.isCancelled ? originalInsets : newInsets {
                    set(childViewController: vc, additionalSafeArea: insets)
                }
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: { tabBarRef?.frame = endFrame }) { didFinish in
                if !hidden, didFinish, let insets = newInsets {
                    set(childViewController: vc, additionalSafeArea: insets)
                }
            }
        }
    }
    /// `true` if the tab bar is currently hidden.
    var isTabBarHidden: Bool {
        return !tabBar.frame.intersects(view.frame)
    }
}

extension Double {
    
    func convertDate() -> String {
        var string = ""
        let date: Date = Date(timeIntervalSince1970: self)
        let calendrier = Calendar.current
        let formatter = DateFormatter()
        if calendrier.isDateInToday(date) {
            string = ""
            formatter.timeStyle = .short
        } else if calendrier.isDateInYesterday(date) {
            string = "Yesterday: "
            formatter.timeStyle = .short
        } else {
            formatter.dateStyle = .short
        }
        let dateString = formatter.string(from: date)
        return string + dateString
    }
}

extension UIImage {
    
    /// Adds a tint to UIImageView.
    func tint(with color: UIColor) -> UIImage {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIApplicationDelegate {
    
    /// Instantiates initial view controller of a storyboard.
    func instantiateInitialViewController(withStoryboardName name: String,withBundle bundle: Bundle = .main) -> UIViewController? {
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        return storyboard.instantiateInitialViewController()
    }
}

extension UserDefaults {
    
    /// Get color using User Defaults.
    func color(forKey key: String) -> UIColor? {
        
        guard let colorData = data(forKey: key) else { return nil }
        
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch {
            return nil
        }
    }
    
    /// Save color using User Defaults.
    func set(_ value: UIColor?, forKey key: String) {
        
        guard let color = value else { return }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch {}
    }
    
    /// Detects if app is running for the first time. Uses key "isFirstLaunch".
    static func isFirstLaunch() -> Bool {
        let firstLaunch = !(UserDefaults.standard.bool(forKey: "isFirstLaunch"))
        if firstLaunch {
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        }
        return firstLaunch
    }
    
    /// Increments number of times user has opened the app. Uses key "numberOfTimesUserHasOpenedTheApplication".
    static func incrementNumberOfTimesUserHasOpenedTheApplication(){
        let numberOfTimes = UserDefaults.standard.integer(forKey: "numberOfTimesUserHasOpenedTheApplication") + 1
        UserDefaults.standard.set(numberOfTimes, forKey: "numberOfTimesUserHasOpenedTheApplication")
    }
    
    /// Returns number of times user has opened the app. Uses key "numberOfTimesUserHasOpenedTheApplication".
    static func numberOfTimesUserHasOpenedTheApplication() -> Int {
        return UserDefaults.standard.integer(forKey: "numberOfTimesUserHasOpenedTheApplication")
    }
    
    /// Resets number of times user has opened the app. Uses key "numberOfTimesUserHasOpenedTheApplication".
    static func resetNumberOfTimesUserHasOpenedTheApplication(){
        UserDefaults.standard.set(0, forKey: "numberOfTimesUserHasOpenedTheApplication")
    }
}

extension Bundle {
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version : String = dictionary["CFBundleName"] as? String {
            return version
        } else {
            return ""
        }
    }
}

extension UIWindow {
    convenience init(rootViewController aRootViewController: UIViewController) {
        self.init(frame: UIScreen.main.bounds)
        rootViewController = aRootViewController
        makeKeyAndVisible()
    }
}

extension UIApplication {
    func openSettings(){
        open(URL(string: UIApplication.openSettingsURLString)!, options: [:])
    }
}

extension UIButton {
    func underline() {
        guard let title = titleLabel else { return }
        guard let tittleText = title.text else { return }
        let attributedString = NSMutableAttributedString(string: (tittleText))
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: (tittleText.count)))
        setAttributedTitle(attributedString, for: .normal)
    }
}

extension UILabel {
    func underline() {
        if let textString = text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: textString.count))
            attributedText = attributedString
        }
    }
}

extension Optional {
    var isNil: Bool {
        switch self {
        case .none:
            return true
        default:
            return false
        }
    }
}

extension UIViewController {
    
    func showSpinner(withColor color: UIColor = .gray){
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = color
        spinner.tag = 555
        view.addSubview(spinner)
        spinner.centerInSuperview(withHeightConstant: 0, withWidthConstant: 0)
        spinner.startAnimating()
    }
    
    func hideSpinner(){
        (view.viewWithTag(555) as! UIActivityIndicatorView).stopAnimating()
        view.viewWithTag(555)?.removeFromSuperview()
    }
}
