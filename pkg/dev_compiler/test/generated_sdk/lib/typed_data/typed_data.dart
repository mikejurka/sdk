// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dart.typed_data;

import 'dart:collection';
import 'dart:_internal' show FixedLengthListMixin;
import 'dart:_internal';
import 'dart:math' as Math;

/**
 * A sequence of bytes underlying a typed data object.
 * Used to process large quantities of binary or numerical data
 * more efficiently using a typed view.
 */
abstract class ByteBuffer {
  /**
   * Returns the length of this byte buffer, in bytes.
   */
  int get lengthInBytes;

  /**
   * Creates a new [Uint8List] view of this buffer.
   */
  Uint8List asUint8List([int offsetInBytes = 0, int length]);
  /**
   * Creates a new [Int8List] view of this buffer.
   */
  Int8List asInt8List([int offsetInBytes = 0, int length]);
  /**
   * Creates a new [Uint8Clamped] view of this buffer.
   */
  Uint8ClampedList asUint8ClampedList([int offsetInBytes = 0, int length]);
  /**
   * Creates a new [Uint16List] view of this buffer.
   */
  Uint16List asUint16List([int offsetInBytes = 0, int length]);
  /**
   * Creates a new [Int16List] view of this buffer.
   */
  Int16List asInt16List([int offsetInBytes = 0, int length]);
  /**
   * Creates a new [Uint32List] view of this buffer.
   */
  Uint32List asUint32List([int offsetInBytes = 0, int length]);
  /**
   * Creates a new [Int32List] view of this buffer.
   */
  Int32List asInt32List([int offsetInBytes = 0, int length]);
  /**
   * Creates a new [Uint64List] view of this buffer.
   */
  Uint64List asUint64List([int offsetInBytes = 0, int length]);
  /**
   * Creates a new [Int64List] view of this buffer.
   */
  Int64List asInt64List([int offsetInBytes = 0, int length]);
  /**
   * Creates a new [Int32x4List] view of this buffer.
   */
  Int32x4List asInt32x4List([int offsetInBytes = 0, int length]);
  /**
   * Creates a new [Float32List] view of this buffer.
   */
  Float32List asFloat32List([int offsetInBytes = 0, int length]);
  /**
   * Creates a new [Float64List] view of this buffer.
   */
  Float64List asFloat64List([int offsetInBytes = 0, int length]);
  /**
   * Creates a new [Float32x4List] view of this buffer.
   */
  Float32x4List asFloat32x4List([int offsetInBytes = 0, int length]);
  /**
   * Creates a new [Float64x2List] view of this buffer.
   */
  Float64x2List asFloat64x2List([int offsetInBytes = 0, int length]);
  /**
   * Creates a new [ByteData] view of this buffer.
   */
  ByteData asByteData([int offsetInBytes = 0, int length]);
}


/**
 * A typed view of a sequence of bytes.
 */
abstract class TypedData {
  /**
   * Returns the number of bytes in the representation of each element in this
   * list.
   */
  int get elementSizeInBytes;

  /**
   * Returns the offset in bytes into the underlying byte buffer of this view.
   */
  int get offsetInBytes;

  /**
   * Returns the length of this view, in bytes.
   */
  int get lengthInBytes;

  /**
   * Returns the byte buffer associated with this object.
   */
  ByteBuffer get buffer;
}


/**
 * Describes endianness to be used when accessing or updating a
 * sequence of bytes.
 */
class Endianness {
  const Endianness._(this._littleEndian);

  static const Endianness BIG_ENDIAN = const Endianness._(false);
  static const Endianness LITTLE_ENDIAN = const Endianness._(true);
  static final Endianness HOST_ENDIAN =
    (new ByteData.view(new Uint16List.fromList([1]).buffer)).getInt8(0) == 1 ?
    LITTLE_ENDIAN : BIG_ENDIAN;

  final bool _littleEndian;
}


/**
 * A fixed-length, random-access sequence of bytes that also provides random
 * and unaligned access to the fixed-width integers and floating point
 * numbers represented by those bytes.
 * ByteData may be used to pack and unpack data from external sources
 * (such as networks or files systems), and to process large quantities
 * of numerical data more efficiently than would be possible
 * with ordinary [List] implementations. ByteData can save space, by
 * eliminating the need for object headers, and time, by eliminating the
 * need for data copies. Finally, ByteData may be used to intentionally
 * reinterpret the bytes representing one arithmetic type as another.
 * For example this code fragment determine what 32-bit signed integer
 * is represented by the bytes of a 32-bit floating point number:
 *
 *     var buffer = new Uint8List(8).buffer;
 *     var bdata = new ByteData.view(buffer);
 *     bdata.setFloat32(0, 3.04);
 *     int huh = bdata.getInt32(0);
 */
abstract class ByteData implements TypedData {
  @patch factory ByteData(int length) = NativeByteData;

  /**
   * Creates an [ByteData] _view_ of the specified region in the specified
   * byte buffer. Changes in the [ByteData] will be visible in the byte
   * buffer and vice versa. If the [offsetInBytes] index of the region is not
   * specified, it defaults to zero (the first byte in the byte buffer).
   * If the length is not specified, it defaults to null, which indicates
   * that the view extends to the end of the byte buffer.
   *
   * Throws [RangeError] if [offsetInBytes] or [length] are negative, or
   * if [offsetInBytes] + ([length] * elementSizeInBytes) is greater than
   * the length of [buffer].
   */
  factory ByteData.view(ByteBuffer buffer,
                        [int offsetInBytes = 0, int length]) {
    return buffer.asByteData(offsetInBytes, length);
  }

  /**
   * Returns the (possibly negative) integer represented by the byte at the
   * specified [byteOffset] in this object, in two's complement binary
   * representation. The return value will be between -128 and 127, inclusive.
   *
   * Throws [RangeError] if [byteOffset] is negative, or
   * greater than or equal to the length of this object.
   */
  int getInt8(int byteOffset);

  /**
   * Sets the byte at the specified [byteOffset] in this object to the
   * two's complement binary representation of the specified [value], which
   * must fit in a single byte. In other words, [value] must be between
   * -128 and 127, inclusive.
   *
   * Throws [RangeError] if [byteOffset] is negative, or
   * greater than or equal to the length of this object.
   */
  void setInt8(int byteOffset, int value);

  /**
   * Returns the positive integer represented by the byte at the specified
   * [byteOffset] in this object, in unsigned binary form. The
   * return value will be between 0 and 255, inclusive.
   *
   * Throws [RangeError] if [byteOffset] is negative, or
   * greater than or equal to the length of this object.
   */
  int getUint8(int byteOffset);

  /**
   * Sets the byte at the specified [byteOffset] in this object to the
   * unsigned binary representation of the specified [value], which must fit
   * in a single byte. in other words, [value] must be between 0 and 255,
   * inclusive.
   *
   * Throws [RangeError] if [byteOffset] is negative,
   * or greater than or equal to the length of this object.
   */
  void setUint8(int byteOffset, int value);

  /**
   * Returns the (possibly negative) integer represented by the two bytes at
   * the specified [byteOffset] in this object, in two's complement binary
   * form.
   * The return value will be between 2<sup>15</sup> and 2<sup>15</sup> - 1,
   * inclusive.
   *
   * Throws [RangeError] if [byteOffset] is negative, or
   * `byteOffset + 2` is greater than the length of this object.
   */
  int getInt16(int byteOffset, [Endianness endian = Endianness.BIG_ENDIAN]);

  /**
   * Sets the two bytes starting at the specified [byteOffset] in this
   * object to the two's complement binary representation of the specified
   * [value], which must fit in two bytes. In other words, [value] must lie
   * between 2<sup>15</sup> and 2<sup>15</sup> - 1, inclusive.
   *
   * Throws [RangeError] if [byteOffset] is negative, or
   * `byteOffset + 2` is greater than the length of this object.
   */
  void setInt16(int byteOffset,
                int value,
                [Endianness endian = Endianness.BIG_ENDIAN]);

