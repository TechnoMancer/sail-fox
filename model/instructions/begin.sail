scattered union ast

/* returns whether an instruction was retired */
val execute : ast -> Retired
scattered function execute

val assembly : ast <-> string
scattered mapping assembly

/* right now we only support single word instructions */
val code_word : (ast, instruction_predicate) <-> bits(16)
scattered mapping code_word
