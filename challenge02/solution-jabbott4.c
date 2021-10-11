#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>

#define OP_MASK 0xc000
#define OP_SHIFT 14
#define SIGN_MASK 0x2000
#define VALUE_MASK 0x1fff

#define NOP 0
#define ACC 1
#define JMP 2

// Comment the line below to show debug output.
#define NDEBUG
#ifndef NDEBUG
#define DEBUG(X, ...) \
    fprintf(stderr, "[%ld] (DEBUG) " X "\n", time(NULL), ##__VA_ARGS__)
#else
#define DEBUG(X, ...)
#endif // NDEBUG

// Convert a binary string to an 16-bit integer.
int bstoi(const char *string)
{
    int mask = (1 << 15);
    int result = 0;

    for (int i = 0; i < strlen(string) && mask; ++i)
    {
        if (string[i] == '1')
        {
            result |= mask;
            mask >>= 1;
        }
        else if (string[i] == '0')
        {
            mask >>= 1;
        }
    }

    return result;
}

typedef struct
{
    int *code;
    int length;
    int acc;
    int pc;
} IntCode;

// Resets execution context (PC and ACC).
void ic_reset(IntCode *ic)
{
    ic->pc = 0;
    ic->acc = 0;
}

void ic_init(IntCode *ic)
{
    ic->code = NULL;
    ic->length = 0;
    ic_reset(ic);
}

// Read code into struct from stream.
void ic_read(IntCode *ic, FILE *fs)
{
    char line[BUFSIZ];

    while (!feof(fs) && fgets(line, sizeof(line), fs))
    {
        ++ic->length;
        ic->code = realloc(ic->code, sizeof(int) * ic->length);
        assert(ic->code); // Check the result of realloc.
        ic->code[ic->length - 1] = bstoi(line);
    }
}

// Return instruction pointed to by PC; -1 if program done.
int ic_fetch(IntCode *ic)
{
    return (ic->pc < ic->length) ? ic->code[ic->pc] : -1;
}

// Execute instruction; return new PC.
int ic_exec(IntCode *ic, int inst)
{
    int op = (inst & OP_MASK) >> OP_SHIFT;
    int newpc = ic->pc + 1;

    int value = VALUE_MASK & inst;
    if (SIGN_MASK & inst)
    {
        value *= -1;
    }

    switch (op)
    {
    case ACC:
    {
        DEBUG("\tacc += %d", value);
        ic->acc += value;
        break;
    }

    case JMP:
    {
        DEBUG("\tpc += %d", value);
        newpc = ic->pc + value;
        break;
    }
    }

    return newpc;
}

/**
 * @return true if no loop was detected; false if there was.
 */
bool ic_run(IntCode *ic)
{
    if (ic->length <= 0)
    {
        return true;
    }
    
    ic_reset(ic);

    bool noloop = true;

    bool *visited = calloc(ic->length, sizeof(bool));
    assert(visited); // Check result of calloc.

    int inst;
    while ((inst = ic_fetch(ic)) != -1)
    {
        DEBUG("ic_fetch(%d) -> 0x%04x", ic->pc, inst);

        if (visited[ic->pc])
        {
            DEBUG("Found loop at pc = %d", ic->pc);
            noloop = false;
            break;
        }
        else
        {
            visited[ic->pc] = true;
            ic->pc = ic_exec(ic, inst);
        }
    }

    free(visited);
    return noloop;
}

/**
 * @return true if loop could be fixed; false, otherwise.
 */
bool part_b(IntCode *ic)
{
    bool noloop = ic_run(ic);

    for (int i = 0; !noloop && (i < ic->length); ++i)
    {
        int inst = ic->code[i];
        int op = (inst & OP_MASK) >> OP_SHIFT;
        int newinst = (inst & ~OP_MASK);

        switch (op)
        {

        case ACC:
        {
            // We are only swapping JMPs and NOPs.
            continue;
        }

        case JMP:
        {
            DEBUG("Changing pc = %d, 0x%04x to 0x%04x", i, inst, newinst);
            newinst |= (NOP << OP_SHIFT);
            break;
        }

        case NOP:
        {
            newinst |= (JMP << OP_SHIFT);
            DEBUG("Changing pc = %d, 0x%04x to 0x%04x", i, inst, newinst);
            break;
        }
        }

        ic->code[i] = newinst;
        noloop = ic_run(ic);
        ic->code[i] = inst; // Restore instruction.
    }

    return noloop;
}

// Free code & reset state.
void ic_free(IntCode *ic)
{
    free(ic->code);
    ic->code = NULL;
    ic->length = 0;
    ic_reset(ic);
}

int main(int argc, char **argv)
{
    IntCode ic;
    ic_init(&ic);

    // 1. Read code from standard input.
    ic_read(&ic, stdin);
    DEBUG("Read %d instructions", ic.length);

    if (ic.length)
    {
        // 2. Part A: Execute code until we find a loop (or finish).
        ic_run(&ic);
        printf("Part A: %d\n", ic.acc);

        // 3. Part B: Try swapping JMPs and NOPs.
        bool noloop = part_b(&ic);
        printf("Part B: ");
        if (noloop)
            printf("%d\n", ic.acc);
        else
            printf("Cannot fix\n");
    }

    ic_free(&ic);
    return EXIT_SUCCESS;
}