  /**
   * Returns the positive integer represented by the two bytes starting
   * at the specified [byteOffset] in this object, in unsigned binary
   * form.
   * The return value will be between 0 and  2<sup>16</sup> - 1, inclusive.
   *
   * Throws [RangeError] if [byteOffset] is negative, or
   * `byteOffset + 2` is greater than the length of this object.
   */
  int getUint16(int byteOffset, [Endianness endian = Endianness.BIG_ENDIAN]);

  /**
   * Sets the two bytes starting at the specified [byteOffset] in this object
   * to the unsigned binary representation of the specified [value],
   * which must fit in two bytes. in other words, [value] must be between
   * 0 and 2<sup>16</sup> - 1, inclusive.
   *
   * Throws [RangeError] if [byteOffset] is negative, or
   * `byteOffset + 2` is greater than the length of this object.
   */
  void setUint16(int byteOffset,
                 int value,
                 [Endianness endian = Endianness.BIG_ENDIAN]);

  /**
   * Returns the (possibly negative) integer represented by the four bytes at
   * the specified [byteOffset] in this object, in two's complement binary
   * form.
   * The return value will be between 2<sup>31</sup> and 2<sup>31</sup> - 1,
   * inclusive.
   *
   * Throws [RangeError] if [byteOffset] is negative, or
   * `byteOffset + 4` is greater than the length of this object.
   */
  int getInt32(int byteOffset, [Endianness endian = Endianness.BIG_ENDIAN]);

  /**
   * Sets the four bytes starting at the specified [byteOffset] in this
   * object to the two's complement binary representation of the specified
   * [value], which must fit in four bytes. In other words, [value] must lie
   * between 2<sup>31</sup> and 2<sup>31</sup> - 1, inclusive.
   *
   * Throws [RangeError] if [byteOffset] is negative, or
   * `byteOffset + 4` is greater than the length of this object.
   */
  void setInt32(int byteOffset,
                int value,
                [Endianness endian = Endianness.BIG_ENDIAN]);

  /**
   * Returns the positive integer represented by the four bytes starting
   * at the specified [byteOffset] in this object, in unsigned binary
   * form.
   * The return value will be between 0 and  2<sup>32</sup> - 1, inclusive.
   *
   * Throws [RangeError] if [byteOffset] is negative, or
   * `byteOffset + 4` is greater than the length of this object.
   */
  int getUint32(int byteOffset, [Endianness endian = Endianness.BIG_ENDIAN]);

  /**
   * Sets the four bytes starting at the specified [byteOffset] in this object
   * to the unsigned binary representation of the specified [value],
   * which must fit in four bytes. in other words, [value] must be between
   * 0 and 2<sup>32</sup> - 1, inclusive.
   *
   * Throws [RangeError] if [byteOffset] is negative, or
   * `byteOffset + 4` is greater than the length of this object.
   */
  void setUint32(int byteOffset,
                 int value,
                 [Endianness endian = Endianness.BIG_ENDIAN]);

  /**
   * Returns the (possibly negative) integer represented by the eight bytes at
   * the specified [byteOffset] in this object, in two's complement binary
   * form.
   * The return value will be between 2<sup>63</sup> and 2<sup>63</sup> - 1,
   * inclusive.
   *
   * Throws [RangeError] if [byteOffset] is negative, or
   * `byteOffset + 8` is greater than the length of this object.
   */
  int getInt64(int byteOffset, [Endianness endian = Endianness.BIG_ENDIAN]);

  /**
   * Sets the eight bytes starting at the specified [byteOffset] in this
   * object to the two's complement binary representation of the specified
   * [value], which must fit in eight bytes. In other words, [value] must lie
   * between 2<sup>63</sup> and 2<sup>63</sup> - 1, inclusive.
   *
   * Throws [RangeError] if [byteOffset] is negative, or
   * `byteOffset + 8` is greater than the length of this object.
   */
  void setInt64(int byteOffset,
                int value,
                [Endianness endian = Endianness.BIG_ENDIAN]);

  /**
   * Returns the positive integer represented by the eight bytes starting
   * at the specified [byteOffset] in this object, in unsigned binary
   * form.
   * The return value will be between 0 and  2<sup>64</sup> - 1, inclusive.
   *
   * Throws [RangeError] if [byteOffset] is negative, or
   * `byteOffset + 8` is greater than the length of this object.
   */
  int getUint64(int byteOffset, [Endianness endian = Endianness.BIG_ENDIAN]);

  /**
   * Sets the eight bytes starting at the specified [byteOffset] in this object
   * to the unsigned binary representation of the specified [value],
   * which must fit in eight bytes. in other words, [value] must be between
   * 0 and 2<sup>64</sup> - 1, inclusive.
   *
   * Throws [RangeError] if [byteOffset] is negative, or
   * `byteOffset + 8` is greater than the length of this object.
   */
  void setUint64(int byteOffset,
                 int value,
                 [Endianness endian = Endianness.BIG_ENDIAN]);

  /**
   * Returns the floating point number represented by the four bytes at
   * the specified [byteOffset] in this object, in IEEE 754
   * single-precision binary floating-point format (binary32).
   *
   * Throws [RangeError] if [byteOffset] is negative, or
   * `byteOffset + 4` is greater than the length of this object.
   */
  double getFloat32(int byteOffset,
                    [Endianness endian = Endianness.BIG_ENDIAN]);

  /**
   * Sets the four bytes starting at the specified [byteOffset] in this
   * object to the IEEE 754 single-precision binary floating-point
   * (binary32) representation of the specified [value].
   *
   * **Note that this method can lose precision.** The input [value] is
   * a 64-bit floating point value, which will be converted to 32-bit
   * floating point value by IEEE 754 rounding rules before it is stored.
   * If [value] cannot be represented exactly as a binary32, it will be
   * converted to the nearest binary32 value.  If two binary32 values are
   * equally close, the one whose least significant bit is zero will be used.
   * Note that finite (but large) values can be converted to infinity, and
   * small non-zero values can be converted to zero.
   *
   * Throws [RangeError] if [byteOffset] is negative, or
   * `byteOffset + 4` is greater than the length of this object.
   */
  void setFloat32(int byteOffset,
                  double value,
                  [Endianness endian = Endianness.BIG_ENDIAN]);

  /**
   * Returns the floating point number represented by the eight bytes at
   * the specified [byteOffset] in this object, in IEEE 754
   * double-precision binary floating-point format (binary64).
   *
   * Throws [RangeError] if [byteOffset] is negative, or
   * `byteOffset + 8` is greater than the length of this object.
   */
  double getFloat64(int byteOffset,
                    [Endianness endian = Endianness.BIG_ENDIAN]);

  /**
   * Sets the eight bytes starting at the specified [byteOffset] in this
   * object to the IEEE 754 double-precision binary floating-point
   * (binary64) representation of the specified [value].
   *
   * Throws [RangeError] if [byteOffset] is negative, or
   * `byteOffset + 8` is greater than the length of this object.
   */
  void setFloat64(int byteOffset,
                  double value,
                  [Endianness endian = Endianness.BIG_ENDIAN]);
}


/**
 * A fixed-length list of 8-bit signed integers.
 * For long lists, this implementation can be considerably
 * more space- and time-efficient than the default [List] implementation.
 */
abstract class Int8List implements List<int>, TypedData {
  @patch factory Int8List(int length) = NativeInt8List;

  @patch factory Int8List.fromList(List<int> elements) =
      NativeInt8List.fromList;

  /**
   * Creates an [Int8List] _view_ of the specified region in the specified
   * byte buffer. Changes in the [Int8List] will be visible in the byte
   * buffer and vice versa. If the [offsetInBytes] index of the region is not
   * specified, it defaults to zero (the first byte in the byte buffer).
   * If the length is not specified, it defaults to null, which indicates
   * that the view extends to the end of the byte buffer.
   *
   * Throws [RangeError] if [offsetInBytes] or [length] are negative, or
   * if [offsetInBytes] + ([length] * elementSizeInBytes) is greater than
   * the length of [buffer].
   */
  factory Int8List.view(ByteBuffer buffer,
                        [int offsetInBytes = 0, int length]) {
    return buffer.asInt8List(offsetInBytes, length);
  }

