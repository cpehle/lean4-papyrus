import Papyrus.Types.TypeRef

namespace Papyrus

-- # Integer Type Reference

/--
  A reference to the LLVM representation of an
  [IntegerType](https://llvm.org/doxygen/classllvm_1_1IntegerType.html).
-/
def IntegerTypeRef := TypeRef

namespace IntegerTypeRef

/-- Minimum bit width of an LLVM integer type. -/
def MIN_INT_BITS : UInt32 := 1

/-- Maximum bit width of an LLVM integer type. -/
def MAX_INT_BITS : UInt32 := 16777215 -- (1 <<< 24) - 1

/-- Holds if the given bit width is valid for an LLVM integer type. -/
def isValidBitWidth (bitWidth : UInt32) : Prop :=
  bitWidth ≥ MIN_INT_BITS ∧ bitWidth ≤ MAX_INT_BITS

/--
  Get a reference to the LLVM integer type of the given width.
  It is the user's responsible to ensure that the bit width of the type falls
  within LLVM's requirements (i.e., that `isValidBitWidth numBits` holds).
-/
@[extern "papyrus_get_integer_type"]
constant get (numBits : @& UInt32) : LLVM TypeRef

/-- Get the width in bits of this type. -/
@[extern "papyrus_integer_type_get_bit_width"]
constant getBitWidth (self : @& IntegerTypeRef) : LLVM UInt32

end IntegerTypeRef

-- # Pure Integer Type

/-- An arbirtrary precision integer type. -/
structure IntegerType (numBits : Nat) deriving Inhabited

/-- An integer type of the given precision. -/
def integerType (numBits : Nat) : IntegerType numBits :=
  IntegerType.mk

namespace IntegerType

variable {numBits : Nat}

/--
  Get a reference to the LLVM representation of this type.
  It is the user's responsible to ensure that the bit width of the type falls
  within the LLVM's requirements (i.e., that `isValidBitWidth numBits` holds).
-/
def getRef (self : IntegerType numBits) : LLVM IntegerTypeRef :=
  IntegerTypeRef.get numBits.toUInt32

/-- The width in bits of this type. -/
def bitWidth (self : IntegerType numBits) := numBits

/-- An integer type twice as wide as this type. -/
def extendedType (self : IntegerType numBits) :=
  integerType (self.bitWidth <<< 1)

/--
  A 64-bit mask with ones set for all the bits of this type
  (or just every bit, if this type's bit width is greater than 64).
-/
def bitMask (self : IntegerType numBits) : UInt64 :=
  ~~~(0 : UInt64) >>> (64 - self.bitWidth.toUInt64)

/--
  A `UInt64` with just the most significant bit of this type set
  (the sign bit, if the value is treated as a signed number).
-/
def signBit (self : IntegerType numBits) : UInt64 :=
  (1 : UInt64) <<< (self.bitWidth.toUInt64 - 1)

/--
  A bit mask with ones set for all the bits of this type.
  For example, this is 0xFF for an 8 bit integer, 0xFFFF for i16, etc.
-/
def mask (self : IntegerType numBits) : Nat :=
  (1 <<< self.bitWidth) - 1

end IntegerType

instance {numBits} : ToTypeRef (IntegerType numBits) := ⟨IntegerType.getRef⟩

-- # Specializations

/-- A 1-bit integer type (e.g., a `bool`). -/
def int1Type := integerType 1

/-- An 8-bit integer type (e.g., a `byte` or `char`). -/
def int8Type := integerType 8

/-- A 16-bit integer type (e.g., a `short`). -/
def int16Type := integerType 16

/-- A 32-bit integer type (e.g., a `long`). -/
def int32Type := integerType 32

/-- A 64-bit integer type (e.g., a `long long`). -/
def int64Type := integerType 64

/-- A 128-bit integer type. -/
def int128Type := integerType 128
