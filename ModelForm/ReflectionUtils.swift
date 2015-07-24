// grabbed from https://gist.github.com/erica/f3aad9e491df716725d3
// Erica Sadun
// MARK: Mirror-based Utilities
// These work across arrays, structures, tuples
// Goatees are mandatory

func mirrorDo<S>(structure:S, closure:(Int, String, Any)->()) {
    let mirror = reflect(structure)
    for index in 0 ..< mirror.count {
        closure(index, mirror[index].0, mirror[index].1.value)
    }
}

func mirrorMap<S>(structure:S, closure:(Int, String, Any)->Any)->[Any]{
    let mirror = reflect(structure)
    var results = [Any]()
    for index in 0 ..< mirror.count {
        let result = closure(index, mirror[index].0, mirror[index].1.value)
        results += [result]
    }
    return results
}

func mirrorToArray<S>(structure:S) -> [Any] {
    return mirrorMap(structure){return $2}
}

func mirrorZipToArray<S, T>(s:S, t:T)->[[Any]] {
    var array = [[Any]]()
    for each in zip(mirrorToArray(s), mirrorToArray(t)) {
        array += [mirrorToArray(each)]
    }
    return array
}


// Examples
/*

// Various test data
var array1 = [1, 2, 3, 4, 5, 8]
var array2 = [9, 2, 2, 47, 59, 8]
var array3 = ["Lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing", "elit"]
let tuple1 = (1, 3, 5, 9, 2)
let tuple2 = ("Ut", "ante", "diam", "faucibus", "sed", "sem", "eu")
let rect = CGRectMake(0, 1, 2, 3)
let point = CGPointMake(2, 3)
let transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))

// Just do something across an array or struct or whatever
mirrorDo(array3){println("fielddo: \($2)")}
println("\n")

// Zip the two items (array or struct or whatever) into arrays
mirrorZipToArray(array3, array2)
mirrorZipToArray(tuple1, tuple2)

// Showcase the params for the do function
for test : Any in [tuple1, rect, point, transform] {
println("TEST:\(test.dynamicType): ")
mirrorDo(test){ (index: Int, field : String, value : Any) -> () in
println("type:\(value.dynamicType), index: \(index), field: \(field), value: \(value)")
}
println("END OF TEST\n")
}
println("")

// Convert something to an array
for test : Any in [tuple1, rect, array2, point, transform] {
println("Converting \(test) to array")
println(mirrorToArray(test))
}

*/