  static const int BYTES_PER_ELEMENT = 1;
}


/**
 * A fixed-length list of 8-bit unsigned integers.
 * For long lists, this implementation can be considerably
 * more space- and time-efficient than the default [List] implementation.
 */
abstract class Uint8List implements List<int>, TypedData {
  @patch factory Uint8List(int length) = NativeUint8List;

  @patch factory Uint8List.fromList(List<int> elements) =
      NativeUint8List.fromList;

  /**
   * Creates a [Uint8List] _view_ of the specified region in the specified
   * byte buffer. Changes in the [Uint8List] will be visible in the byte
   * buffer and vice versa. If the [offsetInBytes] index of the region is not
   * specified, it defaults to zero (the first byte in the byte buffer).
   * If the length is not specified, it defaults to null, which indicates
   * that the view extends to the end of the byte buffer.
   *
   * Throws [RangeError] if [offsetInBytes] or [length] are negative, or
   * if [offsetInBytes] + ([length] * elementSizeInBytes) is greater than
   * the length of [buffer].
   */
  factory Uint8List.view(ByteBuffer buffer,
                         [int offsetInBytes = 0, int length]) {
    return buffer.asUint8List(offsetInBytes, length);
  }

  static const int BYTES_PER_ELEMENT = 1;
}


/**
 * A fixed-length list of 8-bit unsigned integers.
 * For long lists, this implementation can be considerably
 * more space- and time-efficient than the default [List] implementation.
 * Indexed store clamps the value to range 0..0xFF.
 */
abstract class Uint8ClampedList implements List<int>, TypedData {
  @patch factory Uint8ClampedList(int length) = NativeUint8ClampedList;

  @patch factory Uint8ClampedList.fromList(List<int> elements) =
      NativeUint8ClampedList.fromList;

  /**
   * Creates a [Uint8ClampedList] _view_ of the specified region in the
   * specified byte [buffer]. Changes in the [Uint8List] will be visible in the
   * byte buffer and vice versa. If the [offsetInBytes] index of the region is
   * not specified, it defaults to zero (the first byte in the byte buffer).
   * If the length is not specified, it defaults to null, which indicates that
   * the view extends to the end of the byte buffer.
   *
   * Throws [RangeError] if [offsetInBytes] or [length] are negative, or
   * if [offsetInBytes] + ([length] * elementSizeInBytes) is greater than
   * the length of [buffer].
   */
  factory Uint8ClampedList.view(ByteBuffer buffer,
                                [int offsetInBytes = 0, int length]) {
    return buffer.asUint8ClampedList(offsetInBytes, length);
  }

  static const int BYTES_PER_ELEMENT = 1;
}


/**
 * A fixed-length list of 16-bit signed integers that is viewable as a
 * [TypedData]. For long lists, this implementation can be considerably
 * more space- and time-efficient than the default [List] implementation.
 */
abstract class Int16List implements List<int>, TypedData {
  @patch factory Int16List(int length) = NativeInt16List;

  @patch factory Int16List.fromList(List<int> elements) =
      NativeInt16List.fromList;

  /**
   * Creates an [Int16List] _view_ of the specified region in the specified
   * byte buffer. Changes in the [Int16List] will be visible in the byte
   * buffer and vice versa. If the [offsetInBytes] index of the region is not
   * specified, it defaults to zero (the first byte in the byte buffer).
   * If the length is not specified, it defaults to null, which indicates
   * that the view extends to the end of the byte buffer.
   *
   * Throws [RangeError] if [offsetInBytes] or [length] are negative, or
   * if [offsetInBytes] + ([length] * elementSizeInBytes) is greater than
   * the length of [buffer].
   *
   * Throws [ArgumentError] if [offsetInBytes] is not a multiple of
   * [BYTES_PER_ELEMENT].
   */
  factory Int16List.view(ByteBuffer buffer,
                         [int offsetInBytes = 0, int length]) {
    return buffer.asInt16List(offsetInBytes, length);
  }

  static const int BYTES_PER_ELEMENT = 2;
}


/**
 * A fixed-length list of 16-bit unsigned integers that is viewable as a
 * [TypedData]. For long lists, this implementation can be considerably
 * more space- and time-efficient than the default [List] implementation.
 */
abstract class Uint16List implements List<int>, TypedData {
  @patch factory Uint16List(int length) = NativeUint16List;

  @patch factory Uint16List.fromList(List<int> elements) =
      NativeUint16List.fromList;

  /**
   * Creates a [Uint16List] _view_ of the specified region in
   * the specified byte buffer. Changes in the [Uint16List] will be
   * visible in the byte buffer and vice versa. If the [offsetInBytes] index
   * of the region is not specified, it defaults to zero (the first byte in
   * the byte buffer). If the length is not specified, it defaults to null,
   * which indicates that the view extends to the end of the byte buffer.
   *
   * Throws [RangeError] if [offsetInBytes] or [length] are negative, or
   * if [offsetInBytes] + ([length] * elementSizeInBytes) is greater than
   * the length of [buffer].
   *
   * Throws [ArgumentError] if [offsetInBytes] is not a multiple of
   * [BYTES_PER_ELEMENT].
   */
  factory Uint16List.view(ByteBuffer buffer,
                          [int offsetInBytes = 0, int length]) {
    return buffer.asUint16List(offsetInBytes, length);
  }

  static const int BYTES_PER_ELEMENT = 2;
}


/**
 * A fixed-length list of 32-bit signed integers that is viewable as a
 * [TypedData]. For long lists, this implementation can be considerably
 * more space- and time-efficient than the default [List] implementation.
 */
abstract class Int32List implements List<int>, TypedData {
  @patch factory Int32List(int length) = NativeInt32List;

  @patch factory Int32List.fromList(List<int> elements) =
      NativeInt32List.fromList;

  /**
   * Creates an [Int32List] _view_ of the specified region in the specified
   * byte buffer. Changes in the [Int32List] will be visible in the byte
   * buffer and vice versa. If the [offsetInBytes] index of the region is not
   * specified, it defaults to zero (the first byte in the byte buffer).
   * If the length is not specified, it defaults to null, which indicates
   * that the view extends to the end of the byte buffer.
   *
   * Throws [RangeError] if [offsetInBytes] or [length] are negative, or
   * if [offsetInBytes] + ([length] * elementSizeInBytes) is greater than
   * the length of [buffer].
   *
   * Throws [ArgumentError] if [offsetInBytes] is not a multiple of
   * [BYTES_PER_ELEMENT].
   */
  factory Int32List.view(ByteBuffer buffer,
                         [int offsetInBytes = 0, int length]) {
    return buffer.asInt32List(offsetInBytes, length);
  }

  static const int BYTES_PER_ELEMENT = 4;
}


/**
 * A fixed-length list of 32-bit unsigned integers that is viewable as a
 * [TypedData]. For long lists, this implementation can be considerably
 * more space- and time-efficient than the default [List] implementation.
 */
abstract class Uint32List implements List<int>, TypedData {
  @patch factory Uint32List(int length) = NativeUint32List;

  @patch factory Uint32List.fromList(List<int> elements) =
      NativeUint32List.fromList;

  /**
   * Creates a [Uint32List] _view_ of the specified region in
   * the specified byte buffer. Changes in the [Uint32] will be
   * visible in the byte buffer and vice versa. If the [offsetInBytes] index
   * of the region is not specified, it defaults to zero (the first byte in
   * the byte buffer). If the length is not specified, it defaults to null,
   * which indicates that the view extends to the end of the byte buffer.
   *
   * Throws [RangeError] if [offsetInBytes] or [length] are negative, or
   * if [offsetInBytes] + ([length] * elementSizeInBytes) is greater than
   * the length of [buffer].
   *
   * Throws [ArgumentError] if [offsetInBytes] is not a multiple of
   * [BYTES_PER_ELEMENT].
   */
  factory Uint32List.view(ByteBuffer buffer,
                          [int offsetInBytes = 0, int length]) {
    return buffer.asUint32List(offsetInBytes, length);
  }

