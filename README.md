# DynoSwift

DynoSwift is a dynamic typing framework in swift, that allows basic types, commonly found in a language like JavaScript, to be used dynamically in Swift. DynoSwift accomplishes this by the use of enums, which have an enormous amount of features and extensability in the Swift language, like methods, initializers, computed attributes, and subscripts.

### Types

DynoSwift supports the following types:

1. Int
2. String
3. Bool
4. List
5. Map
6. Null

*Note: The list and map types can be nested, they can contain lists of lists or maps of lists.*

## Wrapping and Initialization

To convert a swift type into a DynoSwift type, you can either initialize it via a constructor method, or put it in the appropiate enum case:

```
var a = DynObject.int(6)
print(a)
//"int(6)\n"

var b = DynObject(element:"foo")
print(b)
//"string("foo")\n"
```

Here, element is a general single parameter name. Alternatively, you can initialize a dynoswift list like this:

```
var c = DynObject.list([DynObject.int(8), DynObject.bool(true)])
print(c)

list([DynObject.int(8), DynObject.bool(true)])
```

Maps can also be done in a similar fashion.

## Extracting Swift Types

To get back a swift type form a `DynObject`, you can use one of the computed variables on the enum. If you use a variable to which the internal type of the DynObject does not correspond to, you will get a `DynObject.null` returned. This union acts as a null reference, and prevents the enum from raising errors. Here are a few examples:

```
var a = DynObject(element:5)
print(a.int)
5
print(a.string)
//No contained value
```

## Mutating Contained Values

For easier functionality, DynObject have methods that facilitate changing the internal value without extracting it back out to a Swift type. Some of these methods are only for int cases, but a number of them work elsewhere, such as the `.plus()` method.

```
var a = DynObject(element:5);var b = DynObject(element:9)
print(a.plus(b))
//int(14)
```
The plus method can also work with strings, and lists:

```
var a = DynObject(element:"fooo");var b = DynObject(element:"doom")
print(a.plus(b))
//string("fooodoom")
```

Many other methods exist, such as mul, for continous concatenation of strings, and multiplication of integers:

```
var x = DynObject(element:"x")
x.mul(DynObject(element:5))
//string("xxxxxx")
```

## Distribution

DynoSwift will be available on the swift package manager upon the release of Swift 3. Until then, you can just clone the repo from here.

## License

DynoSwift is MIT licensed and open sourced.
