import UIKit
import PlaygroundSupport

class GraphView : UILabel {

    override func draw(_ rect: CGRect) {

        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 0.5, y: frame.minY + 29.5))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 6.34, y: frame.minY + 23.5), controlPoint1: CGPoint(x: frame.minX + 0.5, y: frame.minY + 29.5), controlPoint2: CGPoint(x: frame.minX + 4, y: frame.minY + 27.69))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 12.19, y: frame.minY + 9.5), controlPoint1: CGPoint(x: frame.minX + 8.01, y: frame.minY + 20.5), controlPoint2: CGPoint(x: frame.minX + 10.67, y: frame.minY + 13.13))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 20.22, y: frame.minY + 0.5), controlPoint1: CGPoint(x: frame.minX + 14.69, y: frame.minY + 3.5), controlPoint2: CGPoint(x: frame.minX + 17.13, y: frame.minY + 0.5))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 32.5, y: frame.minY + 0.5), controlPoint1: CGPoint(x: frame.minX + 27.77, y: frame.minY + 0.5), controlPoint2: CGPoint(x: frame.minX + 27.77, y: frame.minY + 0.5))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 66.5, y: frame.minY + 0.5), controlPoint1: CGPoint(x: frame.minX + 37.22, y: frame.minY + 0.5), controlPoint2: CGPoint(x: frame.minX + 66.5, y: frame.minY + 0.5))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 66.5, y: frame.minY + 29.5))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.5, y: frame.minY + 29.5))
        bezierPath.close()
        UIColor.white.setFill()
        bezierPath.fill()
        UIColor.white.setStroke()
        bezierPath.lineWidth = 1
        super.draw(rect)
    }

}


let graphView = GraphView(frame: CGRect(x: 0,y: 0,width: 78,height: 30))
graphView.backgroundColor = .clear
graphView.text = "  $12.00"
//graphView.textColor = .black
graphView.textAlignment = .center
//graphView.font = UIFont.systemFont(ofSize: 14)

PlaygroundPage.current.liveView = graphView

extension Date {
    var nextThreeDates: [Date] {
        var dates = [Date]()
        for i in 1...3 {
            guard let date = Calendar.current.date(byAdding: .day, value: i, to: self) else { return dates }
            dates.append(date)
        }
        return dates
    }
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

let stringDates = Date().addingTimeInterval(-86400).nextThreeDates.map { $0.toString() }.joined(separator: ",")

print(stringDates)


// Color Declaration