  static const int BYTES_PER_ELEMENT = 4;
}


/**
 * A fixed-length list of 64-bit signed integers that is viewable as a
 * [TypedData]. For long lists, this implementation can be considerably
 * more space- and time-efficient than the default [List] implementation.
 */
abstract class Int64List implements List<int>, TypedData {
  @patch factory Int64List(int length) {
    throw new UnsupportedError("Int64List not supported by dart2js.");
  }

  @patch factory Int64List.fromList(List<int> elements) {
    throw new UnsupportedError("Int64List not supported by dart2js.");
  }

  /**
   * Creates an [Int64List] _view_ of the specified region in the specified
   * byte buffer. Changes in the [Int64List] will be visible in the byte buffer
   * and vice versa. If the [offsetInBytes] index of the region is not
   * specified, it defaults to zero (the first byte in the byte buffer).
   * If the length is not specified, it defaults to null, which indicates that
   * the view extends to the end of the byte buffer.
   *
   * Throws [RangeError] if [offsetInBytes] or [length] are negative, or
   * if [offsetInBytes] + ([length] * elementSizeInBytes) is greater than
   * the length of [buffer].
   *
   * Throws [ArgumentError] if [offsetInBytes] is not a multiple of
   * [BYTES_PER_ELEMENT].
   */
  factory Int64List.view(ByteBuffer buffer,
                         [int offsetInBytes = 0, int length]) {
    return buffer.asInt64List(offsetInBytes, length);
  }

  static const int BYTES_PER_ELEMENT = 8;
}


/**
 * A fixed-length list of 64-bit unsigned integers that is viewable as a
 * [TypedData]. For long lists, this implementation can be considerably
 * more space- and time-efficient than the default [List] implementation.
 */
abstract class Uint64List implements List<int>, TypedData {
  @patch factory Uint64List(int length) {
    throw new UnsupportedError("Uint64List not supported by dart2js.");
  }

  @patch factory Uint64List.fromList(List<int> elements) {
    throw new UnsupportedError("Uint64List not supported by dart2js.");
  }

  /**
   * Creates an [Uint64List] _view_ of the specified region in
   * the specified byte buffer. Changes in the [Uint64List] will be
   * visible in the byte buffer and vice versa. If the [offsetInBytes]
   * index of the region is not specified, it defaults to zero (the first
   * byte in the byte buffer). If the length is not specified, it defaults
   * to null, which indicates that the view extends to the end of the byte
   * buffer.
   *
   * Throws [RangeError] if [offsetInBytes] or [length] are negative, or
   * if [offsetInBytes] + ([length] * elementSizeInBytes) is greater than
   * the length of [buffer].
   *
   * Throws [ArgumentError] if [offsetInBytes] is not a multiple of
   * [BYTES_PER_ELEMENT].
   */
  factory Uint64List.view(ByteBuffer buffer,
                          [int offsetInBytes = 0, int length]) {
    return buffer.asUint64List(offsetInBytes, length);
  }

  static const int BYTES_PER_ELEMENT = 8;
}


/**
 * A fixed-length list of IEEE 754 single-precision binary floating-point
 * numbers  that is viewable as a [TypedData]. For long lists, this
 * implementation can be considerably more space- and time-efficient than
 * the default [List] implementation.
 */
abstract class Float32List implements List<double>, TypedData {
  @patch factory Float32List(int length) = NativeFloat32List;

  @patch factory Float32List.fromList(List<double> elements) =
      NativeFloat32List.fromList;

  /**
   * Creates a [Float32List] _view_ of the specified region in the specified
   * byte buffer. Changes in the [Float32List] will be visible in the byte
   * buffer and vice versa. If the [offsetInBytes] index of the region is not
   * specified, it defaults to zero (the first byte in the byte buffer).
   * If the length is not specified, it defaults to null, which indicates
   * that the view extends to the end of the byte buffer.
   *
   * Throws [RangeError] if [offsetInBytes] or [length] are negative, or
   * if [offsetInBytes] + ([length] * elementSizeInBytes) is greater than
   * the length of [buffer].
   *
   * Throws [ArgumentError] if [offsetInBytes] is not a multiple of
   * [BYTES_PER_ELEMENT].
   */
  factory Float32List.view(ByteBuffer buffer,
                           [int offsetInBytes = 0, int length]) {
    return buffer.asFloat32List(offsetInBytes, length);
  }

  static const int BYTES_PER_ELEMENT = 4;
}


/**
 * A fixed-length list of IEEE 754 double-precision binary floating-point
 * numbers  that is viewable as a [TypedData]. For long lists, this
 * implementation can be considerably more space- and time-efficient than
 * the default [List] implementation.
 */
abstract class Float64List implements List<double>, TypedData {
  @patch factory Float64List(int length) = NativeFloat64List;

  @patch factory Float64List.fromList(List<double> elements) =
      NativeFloat64List.fromList;

  /**
   * Creates a [Float64List] _view_ of the specified region in the specified
   * byte buffer. Changes in the [Float64List] will be visible in the byte
   * buffer and vice versa. If the [offsetInBytes] index of the region is not
   * specified, it defaults to zero (the first byte in the byte buffer).
   * If the length is not specified, it defaults to null, which indicates
   * that the view extends to the end of the byte buffer.
   *
   * Throws [RangeError] if [offsetInBytes] or [length] are negative, or
   * if [offsetInBytes] + ([length] * elementSizeInBytes) is greater than
   * the length of [buffer].
   *
   * Throws [ArgumentError] if [offsetInBytes] is not a multiple of
   * [BYTES_PER_ELEMENT].
   */
  factory Float64List.view(ByteBuffer buffer,
                           [int offsetInBytes = 0, int length]) {
    return buffer.asFloat64List(offsetInBytes, length);
  }

  static const int BYTES_PER_ELEMENT = 8;
}


/**
 * A fixed-length list of Float32x4 numbers that is viewable as a
 * [TypedData]. For long lists, this implementation will be considerably more
 * space- and time-efficient than the default [List] implementation.
 */
abstract class Float32x4List implements List<Float32x4>, TypedData {
  @patch factory Float32x4List(int length) = NativeFloat32x4List;

  @patch factory Float32x4List.fromList(List<Float32x4> elements) =
      NativeFloat32x4List.fromList;

  /**
   * Creates a [Float32x4List] _view_ of the specified region in the specified
   * byte buffer. Changes in the [Float32x4List] will be visible in the byte
   * buffer and vice versa. If the [offsetInBytes] index of the region is not
   * specified, it defaults to zero (the first byte in the byte buffer).
   * If the length is not specified, it defaults to null, which indicates
   * that the view extends to the end of the byte buffer.
   *
   * Throws [RangeError] if [offsetInBytes] or [length] are negative, or
   * if [offsetInBytes] + ([length] * elementSizeInBytes) is greater than
   * the length of [buffer].
   *
   * Throws [ArgumentError] if [offsetInBytes] is not a multiple of
   * [BYTES_PER_ELEMENT].
   */
  factory Float32x4List.view(ByteBuffer buffer,
                             [int offsetInBytes = 0, int length]) {
    return buffer.asFloat32x4List(offsetInBytes, length);
  }

  static const int BYTES_PER_ELEMENT = 16;
}


/**
 * A fixed-length list of Int32x4 numbers that is viewable as a
 * [TypedData]. For long lists, this implementation will be considerably more
 * space- and time-efficient than the default [List] implementation.
 */
abstract class Int32x4List implements List<Int32x4>, TypedData {
  @patch factory Int32x4List(int length) = NativeInt32x4List;

  @patch factory Int32x4List.fromList(List<Int32x4> elements) =
      NativeInt32x4List.fromList;

