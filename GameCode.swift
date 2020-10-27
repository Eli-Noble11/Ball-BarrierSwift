import Foundation
let ball = OvalShape(width: 40, height: 40)

var targets: [Shape] = []


let funnelPoints = [
    Point(x: 0, y: 50 ),
    Point(x: 80, y: 50 ),
    Point(x: 60, y: 0 ),
    Point(x: 20, y: 0 )             ]
let funnel = PolygonShape(points: funnelPoints)

func addTarget(at position: Point) {
    let targetPoints = [
        Point(x:10 , y: 0),
        Point(x: 0 , y: 10),
        Point(x: 10 , y: 20),
        Point(x: 20 , y: 10)
    ]
    
    let target = PolygonShape(points: targetPoints)
    
    targets.append(target)
    
    target.position = position
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = false
    target.fillColor = .yellow
    scene.add(target)
    target.name = "target"
    target.isDraggable = false
}

//Handles collison between ball and targets
func ballcollided(with othershape: Shape) {
    if othershape.name != "target" { return }
    
    othershape.fillColor = .green
}

/*
The setup() function is called once when the app launches. Without it, your app won't compile.
Use it to set up and start your app.

You can create as many other functions as you want, and declare variables and constants,
at the top level of the file (outside any function). You can't write any other kind of code,
for example if statements and for loops, at the top level; they have to be written inside
of a function.
*/

fileprivate func setupball() {
    // Adds a cirlce to the scene
    ball.position = Point(x: 250, y:400)
    scene.add(ball)
    ball.hasPhysics = true
    ball.fillColor = .blue
    ball.onCollision = ballcollided(with:)
    ball.isDraggable = false
    scene.trackShape(ball)
    ball.onExitedScene = ballExcitedScene
    ball.onTapped = resetGame
    ball.bounciness = 0.6
}

fileprivate func addbarrier(at position: Point,
    width: Double, height: Double, angle: Double) {
    
    let barrierPoints = [
        Point(x: 0, y: 0),
        Point(x: 0, y: height),
        Point(x: width, y: height),
        Point(x: width, y: 0)
    ]
    let barrier = PolygonShape(points:barrierPoints)
    
    barriers.append(barrier)
    
    // Adds a barrier to the scene.
    barrier.position = position
    barrier.hasPhysics = true
    scene.add(barrier)
    barrier.isImmobile = true
    barrier.fillColor = .brown
    barrier.isDraggable = false
    barrier.angle = angle
}

fileprivate func setupfunnel() {
    //adds funnel to the scene.
    funnel.position = Point(x: 200, y: scene.height - 25)
    scene.add(funnel)
    funnel.onTapped = dropball
    funnel.fillColor = .red
    funnel.isDraggable = false
}

func setup() {
    setupball()
    
    addbarrier(at: Point(x: 200, y: 120), width: 90, height: 20, angle: 0.2)
    
    addbarrier(at: Point(x: 100, y: 40), width: 70, height: 20, angle: 0.5)
    
    addbarrier(at: Point(x: 40, y: 60), width: 100, height: 20, angle: -0.3)
    
    setupfunnel()
    
    // Add a target scene.
    addTarget(at: Point(x:34, y: 345))
    addTarget(at: Point(x: 191, y: 420))
    addTarget(at: Point (x:301, y:537))
    
    resetGame()
    
    scene.onShapeMoved = printPosition(of:)
}

//Drops ball by moving to the funnels position
func dropball() {
    ball.position = funnel.position
    ball.stopAllMotion()
    
    for barrier in barriers {
        barrier.isDraggable = false
    }
    for target in targets {
        if target.fillColor == .yellow {
        }
    }
}

func ballExcitedScene() {
    for barrier in barriers {
        barrier.isDraggable = true
        
    var hitTargets = 0
    for target in targets {
            if target.fillColor == .green {
                hitTargets += 1
            }
        }
        if hitTargets == targets.count{
            print("Won game!")
            
        }
    
    }
}


// Resets the game by moving the ball below the scene,
// which will unlock the barriers

func resetGame() {
    ball.position = Point(x: 0, y: -80)
}

func printPosition(of shape: Shape) {
    print(shape.position)
}

var barriers: [Shape] = []
