import Papyrus.IR.TypeRefs

namespace Papyrus

/--
  A reference to the LLVM representation of a
  [GenericValue](https://llvm.org/doxygen/structllvm_1_1GenericValue.html).
-/
constant GenericValueRef : Type := Unit

namespace  GenericValueRef

/--
  Create a generic integer of the given width with the given `Int` value.
  The value will be truncated and/or extended as necessary to make it fit.
-/
@[extern "papyrus_generic_value_of_int"]
constant ofInt (value : @& Int) (numBits : @& UInt32) : IO GenericValueRef

/-- Get the value of this generic as an `Int` by treating its integer bits as signed. -/
@[extern "papyrus_generic_value_to_int"]
constant toInt (self : @& GenericValueRef) : IO Int

/--
  Create a generic integer of the given width with the given `Nat` value.
  The value will be truncated and/or extended as necessary to make it fit.
-/
@[extern "papyrus_generic_value_of_nat"]
constant ofNat (value : @& Nat)  (numBits : @& UInt32) : IO GenericValueRef

/-- Get the value of this generic as an `Nat` by treating its integer bits as unsigned. -/
@[extern "papyrus_generic_value_to_nat"]
constant toNat (self : @& GenericValueRef) : IO Nat

/-- Create a generic from a `Float. -/
@[extern "papyrus_generic_value_of_float"]
constant ofFloat (value : @& Float) : IO GenericValueRef

/-- Get the value of this generic as an `Float` by treating its bits as a `double`. -/
@[extern "papyrus_generic_value_to_float"]
constant toFloat (self : @& GenericValueRef) : IO Float

/-- Create a generic from an `Array`. -/
@[extern "papyrus_generic_value_of_array"]
constant ofArray (value : @& Array GenericValueRef) : IO GenericValueRef

/-- Get the value of this generic as an `Array`. -/
@[extern "papyrus_generic_value_to_array"]
constant toArray (self : @& GenericValueRef) : IO (Array GenericValueRef)

end GenericValueRef

namespace IntegerTypeRef

/-- Get a reference to a generic of this type with the value of `Int`. -/
def getGenericValueOfInt (value : @& Int) (self : @& IntegerTypeRef) : IO GenericValueRef := do
  GenericValueRef.ofInt value (← self.getBitWidth)

/-- Get a reference to a generic of this type with the value of `Nat`. -/
constant getGenericValueOfNat (value : @& Nat) (self : @& IntegerTypeRef) : IO GenericValueRef := do
  GenericValueRef.ofNat value (← self.getBitWidth)

end IntegerTypeRef