  /**
   * Creates a [Int32x4List] _view_ of the specified region in the specified
   * byte buffer. Changes in the [Int32x4List] will be visible in the byte
   * buffer and vice versa. If the [offsetInBytes] index of the region is not
   * specified, it defaults to zero (the first byte in the byte buffer).
   * If the length is not specified, it defaults to null, which indicates
   * that the view extends to the end of the byte buffer.
   *
   * Throws [RangeError] if [offsetInBytes] or [length] are negative, or
   * if [offsetInBytes] + ([length] * elementSizeInBytes) is greater than
   * the length of [buffer].
   *
   * Throws [ArgumentError] if [offsetInBytes] is not a multiple of
   * [BYTES_PER_ELEMENT].
   */
  factory Int32x4List.view(ByteBuffer buffer,
                             [int offsetInBytes = 0, int length]) {
    return buffer.asInt32x4List(offsetInBytes, length);
  }

  static const int BYTES_PER_ELEMENT = 16;
}


/**
 * A fixed-length list of Float64x2 numbers that is viewable as a
 * [TypedData]. For long lists, this implementation will be considerably more
 * space- and time-efficient than the default [List] implementation.
 */
abstract class Float64x2List implements List<Float64x2>, TypedData {
  @patch factory Float64x2List(int length) = NativeFloat64x2List;

  @patch factory Float64x2List.fromList(List<Float64x2> elements) =
      NativeFloat64x2List.fromList;

  /**
   * Creates a [Float64x2List] _view_ of the specified region in the specified
   * byte buffer. Changes in the [Float64x2List] will be visible in the byte
   * buffer and vice versa. If the [offsetInBytes] index of the region is not
   * specified, it defaults to zero (the first byte in the byte buffer).
   * If the length is not specified, it defaults to null, which indicates
   * that the view extends to the end of the byte buffer.
   *
   * Throws [RangeError] if [offsetInBytes] or [length] are negative, or
   * if [offsetInBytes] + ([length] * elementSizeInBytes) is greater than
   * the length of [buffer].
   *
   * Throws [ArgumentError] if [offsetInBytes] is not a multiple of
   * [BYTES_PER_ELEMENT].
   */
  factory Float64x2List.view(ByteBuffer buffer,
                             [int offsetInBytes = 0, int length]) {
    return buffer.asFloat64x2List(offsetInBytes, length);
  }

  static const int BYTES_PER_ELEMENT = 16;
}


/**
 * Float32x4 immutable value type and operations.
 * Float32x4 stores 4 32-bit floating point values in "lanes".
 * The lanes are "x", "y", "z", and "w" respectively.
 */
abstract class Float32x4 {
  @patch factory Float32x4(double x, double y, double z, double w) =
      NativeFloat32x4;
  @patch factory Float32x4.splat(double v) = NativeFloat32x4.splat;
  @patch factory Float32x4.zero() = NativeFloat32x4.zero;
  @patch factory Float32x4.fromInt32x4Bits(Int32x4 x) =
      NativeFloat32x4.fromInt32x4Bits;
  @patch factory Float32x4.fromFloat64x2(Float64x2 v) =
      NativeFloat32x4.fromFloat64x2;

  /// Addition operator.
  Float32x4 operator+(Float32x4 other);
  /// Negate operator.
  Float32x4 operator-();
  /// Subtraction operator.
  Float32x4 operator-(Float32x4 other);
  /// Multiplication operator.
  Float32x4 operator*(Float32x4 other);
  /// Division operator.
  Float32x4 operator/(Float32x4 other);

  /// Relational less than.
  Int32x4 lessThan(Float32x4 other);
  /// Relational less than or equal.
  Int32x4 lessThanOrEqual(Float32x4 other);
  /// Relational greater than.
  Int32x4 greaterThan(Float32x4 other);
  /// Relational greater than or equal.
  Int32x4 greaterThanOrEqual(Float32x4 other);
  /// Relational equal.
  Int32x4 equal(Float32x4 other);
  /// Relational not-equal.
  Int32x4 notEqual(Float32x4 other);

  /// Returns a copy of [this] each lane being scaled by [s].
  /// Equivalent to this * new Float32x4.splat(s)
  Float32x4 scale(double s);
  /// Returns the lane-wise absolute value of this [Float32x4].
  Float32x4 abs();
  /// Lane-wise clamp [this] to be in the range [lowerLimit]-[upperLimit].
  Float32x4 clamp(Float32x4 lowerLimit, Float32x4 upperLimit);

  /// Extracted x value.
  double get x;
  /// Extracted y value.
  double get y;
  /// Extracted z value.
  double get z;
  /// Extracted w value.
  double get w;

  /// Extract the sign bits from each lane return them in the first 4 bits.
  /// "x" lane is bit 0.
  /// "y" lane is bit 1.
  /// "z" lane is bit 2.
  /// "w" lane is bit 3.
  int get signMask;

