scattered union ast

union clause ast = MOV : (register_index, register_index)
union clause ast = MOVP : (predicate_index, predicate_index)
union clause ast = ADD : (register_index, register_index, register_index)
union clause ast = SUB : (register_index, register_index, register_index)
union clause ast = BRANCH : target_index
union clause ast = BLOCK : (block_branch_count, block_length, option(bits(16)))
union clause ast = BRANCHL : target_index
union clause ast = EQ_Z : (predicate_index, register_index)
union clause ast = NEQ_Z : (predicate_index, register_index)
union clause ast = EQ : (predicate_index, register_index, register_index)
union clause ast = NEQ : (predicate_index, register_index, register_index)
union clause ast = LT : (predicate_index, register_index, register_index)
union clause ast = LTE : (predicate_index, register_index, register_index)
union clause ast = LTU : (predicate_index, register_index, register_index)
union clause ast = LTEU : (predicate_index, register_index, register_index)
union clause ast = AND : (register_index, register_index, register_index)
union clause ast = ANDC : (register_index, register_index, register_index)
union clause ast = OR : (register_index, register_index, register_index)
union clause ast = XOR : (register_index, register_index, register_index)
union clause ast = NOT : (register_index, register_index)
union clause ast = NEG : (register_index, register_index)
union clause ast = BSWAP : (register_index, register_index)
union clause ast = ADD_S : (register_index, bits(4))
union clause ast = SUB_S : (register_index, bits(4))
union clause ast = AND_S : (register_index, bits(4))
union clause ast = SET_S : (register_index, bits(4), bits(1))
union clause ast = SET_W : (register_index, bits(16))
union clause ast = HALT : unit
union clause ast = NOP : unit
union clause ast = HINT : bits(4)
union clause ast = UNALLOCATED : word
union clause ast = UNALLOCATED2 : doubleword

end ast
