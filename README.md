A pure dart library offering support for netty-like byte buffer manipulation and binary serialization
via a pickle inspired system.

## Features

| Feature                | Status
| :--------------------: | :-----: |
| Buffers                | ✅     |
| Child Buffers          | ✅     |
| Unpooled               | ✅     |
| Pooled                 | ✅     |
| Primitive Datatypes    | ✅     |
| Hex Encoding           | ✅     |
| Base64 Encoding        | ✅     |


## Getting started

After you've imported the library with
```dart
import 'package:duffer/duffer.dart';
```

You can creates buffers via the `Unpooled` and `Pooled`
utility classes and just write to it and read from it
```dart
var buffer = Unpooled.buffer();
buffer.writeLPString("Hello World!");
buffer.writeInt32(42);

print(buffer.readLPString()); // Hello World!
print(buffer.readInt32()); // 42
```

or parse existing data via one of the various extension functions.
```dart
var buffer1 = "SGVsbG8gV29ybGQ=".parseBase64();
var buffer2 = "0000000b48656c6c6f20576f726c64".parseHex();
```

You can also encode your buffer using base64 or hex.
```dart
print(buffer.hex);
print(buffer.base64);
```

For more samples just have a look at the examples folder.