  /// Mask passed to [shuffle] or [shuffleMix].
  static const int XXXX = 0x0;
  static const int XXXY = 0x40;
  static const int XXXZ = 0x80;
  static const int XXXW = 0xC0;
  static const int XXYX = 0x10;
  static const int XXYY = 0x50;
  static const int XXYZ = 0x90;
  static const int XXYW = 0xD0;
  static const int XXZX = 0x20;
  static const int XXZY = 0x60;
  static const int XXZZ = 0xA0;
  static const int XXZW = 0xE0;
  static const int XXWX = 0x30;
  static const int XXWY = 0x70;
  static const int XXWZ = 0xB0;
  static const int XXWW = 0xF0;
  static const int XYXX = 0x4;
  static const int XYXY = 0x44;
  static const int XYXZ = 0x84;
  static const int XYXW = 0xC4;
  static const int XYYX = 0x14;
  static const int XYYY = 0x54;
  static const int XYYZ = 0x94;
  static const int XYYW = 0xD4;
  static const int XYZX = 0x24;
  static const int XYZY = 0x64;
  static const int XYZZ = 0xA4;
  static const int XYZW = 0xE4;
  static const int XYWX = 0x34;
  static const int XYWY = 0x74;
  static const int XYWZ = 0xB4;
  static const int XYWW = 0xF4;
  static const int XZXX = 0x8;
  static const int XZXY = 0x48;
  static const int XZXZ = 0x88;
  static const int XZXW = 0xC8;
  static const int XZYX = 0x18;
  static const int XZYY = 0x58;
  static const int XZYZ = 0x98;
  static const int XZYW = 0xD8;
  static const int XZZX = 0x28;
  static const int XZZY = 0x68;
  static const int XZZZ = 0xA8;
  static const int XZZW = 0xE8;
  static const int XZWX = 0x38;
  static const int XZWY = 0x78;
  static const int XZWZ = 0xB8;
  static const int XZWW = 0xF8;
  static const int XWXX = 0xC;
  static const int XWXY = 0x4C;
  static const int XWXZ = 0x8C;
  static const int XWXW = 0xCC;
  static const int XWYX = 0x1C;
  static const int XWYY = 0x5C;
  static const int XWYZ = 0x9C;
  static const int XWYW = 0xDC;
  static const int XWZX = 0x2C;
  static const int XWZY = 0x6C;
  static const int XWZZ = 0xAC;
  static const int XWZW = 0xEC;
  static const int XWWX = 0x3C;
  static const int XWWY = 0x7C;
  static const int XWWZ = 0xBC;
  static const int XWWW = 0xFC;
  static const int YXXX = 0x1;
  static const int YXXY = 0x41;
  static const int YXXZ = 0x81;
  static const int YXXW = 0xC1;
  static const int YXYX = 0x11;
  static const int YXYY = 0x51;
  static const int YXYZ = 0x91;
  static const int YXYW = 0xD1;
  static const int YXZX = 0x21;
  static const int YXZY = 0x61;
  static const int YXZZ = 0xA1;
  static const int YXZW = 0xE1;
  static const int YXWX = 0x31;
  static const int YXWY = 0x71;
  static const int YXWZ = 0xB1;
  static const int YXWW = 0xF1;
  static const int YYXX = 0x5;
  static const int YYXY = 0x45;
  static const int YYXZ = 0x85;
  static const int YYXW = 0xC5;
  static const int YYYX = 0x15;
  static const int YYYY = 0x55;
  static const int YYYZ = 0x95;
  static const int YYYW = 0xD5;
  static const int YYZX = 0x25;
  static const int YYZY = 0x65;
  static const int YYZZ = 0xA5;
  static const int YYZW = 0xE5;
  static const int YYWX = 0x35;
  static const int YYWY = 0x75;
  static const int YYWZ = 0xB5;
  static const int YYWW = 0xF5;
  static const int YZXX = 0x9;
  static const int YZXY = 0x49;
  static const int YZXZ = 0x89;
  static const int YZXW = 0xC9;
  static const int YZYX = 0x19;
  static const int YZYY = 0x59;
  static const int YZYZ = 0x99;
  static const int YZYW = 0xD9;
  static const int YZZX = 0x29;
  static const int YZZY = 0x69;
  static const int YZZZ = 0xA9;
  static const int YZZW = 0xE9;
  static const int YZWX = 0x39;
  static const int YZWY = 0x79;
  static const int YZWZ = 0xB9;
  static const int YZWW = 0xF9;
  static const int YWXX = 0xD;
  static const int YWXY = 0x4D;
  static const int YWXZ = 0x8D;
  static const int YWXW = 0xCD;
  static const int YWYX = 0x1D;
  static const int YWYY = 0x5D;
  static const int YWYZ = 0x9D;
  static const int YWYW = 0xDD;
  static const int YWZX = 0x2D;
  static const int YWZY = 0x6D;
  static const int YWZZ = 0xAD;
  static const int YWZW = 0xED;
  static const int YWWX = 0x3D;
  static const int YWWY = 0x7D;
  static const int YWWZ = 0xBD;
  static const int YWWW = 0xFD;
  static const int ZXXX = 0x2;
  static const int ZXXY = 0x42;
  static const int ZXXZ = 0x82;
  static const int ZXXW = 0xC2;
  static const int ZXYX = 0x12;
  static const int ZXYY = 0x52;
  static const int ZXYZ = 0x92;
  static const int ZXYW = 0xD2;
  static const int ZXZX = 0x22;
  static const int ZXZY = 0x62;
  static const int ZXZZ = 0xA2;
  static const int ZXZW = 0xE2;
  static const int ZXWX = 0x32;
  static const int ZXWY = 0x72;
  static const int ZXWZ = 0xB2;
  static const int ZXWW = 0xF2;
  static const int ZYXX = 0x6;
  static const int ZYXY = 0x46;
  static const int ZYXZ = 0x86;
  static const int ZYXW = 0xC6;
  static const int ZYYX = 0x16;
  static const int ZYYY = 0x56;
  static const int ZYYZ = 0x96;
  static const int ZYYW = 0xD6;
  static const int ZYZX = 0x26;
  static const int ZYZY = 0x66;
  static const int ZYZZ = 0xA6;
  static const int ZYZW = 0xE6;
  static const int ZYWX = 0x36;
  static const int ZYWY = 0x76;
  static const int ZYWZ = 0xB6;
  static const int ZYWW = 0xF6;
  static const int ZZXX = 0xA;
  static const int ZZXY = 0x4A;
  static const int ZZXZ = 0x8A;
  static const int ZZXW = 0xCA;
  static const int ZZYX = 0x1A;
  static const int ZZYY = 0x5A;
  static const int ZZYZ = 0x9A;
  static const int ZZYW = 0xDA;
  static const int ZZZX = 0x2A;
  static const int ZZZY = 0x6A;
  static const int ZZZZ = 0xAA;
  static const int ZZZW = 0xEA;
  static const int ZZWX = 0x3A;
  static const int ZZWY = 0x7A;
  static const int ZZWZ = 0xBA;
  static const int ZZWW = 0xFA;
  static const int ZWXX = 0xE;
  static const int ZWXY = 0x4E;
  static const int ZWXZ = 0x8E;
  static const int ZWXW = 0xCE;
  static const int ZWYX = 0x1E;
  static const int ZWYY = 0x5E;
  static const int ZWYZ = 0x9E;
  static const int ZWYW = 0xDE;
  static const int ZWZX = 0x2E;
  static const int ZWZY = 0x6E;
  static const int ZWZZ = 0xAE;
  static const int ZWZW = 0xEE;
  static const int ZWWX = 0x3E;
  static const int ZWWY = 0x7E;
  static const int ZWWZ = 0xBE;
  static const int ZWWW = 0xFE;
  static const int WXXX = 0x3;
  static const int WXXY = 0x43;
  static const int WXXZ = 0x83;
  static const int WXXW = 0xC3;
  static const int WXYX = 0x13;
  static const int WXYY = 0x53;
  static const int WXYZ = 0x93;
  static const int WXYW = 0xD3;
  static const int WXZX = 0x23;
  static const int WXZY = 0x63;
  static const int WXZZ = 0xA3;
  static const int WXZW = 0xE3;
  static const int WXWX = 0x33;
  static const int WXWY = 0x73;
  static const int WXWZ = 0xB3;
  static const int WXWW = 0xF3;
  static const int WYXX = 0x7;
  static const int WYXY = 0x47;
  static const int WYXZ = 0x87;
  static const int WYXW = 0xC7;
  static const int WYYX = 0x17;
  static const int WYYY = 0x57;
  static const int WYYZ = 0x97;
  static const int WYYW = 0xD7;
  static const int WYZX = 0x27;
  static const int WYZY = 0x67;
  static const int WYZZ = 0xA7;
  static const int WYZW = 0xE7;
  static const int WYWX = 0x37;
  static const int WYWY = 0x77;
  static const int WYWZ = 0xB7;
  static const int WYWW = 0xF7;
  static const int WZXX = 0xB;
  static const int WZXY = 0x4B;
  static const int WZXZ = 0x8B;
  static const int WZXW = 0xCB;
  static const int WZYX = 0x1B;
  static const int WZYY = 0x5B;
  static const int WZYZ = 0x9B;
  static const int WZYW = 0xDB;
  static const int WZZX = 0x2B;
  static const int WZZY = 0x6B;
  static const int WZZZ = 0xAB;
  static const int WZZW = 0xEB;
  static const int WZWX = 0x3B;
  static const int WZWY = 0x7B;
  static const int WZWZ = 0xBB;
  static const int WZWW = 0xFB;
  static const int WWXX = 0xF;
  static const int WWXY = 0x4F;
  static const int WWXZ = 0x8F;
  static const int WWXW = 0xCF;
  static const int WWYX = 0x1F;
  static const int WWYY = 0x5F;
  static const int WWYZ = 0x9F;
  static const int WWYW = 0xDF;
  static const int WWZX = 0x2F;
  static const int WWZY = 0x6F;
  static const int WWZZ = 0xAF;
  static const int WWZW = 0xEF;
  static const int WWWX = 0x3F;
  static const int WWWY = 0x7F;
  static const int WWWZ = 0xBF;
  static const int WWWW = 0xFF;

  /// Shuffle the lane values. [mask] must be one of the 256 shuffle constants.
  Float32x4 shuffle(int mask);

  /// Shuffle the lane values in [this] and [other]. The returned
  /// Float32x4 will have XY lanes from [this] and ZW lanes from [other].
  /// Uses the same [mask] as [shuffle].
  Float32x4 shuffleMix(Float32x4 other, int mask);

  /// Returns a new [Float32x4] copied from [this] with a new x value.
  Float32x4 withX(double x);
  /// Returns a new [Float32x4] copied from [this] with a new y value.
  Float32x4 withY(double y);
  /// Returns a new [Float32x4] copied from [this] with a new z value.
  Float32x4 withZ(double z);
  /// Returns a new [Float32x4] copied from [this] with a new w value.
  Float32x4 withW(double w);

  /// Returns the lane-wise minimum value in [this] or [other].
  Float32x4 min(Float32x4 other);

  /// Returns the lane-wise maximum value in [this] or [other].
  Float32x4 max(Float32x4 other);

