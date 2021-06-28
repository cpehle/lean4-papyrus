import Papyrus.IR.TypeRefs

namespace Papyrus

/-- A fixed-length homogenous array type. -/
structure ArrayType (α) (numElems : Nat) where
  elementType : α

/-- An array type of the given type with the given size. -/
def arrayType (elementType : α) (numElems : Nat) : ArrayType α numElems  :=
  ArrayType.mk elementType

namespace ArrayType
variable {numElems : Nat}

/-- The number of elements in this type. -/
def size (self : ArrayType α numElems) := numElems

/--
  Get a reference to the LLVM representation of this type.
  It is the user's responsibility to ensure that the element type
  and size are valid.
-/
def getRef [ToTypeRef α] (self : ArrayType α numElems) : LLVM ArrayTypeRef := do
  ArrayTypeRef.get (← toTypeRef self.elementType) numElems.toUInt64

end ArrayType

instance [ToTypeRef α] {numElems} : ToTypeRef (ArrayType α numElems) :=
  ⟨ArrayType.getRef⟩
