# Challenge 02: Firmware

Having cracked the flimsy cipher in [Challenge 01](../challenge01), [Tux] is
now ready to login to the old computing console.  Unfortunately, this is a
really old machine with a busted (and proprietary) firmware that appears to be
stuck in an **infinite loop**.

Using his [reverse engineering] skills, [Tux] somehow manages to dump the
firmware in **binary text format** and realizes the code is consists of
instructions for a simple `16-bit` **IntCode** machine with the following
operations:

| Instruction   | Format              | Description                                             |
| ------------- | ------------------- | -----------                                             |
| ACC Value     | 01SV VVVV VVVV VVVV | Increase or decrease the machine's accumulator register |
| JMP Value     | 10SV VVVV VVVV VVVV | Perform a relative jump from the current instruction    |
| NOP Value     | 00SV VVVV VVVV VVVV | Do nothing                                              |

As noted above, this **IntCode** machine has a single **accumulator** register
that starts with the value `0`.  An `ACC` instruction such as `ACC +8` would
increase the **accumulator** by `8`, while `ACC -6` would decrease the
**accumulator** by `6`.  

A `JMP` instruction such as `JMP +2` would increase the machine's **program
counter** by two while `JMP -20` would decrease the machine's **program
counter** by twenty.  

**Note**: the other two instructions, `ACC` and `NOP` always increment the
**program counter** by one after execution.

Based on the information above, the `ACC +8` instruction would come in the
format:

    0100000000001000
        
Likewise, the `ACC -6` instruction would come in the format:
    
    0110000000000110
    
That is, the first two bits of each instruction denote the operation, the third
bit indicates the sign of the value (`0` for positive and `1` for negative),
while the remaining thirteen bits are the value itself.

For example, given the following firmware in binary text format:

    0000000000000000
    0100000000000001
    1000000000000100
    0100000000000011
    1010000000000011
    0110000001100011
    0100000000000001
    1010000000000100
    0100000000000110
    
This would translate to the following instructions:

    0. NOP +0
    1. ACC +1
    2. JMP +4
    3. ACC +3
    4. JMP -3
    5. ACC -99
    6. ACC +1
    7. JMP -4
    8. ACC +6
    
Tracing the program leads to the following sequence of operations:

1. The `NOP +0` does nothing.
2. The `ACC +1` increases the **accumulator** from `0` to `1`.
3. The `JMP +4` sets the **program counter** to `6`.
4. The `ACC +1` increases the **accumulator  from `1` to `2`.
5. The `JMP -4` sets the **program counter** to `3`.
6. The `ACC +3` increases the **accumulator** from `2` to `5`.
7. The `JMP -3` sets the **program counter** to `1`.

Because the machine has already executed the instruction at index `1`, there is
an **infinite loop** and thus the program will never terminate.  Unfortunately,
the current firmware on the console computer has such a bug, which prevents it
from turning on properly.

After some reflection, [Tux] believes that exactly one instruction in the
firmware is corrupted.  He determines the he could fix the **infinite loop** by
swapping one `JMP` instruction with an `NOP` or vice versa (none of the `ACC`
instructions are corrupted)... but he doesn't know exactly which one.

With this in mind, he goes about implementing an emulator for the `16-bit`
**IntCode** machine and then fixing the [bootcode] by swapping one instruction
at a time.

- **Part A**: Before fixing the [bootcode], emulate the instructions to
  determine: what is the value of the **accumulator** before any instruction is
  executed for a second time?
  
    In the sample firmware above, the **accumulator** would have a value of `5`
    before the emulator detected an **infinite loop*.
    
- **Part B**: Fix the [bootcode] by swapping one instruction at a time to
  determine: what is the value of the **accumulator** after the program
  properly terminates?
  
    In the sample firmware above, changing `JMP -4` to `NOP -4` would allow for
    the program to terminate and the **accumulator** would have a value of `8`
    at the end of the program.
    
## Input

You will given the [bootcode] in the binary text format described above.

## Output

After loading and running the [bootcode], output the answers to **Part A** and
**Part B** in the following format:

    Part A: Value in Accumulator
    Part B: Value in Accumulator

**Note**: This is based on [Advent of Code 2020: Day 8](https://adventofcode.com/2020/day/8).

[Tux]: https://en.wikipedia.org/wiki/Tux_(mascot)
[jail]: https://en.wikipedia.org/wiki/FreeBSD_jail
[Beastie]: https://en.wikipedia.org/wiki/BSD_Daemon
[hacktoberfest]: https://hacktoberfest.digitalocean.com/
[bootcode]: input.txt
[reverse engineering]: https://en.wikipedia.org/wiki/Reverse_engineering
