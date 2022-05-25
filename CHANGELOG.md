## 1.0.0
- Start of the tracked change log

## 1.0.0+1
- Updated the license

## 1.0.1
- Update pubspec.yaml with new description
- Remove unused imports
- Declare missing @override annotations in exceptions.dart
- Improve examples/

# 1.0.2
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