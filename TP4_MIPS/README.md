_MIPS instructions are grouped by their semantics on this page._

_If you want to get a list of instructions sorted by their opcodes, please check our [C++ code file](https://github.com/MIPT-ILab/mipt-mips/blob/master/simulator/mips/mips_instr.cpp)_

_If you want to see instructions in alphabet order, you may want to use [MIPS IV reference](http://math-atlas.sourceforge.net/devel/assembly/mips-iv.pdf)_

## Instruction format ##

MIPS is a RISC processor, so every instruction has the same length — 32 bits (4 bytes). These bits have different meanings according to their displacement. They can be combined in following groups:

| **Name** | **Size in bits** | **Symbol** | **Used for** |
|:---------|:---------|:-----------|:-------------|
| Opcode   | 6  | `E`        | Specification of instruction |
| Register specifications | 5 | `s`,`t`,`d` | _see below_  |
| Register-immediate  | 5 | `R` | Second part of opcode for instructions with 0x1 opcode |
| Shamt    | 5    | `S`        | Constant value for shifts |
| Immediate constant value | 16  | `C`        | Immediate value for arithmetic and logical (AL) operations |
| Address  | 26    | `A`        | Address for jumps and procedure calls |
| Funct    | 6     | `f`        | Second part of opcode for instructions with 0x0 opcode |

|Note: Even 26-bit field is called Address, it is never used for loads and stores! |
|:--------------------------------------------------------------------------------:|

Additionally, in tables below we may specify values explicitly:
  * `0|1` — plain bit values
  * `-` — ignored values

### Register specificators ###

Register specificators are addresses of registers. They provide numbers of registers have source data and where machine should write result of instruction. MIPS supports instructions with up to 3 registers. They are named:

  * s-register _(source)_
  * t-register _(target)_
  * d-register _(destination)_

|Note: `s-` and `t-` registers **do not** correspond to `s0-s7` and `t0-t7` registers described on [MIPS Registers page](MIPS-registers). Here it is just notation|
|:----------------------------------------------------------------------------------------------------------------------------------------------------------:|

Address of register consists of 5 bits, so there can be 32 usable logical registers on one core.

### Types of format ###

MIPS supports 4 main types of instruction format: R, I, RI, and J.

| **Type name** | **Max amount of registers** | **Immediate size** | **Instruction bits** | **Used for** |
|:--------------|:----------------------------|:-------------------|:---------------------|:-------------|
| R             | 3                           | 5 bits             |`000000ss sssttttt dddddSSS SSffffff` | AL and shift operations on registers |
| RI            | 1                           | 16 bits            | `000001ss sssRRRRR CCCCCCCC CCCCCCCC` | Branches|
| I             | 2                           | 16 bits            | `EEEEEEss sssttttt CCCCCCCC CCCCCCCC` | AL operations with immediate values, load/stores, branches|
| J             | 0                           | 26 bits            | `EEEEEEAA AAAAAAAA AAAAAAAA AAAAAAAA` | Unconditional branches, procedure calls|

----
# ALU

## Add/subtract

All R-type

| **Name** | **Syntax** | **C code** | **Funct** | **Full format** |
|:---------|:--------------------|:-------------------|:-----------------|:----------------|
| add unsigned | addu $d, $s, $t | d = t + s | 0x21 | `000000ss`<br/>`sssttttt`<br/>`ddddd---`<br/>`--100001` |
| substract unsigned | subu $d, $s, $t | d = t - s | 0x23 | `000000ss`<br/>`sssttttt`<br/>`ddddd---`<br/>`--100011` |

All I-type

| **Name** | **Syntax** | **C code** | **Opcode** | **Full format** |
|:---------|:--------------------|:-------------------|:-----------------|:----------------|
| add immediate | addi $t, $s, C | t = s + C | 0x8 | `001000ss`<br/>`sssttttt`<br/>`CCCCCCCC`<br/>`CCCCCCCC` |

## Shifts
All R-type

| **Name** | **Syntax** | **C code** | **Funct** | **Full format** |
|:---------|:--------------------|:-------------------|:-----------------|:----------------|
| shift left logical immediate | sll $d, $t, S | d = t << S | 0x0 | `000000--`<br/>`---ttttt`<br/>`dddddSSS`<br/>`SS000000` |
| shift right logical immediate | srl $d, $t, S | d = t >> S | 0x2 | `000000--`<br/>`---ttttt`<br/>`dddddSSS`<br/>`SS000010` |
| shift right arithmetic immediate | sra $d, $t, S | d = (int32)t >> S | 0x3 | `000000--`<br/>`---ttttt`<br/>`dddddSSS`<br/>`SS000011` |
| shift left logical | sllv $d, $t, $s | d = t << s | 0x4 | `000000ss`<br/>`sssttttt`<br/>`ddddd---`<br/>`--000100` |
| shift right logical | srlv $d, $t, $s | d = t >> s |  0x6 | `000000ss`<br/>`sssttttt`<br/>`ddddd---`<br/>`--000110` |
| shift right arithmetic | srav $d, $t, $s | d = (int32)t >> s | 0x7 | `000000ss`<br/>`sssttttt`<br/>`ddddd---`<br/>`--000111` |

## Comparisons

All R-type

| **Name** | **Syntax** | **C code** | **Funct** | **Full format** |
|:---------|:--------------------|:-------------------|:-----------------|:----------------|
| set on less than | slt $d, $t, $s | d = (s < t) | 0x2A | `000000ss`<br/>`sssttttt`<br/>`ddddd---`<br/>`--101010` |

All I-type

| **Name** | **Syntax** | **C code** | **Opcode** | **Full format** |
|:---------|:--------------------|:-------------------|:-----------------|:----------------|
| set on<br/>less than<br/>immediate | slti $s, $t, C | t = (s < C) | 0xA | `001010ss`<br/>`sssttttt`<br/>`CCCCCCCC`<br/>`CCCCCCCC` |

## Logical operations

All R-type

| **Name** | **Syntax** | **C code** | **Funct** | **Full format** |
|:---------|:--------------------|:-------------------|:-----------------|:----------------|
| and | and $d, $t, $s | d = s & t | 0x24 | `000000ss`<br/>`sssttttt`<br/>`ddddd---`<br/>`--100100` |
| or | or $d, $t, $s | d = s l t | 0x25 | `000000ss`<br/>`sssttttt`<br/>`ddddd---`<br/>`--100101` |
| xor | xor $d, $t, $s | d = s ^ t | 0x26 | `000000ss`<br/>`sssttttt`<br/>`ddddd---`<br/>`--100110` |
| nor | nor $d, $t, $s | d = ~ (s l t) | 0x27 | `000000ss`<br/>`sssttttt`<br/>`ddddd---`<br/>`--100111` |

All I-type

| **Name** | **Syntax** | **C code** | **Opcode** | **Full format** |
|:---------|:--------------------|:-------------------|:-----------------|:----------------|
| and with immediate | andi $s, $t, C | t = s & C | 0xC | `001100ss`<br/>`sssttttt`<br/>`CCCCCCCC`<br/>`CCCCCCCC` |
| or with immediate | ori $s, $t, C | t = s l C | 0xD | `001101ss`<br/>`sssttttt`<br/>`CCCCCCCC`<br/>`CCCCCCCC` |
| xor with immediate | xori $s, $t, C | t = s ^ C | 0xE | `001110ss`<br/>`sssttttt`<br/>`CCCCCCCC`<br/>`CCCCCCCC` |
| load upper immediate | lui $t, C | t = C << 16 | 0xF | `001111--`<br/>`---ttttt`<br/>`CCCCCCCC`<br/>`CCCCCCCC` |

----
# Control Flow

## Conditional branches

All I-type

| **Name** | **Syntax** | **PC advance** | **Opcode** | **Full format** |
|:---------|:--------------------|:---------------|:---------|:-----------------|
| branch on equal | beq $s, $t, C | PC += 4;<br/> if (s == t)<br/> PC += (C << 2) | 0x4 | `000100ss`<br/>`sssttttt`<br/>`CCCCCCCC`<br/>`CCCCCCCC` |
| branch on not equal | bne $s, $t, C | PC += 4;<br/> if (s != t)<br/> PC += (C << 2) | 0x5 | `000101ss`<br/>`sssttttt`<br/>`CCCCCCCC`<br/>`CCCCCCCC` |

## Unconditional jumps

All J-type

| **Name** | **Syntax** | **C code** | **PC advance** | **Opcode** | **Full format** |
|:---------|:--------------------|:-------------------|:---------|:---------|:-----------------|
| jump | j A | | PC = (PC & 0xf0000000) l (A << 2) | 0x2 | `000010AA`<br/>`AAAAAAAA`<br/>`AAAAAAAA`<br/>`AAAAAAAA` |
| jump and link | jal A | ra = PC + 4 | PC = (PC & 0xf0000000) l (A << 2) | 0x3 | `000011AA`<br/>`AAAAAAAA`<br/>`AAAAAAAA`<br/>`AAAAAAAA` |

## Indirect jumps

All R-type

| **Name** | **Syntax** | **C code** | **PC advance** | **Funct** | **Full format** |
|:---------|:--------------------|:-------------------|:---------|:---------|:-----------------|
| jump register | jr $s | | PC = s | 0x8 | `000000ss`<br/>`sss-----`<br/>`--------`<br/>`--001000` |
| jump register and link | jalr $s, $d | d = PC + 4 | PC = s | 0x9 | `000000ss`<br/>`sss-----`<br/>`ddddd---`<br/>`--001001` |

----
# Memory

**All I-type unless noted otherwise**

## Loads

| **Name** | **Syntax** | **C code** | **Opcode** | **Full format** |
|:---------|:--------------------|:-------------------|:---------|:-----------------|
| load byte | lb $t, C($s) | `t = *(int8*)(s + C)`| 0x20 | `100000ss`<br/>`sssttttt`<br/>`CCCCCCCC`<br/>`CCCCCCCC` |
| load half word | lh $t, C($s) | `t = *(int16*)(s + C)` | 0x21 | `100001ss`<br/>`sssttttt`<br/>`CCCCCCCC`<br/>`CCCCCCCC` |
| load word | lw $t, C($s) | `t = *(int32*)(s + C)` | 0x23 | `100011ss`<br/>`sssttttt`<br/>`CCCCCCCC`<br/>`CCCCCCCC` |
| load byte unsigned | lbu $t, C($s) | `t = *(uint8*)(s + C)` | 0x24 | `100100ss`<br/>`sssttttt`<br/>`CCCCCCCC`<br/>`CCCCCCCC` |
| load half word unsigned | lhu $t, C($s) | `t = *(uint16*)(s + C)` | 0x25 | `100101ss`<br/>`sssttttt`<br/>`CCCCCCCC`<br/>`CCCCCCCC` |

## Stores

| **Name** | **Syntax** | **C code** | **Opcode** | **Full format** |
|:---------|:--------------------|:-------------------|:---------------|:----------------|
| store byte | sb $t, C($s) | `*(uint8*)(s + C) = (t & 0xff)` | 0x28 | `101000ss`<br/>`sssttttt`<br/>`CCCCCCCC`<br/>`CCCCCCCC` |
| store half | sh $t, C($s) | `*(uint16*)(s + C) = (t & 0xffff)` | 0x29 | `101000ss`<br/>`sssttttt`<br/>`CCCCCCCC`<br/>`CCCCCCCC` |
| store word | sw $t, C($s) | `*(uint32*)(s + C) = t` | 0x2B | `101011ss`<br/>`sssttttt`<br/>`CCCCCCCC`<br/>`CCCCCCCC` |

----
