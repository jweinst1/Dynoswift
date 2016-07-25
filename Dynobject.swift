enum DynObject {
    
    case int(Int)
    case string(String)
    case bool(Bool)
    indirect case list([DynObject])
    indirect case map([String:DynObject])
    case null
    
    //escape variables if the coretype needs to be extracted
    var int:Int {
        switch self {
        case .int(let int):
            return int
        default:
            return 0
        }
    }
    //extracted String type, returns empty string by default.
    var string:String {
        switch self {
        case .string(let string):
            return string
        default:
            return ""
        }
    }
    //extracted Bool type, returns false by default
    var bool:Bool {
        switch self {
        case .bool(let bool):
            return bool
        default:
            return false
        }
    }
    //extracted list type, returns empty list by default
    var list:[DynObject] {
        switch self {
        case .list(let list):
            return list
        default:
            return [DynObject]()
        }
    }
    //extracted map type, returns empty map by default
    var map:[String:DynObject] {
        switch self {
        case .map(let map):
            return map
        default:
            return [String:DynObject]()
        }
    }
    //computed variable to check if dynobject is null
    var isNull:Bool {
        switch self {
        case.null:
            return true
        default:
            return false
        }
    }
    
    
    //multiple initializers for fast wrapping
    init(element:Int) {
        self = DynObject.int(element)
    }
    
    init(element:String) {
        self = DynObject.string(element)
    }
    
    init(element:Bool) {
        self = DynObject.bool(element)
    }
    
    init(element:[DynObject] = [DynObject]()) {
        self = DynObject.list(element)
    }
    
    init(element:[String:DynObject] = [String:DynObject]()) {
        self = DynObject.map(element)
    }
    //basic subscripting for setting and getting items
    subscript(index:DynObject) -> DynObject {
        get {
            switch self {
            case .list(let list):
                switch index {
                case.int(let int):
                    if int >= 0 && int < list.count {
                        return list[int]
                    }
                    else {
                        return DynObject.null
                    }
                default:
                    return DynObject.null
                }
            case.string(let string):
                switch index {
                case .int(let int):
                    if int >= 0 && int < string.characters.count {
                        return DynObject(element:String(Array(string.characters)[int]))
                    }
                    else {
                        return DynObject.null
                    }
                default:
                    return DynObject.null
                }
            case .map(let map):
                switch index {
                case .string(let string):
                    if let value = map[string] {
                        return value
                    }
                    else {
                        return DynObject.null
                    }
                default:
                    return DynObject.null
                }
            default:
                return DynObject.null
            }
        }
        //setter subscript implemented for lists so far
        set(newvalue) {
            switch self {
            case .list(var list):
                switch index {
                case .int(let int):
                    if int >= 0 && int < list.count {
                        list[int] = newvalue
                    }
                default:
                    break
                }
            case .map(var map):
                switch index {
                case .string(let string):
                    map[string] = newvalue
                    self = DynObject(element:map)
                default:
                    break
                }
            default:
                break
            }
        }
    }
    //transform the dynobject to a string-dynobject type
    //converts ints, bools or lists
    mutating func toString() {
        switch self {
        case .int(let int):
            self = DynObject(element:String(int))
        case .bool(let bool):
            self = DynObject(element:String(bool))
        case .string( _):
            break
        case .list(let list):
            var newstr = "["
            for var member in list {
                member.toString()
                newstr += member.string + ", "
            }
            newstr += "]"
            self = DynObject(element:newstr)
        case .null:
            self = DynObject(element:"null")
        default:
            break
        }
    }
    
    //appends an element if the dynobject is a list
    mutating func append(element:DynObject) {
        switch self {
        case .list(var list):
            switch element {
            case .int(let elem):
                list.append(DynObject(element: elem))
            case .string(let elem):
                list.append(DynObject(element: elem))
            case .bool(let elem):
                list.append(DynObject(element: elem))
            case .list(let elem):
                list.append(DynObject(element: elem))
            case .map(let elem):
                list.append(DynObject(element: elem))
            case .null:
                list.append(DynObject.null)
            }
        default:
            break
        }
    }
    //adds two dyno objects together
    func plus(element:DynObject) -> DynObject {
        switch self {
        case .int(let int):
            switch element {
            case .int(let other):
                return DynObject(element: int + other)
            default:
                return DynObject.null
            }
        case .string(let string):
            switch element {
            case .string(let other):
                return DynObject(element: string + other)
            default:
                return DynObject.null
            }
        case .list(let list):
            switch element {
            case .list(let other):
                return DynObject(element: list + other)
            default:
                return DynObject.null
            }
        default:
            return DynObject.null
        }
    }
    
    //subtraction method, only works for ints
    func sub(element:DynObject) -> DynObject {
        switch self {
        case .int(let int):
            switch element {
            case .int(let other):
                return DynObject(element:int - other)
            default:
                return DynObject.null
            }
        default:
            return DynObject.null
        }
    }
    //multiplies ints and extends strings by self
    func mul(element:DynObject) -> DynObject {
        switch self {
        case .int(let int):
            switch element {
            case .int(let other):
                return DynObject(element:int * other)
            default:
                return DynObject.null
            }
        case .string(let string):
            switch element {
            case .int(let other):
                var str_temp = string
                for _ in 0..<other {
                    str_temp += str_temp
                }
                return DynObject(element:str_temp)
            default:
                return DynObject.null
            }
        default:
            return DynObject.null
        }
    }
    //division operator for integers
    func div(element:DynObject) -> DynObject {
        switch self {
        case .int(let int):
            switch element {
            case .int(let other):
                return DynObject(element:int / other)
            default:
                return DynObject.null
            }
        default:
            return DynObject.null
        }
    }
    //remainder method for integers
    func rem(element:DynObject) -> DynObject {
        switch self {
        case .int(let int):
            switch element {
            case .int(let other):
                return DynObject(element:int % other)
            default:
                return DynObject.null
            }
        default:
            return DynObject.null
        }
    }
}