  /// Returns the square root of [this].
  Float32x4 sqrt();

  /// Returns the reciprocal of [this].
  Float32x4 reciprocal();

  /// Returns the square root of the reciprocal of [this].
  Float32x4 reciprocalSqrt();
}


/**
 * Int32x4 and operations.
 * Int32x4 stores 4 32-bit bit-masks in "lanes".
 * The lanes are "x", "y", "z", and "w" respectively.
 */
abstract class Int32x4 {
  @patch factory Int32x4(int x, int y, int z, int w) = NativeInt32x4;
  @patch factory Int32x4.bool(bool x, bool y, bool z, bool w) =
      NativeInt32x4.bool;
  @patch factory Int32x4.fromFloat32x4Bits(Float32x4 x) =
      NativeInt32x4.fromFloat32x4Bits;

  /// The bit-wise or operator.
  Int32x4 operator|(Int32x4 other);
  /// The bit-wise and operator.
  Int32x4 operator&(Int32x4 other);
  /// The bit-wise xor operator.
  Int32x4 operator^(Int32x4 other);
  /// Addition operator.
  Int32x4 operator+(Int32x4 other);
  /// Subtraction operator.
  Int32x4 operator-(Int32x4 other);

  /// Extract 32-bit mask from x lane.
  int get x;
  /// Extract 32-bit mask from y lane.
  int get y;
  /// Extract 32-bit mask from z lane.
  int get z;
  /// Extract 32-bit mask from w lane.
  int get w;

  /// Extract the top bit from each lane return them in the first 4 bits.
  /// "x" lane is bit 0.
  /// "y" lane is bit 1.
  /// "z" lane is bit 2.
  /// "w" lane is bit 3.
  int get signMask;

  /// Mask passed to [shuffle] or [shuffleMix].
  static const int XXXX = 0x0;
  static const int XXXY = 0x40;
  static const int XXXZ = 0x80;
  static const int XXXW = 0xC0;
  static const int XXYX = 0x10;
  static const int XXYY = 0x50;
  static const int XXYZ = 0x90;
  static const int XXYW = 0xD0;
  static const int XXZX = 0x20;
  static const int XXZY = 0x60;
  static const int XXZZ = 0xA0;
  static const int XXZW = 0xE0;
  static const int XXWX = 0x30;
  static const int XXWY = 0x70;
  static const int XXWZ = 0xB0;
  static const int XXWW = 0xF0;
  static const int XYXX = 0x4;
  static const int XYXY = 0x44;
  static const int XYXZ = 0x84;
  static const int XYXW = 0xC4;
  static const int XYYX = 0x14;
  static const int XYYY = 0x54;
  static const int XYYZ = 0x94;
  static const int XYYW = 0xD4;
  static const int XYZX = 0x24;
  static const int XYZY = 0x64;
  static const int XYZZ = 0xA4;
  static const int XYZW = 0xE4;
  static const int XYWX = 0x34;
  static const int XYWY = 0x74;
  static const int XYWZ = 0xB4;
  static const int XYWW = 0xF4;
  static const int XZXX = 0x8;
  static const int XZXY = 0x48;
  static const int XZXZ = 0x88;
  static const int XZXW = 0xC8;
  static const int XZYX = 0x18;
  static const int XZYY = 0x58;
  static const int XZYZ = 0x98;
  static const int XZYW = 0xD8;
  static const int XZZX = 0x28;
  static const int XZZY = 0x68;
  static const int XZZZ = 0xA8;
  static const int XZZW = 0xE8;
  static const int XZWX = 0x38;
  static const int XZWY = 0x78;
  static const int XZWZ = 0xB8;
  static const int XZWW = 0xF8;
  static const int XWXX = 0xC;
  static const int XWXY = 0x4C;
  static const int XWXZ = 0x8C;
  static const int XWXW = 0xCC;
  static const int XWYX = 0x1C;
  static const int XWYY = 0x5C;
  static const int XWYZ = 0x9C;
  static const int XWYW = 0xDC;
  static const int XWZX = 0x2C;
  static const int XWZY = 0x6C;
  static const int XWZZ = 0xAC;
  static const int XWZW = 0xEC;
  static const int XWWX = 0x3C;
  static const int XWWY = 0x7C;
  static const int XWWZ = 0xBC;
  static const int XWWW = 0xFC;
  static const int YXXX = 0x1;
  static const int YXXY = 0x41;
  static const int YXXZ = 0x81;
  static const int YXXW = 0xC1;
  static const int YXYX = 0x11;
  static const int YXYY = 0x51;
  static const int YXYZ = 0x91;
  static const int YXYW = 0xD1;
  static const int YXZX = 0x21;
  static const int YXZY = 0x61;
  static const int YXZZ = 0xA1;
  static const int YXZW = 0xE1;
  static const int YXWX = 0x31;
  static const int YXWY = 0x71;
  static const int YXWZ = 0xB1;
  static const int YXWW = 0xF1;
  static const int YYXX = 0x5;
  static const int YYXY = 0x45;
  static const int YYXZ = 0x85;
  static const int YYXW = 0xC5;
  static const int YYYX = 0x15;
  static const int YYYY = 0x55;
  static const int YYYZ = 0x95;
  static const int YYYW = 0xD5;
  static const int YYZX = 0x25;
  static const int YYZY = 0x65;
  static const int YYZZ = 0xA5;
  static const int YYZW = 0xE5;
  static const int YYWX = 0x35;
  static const int YYWY = 0x75;
  static const int YYWZ = 0xB5;
  static const int YYWW = 0xF5;
  static const int YZXX = 0x9;
  static const int YZXY = 0x49;
  static const int YZXZ = 0x89;
  static const int YZXW = 0xC9;
  static const int YZYX = 0x19;
  static const int YZYY = 0x59;
  static const int YZYZ = 0x99;
  static const int YZYW = 0xD9;
  static const int YZZX = 0x29;
  static const int YZZY = 0x69;
  static const int YZZZ = 0xA9;
  static const int YZZW = 0xE9;
  static const int YZWX = 0x39;
  static const int YZWY = 0x79;
  static const int YZWZ = 0xB9;
  static const int YZWW = 0xF9;
  static const int YWXX = 0xD;
  static const int YWXY = 0x4D;
  static const int YWXZ = 0x8D;
  static const int YWXW = 0xCD;
  static const int YWYX = 0x1D;
  static const int YWYY = 0x5D;
  static const int YWYZ = 0x9D;
  static const int YWYW = 0xDD;
  static const int YWZX = 0x2D;
  static const int YWZY = 0x6D;
  static const int YWZZ = 0xAD;
  static const int YWZW = 0xED;
  static const int YWWX = 0x3D;
  static const int YWWY = 0x7D;
  static const int YWWZ = 0xBD;
  static const int YWWW = 0xFD;
  static const int ZXXX = 0x2;
  static const int ZXXY = 0x42;
  static const int ZXXZ = 0x82;
  static const int ZXXW = 0xC2;
  static const int ZXYX = 0x12;
  static const int ZXYY = 0x52;
  static const int ZXYZ = 0x92;
  static const int ZXYW = 0xD2;
  static const int ZXZX = 0x22;
  static const int ZXZY = 0x62;
  static const int ZXZZ = 0xA2;
  static const int ZXZW = 0xE2;
  static const int ZXWX = 0x32;
  static const int ZXWY = 0x72;
  static const int ZXWZ = 0xB2;
  static const int ZXWW = 0xF2;
  static const int ZYXX = 0x6;
  static const int ZYXY = 0x46;
  static const int ZYXZ = 0x86;
  static const int ZYXW = 0xC6;
  static const int ZYYX = 0x16;
  static const int ZYYY = 0x56;
  static const int ZYYZ = 0x96;
  static const int ZYYW = 0xD6;
  static const int ZYZX = 0x26;
  static const int ZYZY = 0x66;
  static const int ZYZZ = 0xA6;
  static const int ZYZW = 0xE6;
  static const int ZYWX = 0x36;
  static const int ZYWY = 0x76;
  static const int ZYWZ = 0xB6;
  static const int ZYWW = 0xF6;
  static const int ZZXX = 0xA;
  static const int ZZXY = 0x4A;
  static const int ZZXZ = 0x8A;
  static const int ZZXW = 0xCA;
  static const int ZZYX = 0x1A;
  static const int ZZYY = 0x5A;
  static const int ZZYZ = 0x9A;
  static const int ZZYW = 0xDA;
  static const int ZZZX = 0x2A;
  static const int ZZZY = 0x6A;
  static const int ZZZZ = 0xAA;
  static const int ZZZW = 0xEA;
  static const int ZZWX = 0x3A;
  static const int ZZWY = 0x7A;
  static const int ZZWZ = 0xBA;
  static const int ZZWW = 0xFA;
  static const int ZWXX = 0xE;
  static const int ZWXY = 0x4E;
  static const int ZWXZ = 0x8E;
  static const int ZWXW = 0xCE;
  static const int ZWYX = 0x1E;
  static const int ZWYY = 0x5E;
  static const int ZWYZ = 0x9E;
  static const int ZWYW = 0xDE;
  static const int ZWZX = 0x2E;
  static const int ZWZY = 0x6E;
  static const int ZWZZ = 0xAE;
  static const int ZWZW = 0xEE;
  static const int ZWWX = 0x3E;
  static const int ZWWY = 0x7E;
  static const int ZWWZ = 0xBE;
  static const int ZWWW = 0xFE;
  static const int WXXX = 0x3;
  static const int WXXY = 0x43;
  static const int WXXZ = 0x83;
  static const int WXXW = 0xC3;
  static const int WXYX = 0x13;
  static const int WXYY = 0x53;
  static const int WXYZ = 0x93;
  static const int WXYW = 0xD3;
  static const int WXZX = 0x23;
  static const int WXZY = 0x63;
  static const int WXZZ = 0xA3;
  static const int WXZW = 0xE3;
  static const int WXWX = 0x33;
  static const int WXWY = 0x73;
  static const int WXWZ = 0xB3;
  static const int WXWW = 0xF3;
  static const int WYXX = 0x7;
  static const int WYXY = 0x47;
  static const int WYXZ = 0x87;
  static const int WYXW = 0xC7;
  static const int WYYX = 0x17;
  static const int WYYY = 0x57;
  static const int WYYZ = 0x97;
  static const int WYYW = 0xD7;
  static const int WYZX = 0x27;
  static const int WYZY = 0x67;
  static const int WYZZ = 0xA7;
  static const int WYZW = 0xE7;
  static const int WYWX = 0x37;
  static const int WYWY = 0x77;
  static const int WYWZ = 0xB7;
  static const int WYWW = 0xF7;
  static const int WZXX = 0xB;
  static const int WZXY = 0x4B;
  static const int WZXZ = 0x8B;
  static const int WZXW = 0xCB;
  static const int WZYX = 0x1B;
  static const int WZYY = 0x5B;
  static const int WZYZ = 0x9B;
  static const int WZYW = 0xDB;
  static const int WZZX = 0x2B;
  static const int WZZY = 0x6B;
  static const int WZZZ = 0xAB;
  static const int WZZW = 0xEB;
  static const int WZWX = 0x3B;
  static const int WZWY = 0x7B;
  static const int WZWZ = 0xBB;
  static const int WZWW = 0xFB;
  static const int WWXX = 0xF;
  static const int WWXY = 0x4F;
  static const int WWXZ = 0x8F;
  static const int WWXW = 0xCF;
  static const int WWYX = 0x1F;
  static const int WWYY = 0x5F;
  static const int WWYZ = 0x9F;
  static const int WWYW = 0xDF;
  static const int WWZX = 0x2F;
  static const int WWZY = 0x6F;
  static const int WWZZ = 0xAF;
  static const int WWZW = 0xEF;
  static const int WWWX = 0x3F;
  static const int WWWY = 0x7F;
  static const int WWWZ = 0xBF;
  static const int WWWW = 0xFF;

