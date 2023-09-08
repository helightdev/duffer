## 2.3.1

 - **REFACTOR**: reformat code and fix some style issues.

## 2.3.0

> Note: This release has breaking changes.

 - Decided against a mayor release because the change should not affact many use-cases.

 - **FIX**: remove unexpected behaviour which sets the max capacity to the initial capacity if specified.
 - **DOCS**: add missing documentation.
 - **DOCS**: add a load of new documentation.
 - **BREAKING** **REFACTOR**: use Uint8List instead of List<int> and use a wrapped buffer for parseHex().

## 2.2.0

 - **REFACTOR**: optimize indexOf a bit and add more comments.
 - **FEAT**: add ByteBuf.indexOf.

## 2.1.0

 - **FEAT**: add basic support for int64 on web using fixnum and approximated ints.

## 2.0.1

 - **FIX**: melos project structure.

## 1.0.0
- Start of the tracked change log

## 1.0.0+1
- Updated the license

## 1.0.1
- Update pubspec.yaml with new description
- Remove unused imports
- Declare missing @override annotations in exceptions.dart
- Improve examples/

## 1.0.2
- Improve examples/
- Add documentation
- Add peakAvailableBytes
- Update encodings to use peakAvailableBytes
- Make iterator use writer index instead of the buffer capacity since this would be unexpected for the user

## 1.1.0
- Replace getBuffer with viewBuffer and add new getBuffer function which expands the resulting buffers
  index constraints
- Replace setByte with updateByte and add new setByte which increments the writerIndex to fit
  the operation 
- Index based operations now also increment the writerIndex  
- Replaced the iterator with the list view 
- Add documentation
- Add option to toggle index based Readability Validation which is now on by default
- Updated tests to match the new mechanics

## 1.1.1
- kAlwaysCheckReadIndices as global replacement for validateIndices

## 1.2.0
- Performance Optimizations
- Buffer growth now expands a bit more than requested if possible to increase performance for frequent write
- kMaxGrowth sets the upper "overgrowth" limit
- Added ArrayBuffer as a replacement for HeapBuffer which is faster
- Renamed HeapBuffer to ByteDataBuffer

## 1.2.1
- Add more polymorphic pickle serializers
- Add Pickler for basic types and primitives
- Add PicklerRegistry and static 'pickles' field
- Add readLPBuffer
- Add writeLPBuffer
- Add placeholder for the shift extension
- Add example for using the pickler
- Update README.md
- Update EXAMPLES.md

## 1.2.2
- Make ImmutableListView use getters for buffer fields to stay up to date
  Note: Will later be renamed to ReadOnlyListView

## 1.2.3
- Add logo :)

## 1.2.4
- Add global default endianness variable kEndianness
- Add nullable optional endianness option to all relevant read/write and get/set methods
- Added read/write methods for interacting with signed and unsigned bytes

## 1.2.5
- Add get/set methods for interacting with signed and unsigned bytes
- Updated docs for changed methods
- Reformatted source-code

## 1.2.6
- Add methods for reading/writing and getting/setting booleans
- Add write/read nullable
- Add Streamed buffer wrapper
- Add more sizes in the Size utility class
- Update docs for a few methods

## 2.0.0
- Set methods no longer increment the writer index
- Get methods don't check buffer readability anymore and use assertWritable (Bounds Check)
- Add experimental RandomAccessFileByteBuf 