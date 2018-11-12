import UIKit
// Color palette

extension UIColor {
    
    @nonobjc class var paleLavender: UIColor {
        return UIColor(red: 235.0 / 255.0, green: 233.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dusk36: UIColor {
        return UIColor(red: 84.0 / 255.0, green: 76.0 / 255.0, blue: 99.0 / 255.0, alpha: 0.36)
    }
    
    @nonobjc class var dusk: UIColor {
        return UIColor(red: 84.0 / 255.0, green: 76.0 / 255.0, blue: 99.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var wisteria: UIColor {
        return UIColor(red: 166.0 / 255.0, green: 163.0 / 255.0, blue: 175.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var lightGrayBG: UIColor {
        return UIColor(red: 246 / 255.0, green: 245.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var purpleyGrey: UIColor {
        return UIColor(red: 137.0 / 255.0, green: 130.0 / 255.0, blue: 148.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var turquoiseBlue: UIColor {
        return UIColor(red: 0.0, green: 178.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0)
    }
}

// Text styles

extension UIFont {
    
    class var OMPHeader: UIFont {
        return UIFont.systemFont(ofSize: 18.0, weight: .bold)
    }
    
    class var OMPTitle: UIFont {
        return UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    }
    
    class var OMPSubTitle: UIFont {
        return UIFont.systemFont(ofSize: 12.0, weight: .regular)
    }
    
    class var OMPDescription: UIFont {
        return UIFont.systemFont(ofSize: 22.0, weight: .regular)
    }
    
}

// Border and Shadow

extension CALayer {
    
    func addBorderAndShadow() {
        self.do {
            $0.cornerRadius = 4
            $0.shadowColor = UIColor.dusk.cgColor
            $0.shadowOffset = CGSize(width: 0, height: 3.0)
            $0.shadowRadius = 2.0
            $0.shadowOpacity = 0.2
            $0.masksToBounds = false
        }
    }
    
}