  /// Shuffle the lane values. [mask] must be one of the 256 shuffle constants.
  Int32x4 shuffle(int mask);

  /// Shuffle the lane values in [this] and [other]. The returned
  /// Int32x4 will have XY lanes from [this] and ZW lanes from [other].
  /// Uses the same [mask] as [shuffle].
  Int32x4 shuffleMix(Int32x4 other, int mask);

  /// Returns a new [Int32x4] copied from [this] with a new x value.
  Int32x4 withX(int x);
  /// Returns a new [Int32x4] copied from [this] with a new y value.
  Int32x4 withY(int y);
  /// Returns a new [Int32x4] copied from [this] with a new z value.
  Int32x4 withZ(int z);
  /// Returns a new [Int32x4] copied from [this] with a new w value.
  Int32x4 withW(int w);

  /// Extracted x value. Returns false for 0, true for any other value.
  bool get flagX;
  /// Extracted y value. Returns false for 0, true for any other value.
  bool get flagY;
  /// Extracted z value. Returns false for 0, true for any other value.
  bool get flagZ;
  /// Extracted w value. Returns false for 0, true for any other value.
  bool get flagW;

  /// Returns a new [Int32x4] copied from [this] with a new x value.
  Int32x4 withFlagX(bool x);
  /// Returns a new [Int32x4] copied from [this] with a new y value.
  Int32x4 withFlagY(bool y);
  /// Returns a new [Int32x4] copied from [this] with a new z value.
  Int32x4 withFlagZ(bool z);
  /// Returns a new [Int32x4] copied from [this] with a new w value.
  Int32x4 withFlagW(bool w);

  /// Merge [trueValue] and [falseValue] based on [this]' bit mask:
  /// Select bit from [trueValue] when bit in [this] is on.
  /// Select bit from [falseValue] when bit in [this] is off.
  Float32x4 select(Float32x4 trueValue, Float32x4 falseValue);
}

/**
 * Float64x2 immutable value type and operations.
 * Float64x2 stores 2 64-bit floating point values in "lanes".
 * The lanes are "x" and "y" respectively.
 */
abstract class Float64x2 {
  @patch factory Float64x2(double x, double y) = NativeFloat64x2;
  @patch factory Float64x2.splat(double v) = NativeFloat64x2.splat;
  @patch factory Float64x2.zero() = NativeFloat64x2.zero;
  @patch factory Float64x2.fromFloat32x4(Float32x4 v) =
      NativeFloat64x2.fromFloat32x4;

  /// Addition operator.
  Float64x2 operator+(Float64x2 other);
  /// Negate operator.
  Float64x2 operator-();
  /// Subtraction operator.
  Float64x2 operator-(Float64x2 other);
  /// Multiplication operator.
  Float64x2 operator*(Float64x2 other);
  /// Division operator.
  Float64x2 operator/(Float64x2 other);

  /// Returns a copy of [this] each lane being scaled by [s].
  /// Equivalent to this * new Float64x2.splat(s)
  Float64x2 scale(double s);
  /// Returns the lane-wise absolute value of this [Float64x2].
  Float64x2 abs();

  /// Lane-wise clamp [this] to be in the range [lowerLimit]-[upperLimit].
  Float64x2 clamp(Float64x2 lowerLimit,
                  Float64x2 upperLimit);

  /// Extracted x value.
  double get x;
  /// Extracted y value.
  double get y;

  /// Extract the sign bits from each lane return them in the first 2 bits.
  /// "x" lane is bit 0.
  /// "y" lane is bit 1.
  int get signMask;

  /// Returns a new [Float64x2] copied from [this] with a new x value.
  Float64x2 withX(double x);
  /// Returns a new [Float64x2] copied from [this] with a new y value.
  Float64x2 withY(double y);

  /// Returns the lane-wise minimum value in [this] or [other].
  Float64x2 min(Float64x2 other);

  /// Returns the lane-wise maximum value in [this] or [other].
  Float64x2 max(Float64x2 other);

  /// Returns the lane-wise square root of [this].
  Float64x2 sqrt();
}
