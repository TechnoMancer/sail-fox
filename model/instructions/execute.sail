/* returns whether an instruction was retired */
val execute : ast -> Retired
scattered function execute

function clause execute MOV(rd, ra) = {
  R(rd) = R(ra);

  RETIRE_SUCCESS
}

function clause execute MOVP(pd, pa) = {
  P(pd) = P(pa);

  RETIRE_SUCCESS
}

function clause execute ADD(rd, ra, rb) = {
  R(rd) = R(ra) + R(rb);

  RETIRE_SUCCESS
}

function clause execute SUB(rd, ra, rb) = {
  R(rd) = R(ra) - R(rb);

  RETIRE_SUCCESS
}

function clause execute BRANCH_S(imm) = {
  match block_target {
    None() => block_target = Some(instruction_address + branch_extend(imm)),
    _ => ()
  };

  RETIRE_SUCCESS
}

function clause execute BLOCK_S(_, _, _) = {
  RETIRE_FAIL
}

function clause execute BRANCHL_S(imm) = {
  lr = instruction_address + block_remaining;

  execute(BRANCH_S(imm))
}

function clause execute EQ_Z(pd, ra) = {
  P(pd) = (R(ra) == 0b0000_0000_0000_0000);

  RETIRE_SUCCESS
}

function clause execute NEQ_Z(pd, ra) = {
  P(pd) = (R(ra) != 0b0000_0000_0000_0000);

  RETIRE_SUCCESS
}

function clause execute EQ(pd, ra, rb) = {
  P(pd) = (R(ra) <_s R(rb));

  RETIRE_SUCCESS
}

function clause execute NEQ(pd, ra, rb) = {
  P(pd) = (R(ra) <_s R(rb));

  RETIRE_SUCCESS
}

function clause execute LT(pd, ra, rb) = {
  P(pd) = (R(ra) <_s R(rb));

  RETIRE_SUCCESS
}

function clause execute LTE(pd, ra, rb) = {
  P(pd) = (R(ra) <=_s R(rb));

  RETIRE_SUCCESS
}

function clause execute LTU(pd, ra, rb) = {
  P(pd) = (R(ra) <_u R(rb));

  RETIRE_SUCCESS
}

function clause execute LTEU(pd, ra, rb) = {
  P(pd) = (R(ra) <=_u R(rb));

  RETIRE_SUCCESS
}

function clause execute AND(rd, ra, rb) = {
  R(rd) = R(ra) & R(rb);

  RETIRE_SUCCESS
}

function clause execute ANDC(rd, ra, rb) = {
  R(rd) = R(ra) & ~(R(rb));

  RETIRE_SUCCESS
}

function clause execute OR(rd, ra, rb) = {
  R(rd) = R(ra) | R(rb);

  RETIRE_SUCCESS
}

function clause execute XOR(rd, ra, rb) = {
  R(rd) = R(ra) ^ R(rb);

  RETIRE_SUCCESS
}

function clause execute ADD_S(rd, imm) = { R(rd) = R(rd) + unsigned_extend(16, imm); RETIRE_SUCCESS }
function clause execute SUB_S(rd, imm) = { R(rd) = R(rd) - unsigned_extend(16, imm); RETIRE_SUCCESS }
function clause execute AND_S(rd, imm) = { R(rd) = R(rd) & signed_extend(16, imm); RETIRE_SUCCESS }
function clause execute SET_S(rd, imm) = { R(rd) = sign_extend(16, imm); RETIRE_SUCCESS }

function clause execute HALT() = { halted = true; RETIRE_SUCCESS }
function clause execute NOP() = { RETIRE_SUCCESS }
function clause execute HINT(_) = { RETIRE_SUCCESS }

/* TODO: Actually handle this maybe? */
function clause execute (UNALLOCATED(s)) = {
  halted = true;
  RETIRE_FAIL
}

end execute
