instruction sizes (un-RISC)
  1 word
  2 words
  3 words

address modes
  immediate data (imm)
  register direct (rx)
  capability displaced (cx[imm])
  capability indexed (cx[ry])
  capability indexed and displaced (cx[ry + imm])

14 bits left

| Name | Format                                  |
| ---- | --------------------------------------- |
| SSYS | ffff ffff ffff ffff                     |

| unallocated     | 0000 0000 0000 0000 |                             |        |
| halt            | 0000 0000 0000 0001 |                             |        |
| reserved        | 0000 0000 0000 xxxx |                             |        |
| nop             | 0000 0000 0001 0000 |                             |        |
| hint            | 0000 0000 0001 xxxx |                             |        |

| SI8  | ffff ffff iiii iiii                     | (10 bits?)

| b imm           | 0000 0001 iiii iiii |                             |        |
| b imm unless p0 | 0000 0010 iiii iiii |                             |        |
| b imm if p0     | 0000 0011 iiii iiii |                             |        |

(adjust-sp imm)

| SRI  | ffff ffff iiii dddd                     | (11 bits?)

| add rd, imm     | 0001 0000 iiii dddd |                             |        |
| sub rd, imm     | 0001 0001 iiii dddd |                             |        |
| and rd, imm     | 0001 0010 iiii dddd |                             |        |
| reserved        | 0001 0011 iiii dddd |                             |        |

| set.b rd, imm   | 0001 0100 iiii dddd |                             |        |
| set.w rd, imm   | 0001 0101 iiii dddd |                             |        |
| set.d rd, imm   | 0001 0110 iiii dddd |                             |        |
| set.q rd, imm   | 0001 0111 iiii dddd |                             |        |

(shift-left rd, imm)
(shift-right rd, imm)
(shift-right-arithmetic rd, imm)

(bit-set rd, imm)
(bit-test rd, imm)

| SRR  | ffff ffff aaaa dddd                     | (12 bits?)

| mov rd, ra          | 0010 0000 aaaa dddd |                         |        |
| mov cd, ca          | 0010 0001 aaaa dddd |                         |        |
| mov pd, pa          | 0010 0010 aaaa dddd |                         |        |
| reserved            | 0010 0011 aaaa dddd |                         |        |
| add rd, ra          | 0010 0100 aaaa dddd |                         |        |
| sub rd, ra          | 0010 0101 aaaa dddd |                         |        |
| subf rd, ra         | 0010 0110 aaaa dddd |                         |        |
| mul rd, ra          | 0010 0111 aaaa dddd |                         |        |
| and rd, ra          | 0010 1000 aaaa dddd |                         |        |
| andc rd, ra         | 0010 1001 aaaa dddd |                         |        |
| or rd, ra           | 0010 1010 aaaa dddd |                         |        |
| xor rd, ra          | 0010 1011 aaaa dddd |                         |        |
| lt rd, ra           | 0010 1100 aaaa dddd |                         |        |
| lte rd, ra          | 0010 1101 aaaa dddd |                         |        |
| lt.u rd, ra         | 0010 1110 aaaa dddd |                         |        |
| lte.u rd, ra        | 0010 1111 aaaa dddd |                         |        |
| eq rd, ra           | 0011 0000 aaaa dddd |                         |        |
| neq rd, ra          | 0011 0001 aaaa dddd |                         |        |
| reserved            | 0011 0010 aaaa dddd |                         |        |
| reserved            | 0011 0011 aaaa dddd |                         |        |
| sl rd, ra           | 0011 0100 aaaa dddd |                         |        |
| sr rd, ra           | 0011 0101 aaaa dddd |                         |        |
| sra rd, ra          | 0011 0110 aaaa dddd |                         |        |
| reserved            | 0011 0111 aaaa dddd |                         |        |

| SR   | ffff ffff ffff dddd                     |

| blr cd              | 0011 1111 0000 dddd |                         | ?????? |
| b cd                | 0011 1111 0001 dddd |                         | ?????? |
| b cd unless p0      | 0011 1111 0010 dddd |                         | ?????? |
| b cd if p0          | 0011 1111 0011 dddd |                         | ?????? |
| reserved            | 0011 1111 0100 dddd |                         |        |
| reserved            | 0011 1111 0101 dddd |                         |        |
| reserved            | 0011 1111 0110 dddd |                         |        |
| reserved            | 0011 1111 0111 dddd |                         |        |
| reserved            | 0011 1111 1000 dddd |                         |        |
| reserved            | 0011 1111 1001 dddd |                         |        |
| eq rd, 0            | 0011 1111 1010 dddd |                         |        |
| neq rd, 0           | 0011 1111 1011 dddd |                         |        |
| eq rd, 0 unless p0  | 0011 1111 1100 dddd |                         |        |
| neq rd, 0 unless p0 | 0011 1111 1101 dddd |                         |        |
| eq rd, 0 if p0      | 0011 1111 1110 dddd |                         |        |
| neq rd, 0 if p0     | 0011 1111 1111 dddd |                         |        |

(call cd)

(not rd)
(neg rd)

(widen.sw rd)
(widen.sd rd)
(widen.sq rd)

(widen.zw rd)
(widen.zd rd)
(widen.zq rd)

(truncate.b rd)
(truncate.w rd)
(truncate.d rd)

(narrow.b rd)
(narrow.w rd)
(narrow.d rd)

| SMRR | ffff fbbb aaaa dddd                     |

| Name            | Encoding            | Description                 | Model  |
| --------------- | ------------------- |:--------------------------- | :----- |
| ld.b rd, cb[ra] | 0100 0bbb aaaa dddd |                             |        |
| st cb[ra], rd   | 0100 1bbb aaaa dddd |                             |        |
| ld.w rd, cb[ra] | 0101 0bbb aaaa dddd |                             |        |
| ld.b rd, sp[i]  | 0101 10ii iiii dddd |                             |        |
| ld.w rd, sp[i]  | 0101 11ii iiii dddd |                             |        |
| ld.d rd, cb[ra] | 0110 0bbb aaaa dddd |                             |        |
| ld.d rd, sp[i]  | 0110 10ii iiii dddd |                             |        |
| ld.q rd, sp[i]  | 0110 11ii iiii dddd |                             |        |
| ld.q rd, cb[ra] | 0111 0bbb aaaa dddd |                             |        |

| reserved        | 0111 10xx xxxx xxxx |                             |        |

| st sp[i], rd    | 0111 11ii iiii dddd |                             |        |

| SMRI | ffff faaa iiii dddd                     |

| Name            | Encoding            | Description                 | Model  |
| --------------- | ------------------- |:--------------------------- | :----- |
| ld.b rd, ca[i]  | 1000 0aaa iiii dddd |                             |        |
| st ca[i], rd    | 1000 1aaa iiii dddd |                             |        |
| ld.w rd, ca[i]  | 1001 0aaa iiii dddd |                             |        |
| st ca[i], cd    | 1001 1aaa iiii dddd |                             |        |
| ld.d rd, ca[i]  | 1010 0aaa iiii dddd |                             |        |
| ld cd, ca[i]    | 1010 1aaa iiii dddd |                             |        |
| ld.q rd, ca[i]  | 1011 0aaa iiii dddd |                             |        |
| ld cd, sp[i]    | 1011 10ii iiii dddd |                             |        |
| st sp[i], cd    | 1011 11ii iiii dddd |                             |        |
