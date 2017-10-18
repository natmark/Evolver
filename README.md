![Evolver-Header](https://github.com/natmark/Evolver/blob/master/Resources/Evolver-header.png?raw=true)

<p align="center">
    <a href="https://travis-ci.org/natmark/Evolver">
        <img src="https://travis-ci.org/natmark/Evolver.svg?branch=master"
             alt="Build Status">
    </a>
    <a href="https://cocoapods.org/pods/Evolver">
        <img src="https://img.shields.io/cocoapods/v/Evolver.svg?style=flat"
             alt="Pods Version">
    </a>
    <a href="https://github.com/natmark/Evolver/">
        <img src="https://img.shields.io/cocoapods/p/ProcessingKit.svg?style=flat"
             alt="Platforms">
    </a>
    <a href="https://github.com/apple/swift">
        <img alt="Swift" src="https://img.shields.io/badge/swift-4.0-orange.svg">
    </a>
    <a href="https://github.com/Carthage/Carthage">
        <img src="https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat"
             alt="Carthage Compatible">
    </a>
</p>

# Evolver
Evolver is a Genetic Algorithm library for Swift🐧.

## Usage
The main units of Evolver are `Generable` protocol and `Evolver` class.

1. Create Model conformed to Generable
```Swift
struct Player: Generable {
    var direction = Array(
        repeating: Gene.template(Direction.self, geneSize: Counter(Direction.self).count),
        count: 20
    )
    var action = Array(
        repeating: Gene.template(Action.self, geneSize: Counter(Action.self).count),
        count: 10
    )
}
```
2. Prepare Enumeration conformed to `Int` & `GeneBase`
```Swift
enum Direction: Int, GeneBase {
    case left
    case right
    case up
    case down
}
```
3. Implement Evaluate function
```Swift
func evaluate(model: Player) -> Int {
・・・
}
```
4. Simulate Genetic Algorithm
```Swift
let result = Evolver.run(template: Player.self,
                        generations: 20,
                        individuals: 10,
                        completion: {  model, generation, individual in
    // Implement Evaluate model function    
    let score = self.evaluate(model: model)
    return score
})

switch result {
case .success(let model):
    for direction in model.direction {
        print(direction.value) // You can get enum case
    }
case .failure(let error):
    print(error)
}
```

## Tips
`Evolver` is simulating on main thread default.
Use `DispatchQueue` if you want to running on sub thread.

```Swift
DispatchQueue.global(qos: .userInitiated).async {
    let result = Evolver.run(template: Player.self,
                            generations: 20,
                            individuals: 10,
                            completion: { model, generation, individual in
        let score = self.evaluate(model: model)
        return score
    })
    DispatchQueue.main.async {
        switch result {
        case .success(let model):
            print(model)
        case .failure(let error):
            print(error)
        }
    }
}
```

## Instration

### [CocoaPods](http://cocoadocs.org/docsets/Evolver/)
Add the following to your `Podfile`:
```
  pod "Evolver"
```

### [Carthage](https://github.com/Carthage/Carthage)
Add the following to your `Cartfile`:
```
  github "natmark/Evolver"
```

## License
Evolver is available under the MIT license. See the LICENSE file for more info.
