/**
 * \author Jonathan Abbott
 * \brief Solution to NDLUG/control-alt-delete/challenge00/ in C
 */

#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

// Check the result of an allocation operation.
#define ALLOC_CHECK(P) (                            \
    {                                               \
        void *X = (P);                              \
        if (!X)                                     \
        {                                           \
            fprintf(stderr, "Download more RAM\n"); \
            abort();                                \
        }                                           \
        X;                                          \
    })

#define MIN(X, Y) (((X) > (Y)) ? (Y) : (X))
#define SWAP(T, A, X, Y) ( \
    {                      \
        T _tmp = A[X];     \
        A[X] = A[Y];       \
        A[Y] = _tmp;       \
    })

// Comment the line below to show debug output.
#define NDEBUG
#ifndef NDEBUG
#define DEBUG(X, ...) \
    fprintf(stderr, "[%ld] (DEBUG) " X "\n", time(NULL), ##__VA_ARGS__)
#else
#define DEBUG(X, ...)
#endif // NDEBUG

void part_a(const int *nums, int n)
{
    uint32_t *dp = ALLOC_CHECK(calloc(n, sizeof(uint32_t)));
    memset(dp + 1, 0xff, (n - 1) * sizeof(uint32_t)); // Maxify (?) each index
    dp[0] = 1;

    for (int i = 0; i < n; ++i)
    {
        uint32_t range = nums[i]; // How far can this drink take me?
        DEBUG("i = %d, dp[i] = %u, range = %u", i, dp[i], range);
        for (int j = i + 1; j < MIN(n, i + range + 1); ++j)
        {
            dp[j] = MIN(dp[j], dp[i] + 1);
            DEBUG("     j = %u, dp[j] = %u", j, dp[j]);
        }
    }

    printf("Part A: ");
    if (dp[n - 1] == 0xffffffffu)
        printf("Impossible\n");
    else
        printf("%u\n", dp[n - 1]);

    free(dp);
}

// Partition algorithm for quicksort
int part_b_partition(int *nums, int lo, int hi)
{
    int l = lo;
    int r = hi + 1;

    while (1) // While pointers have not crossed
    {
        // Find element (or not) that is greater than pivot
        while (nums[++l] < nums[lo])
            if (l == hi)
                break;

        // Find element (or not) that is less than pivot
        while (nums[lo] < nums[--r])
            if (r == lo)
                break;

        if (l >= r) // Pointers have crossed
            break;
        SWAP(int, nums, l, r);
    }

    // Put pivot in final destination
    SWAP(int, nums, lo, r);
    return r;
}

// Quicksort algorithm
void part_b_quicksort(int *nums, int lo, int hi)
{
    if (lo >= hi)
        return;

    int i = part_b_partition(nums, lo, hi);
    part_b_quicksort(nums, lo, i - 1);
    part_b_quicksort(nums, i + 1, hi);
}

void part_b(const int *nums, int n)
{
    int *copy = ALLOC_CHECK(calloc(n, sizeof(int)));
    memcpy(copy, nums, sizeof(int) * n);
    part_b_quicksort(copy, 0, n - 1);

    int next = n - 1;
    int where = 0;
    int amount = 0;
    while (next >= 0 && where < n - 1)
    {
        where += copy[next--];
        amount += 1;
    }

    printf("Part B: ");
    if (where < n - 1)
        printf("Impossible\n");
    else
        printf("%d\n", amount + 1);

    free(copy);
}

int main(int argc, char **argv)
{
    int *numbers = NULL;
    int number;
    int n = 0; // Length of numbers array

    // Read a number at a time from stdin
    while (!feof(stdin) && scanf("%u ", &number))
    {
        ++n;
        numbers = ALLOC_CHECK(realloc(numbers, sizeof(int) * n));
        numbers[n - 1] = number; // Put number at back of expanding array
    }

    DEBUG("Input length = %u numbers", n);

    if (n)
    {
        part_a(numbers, n);
        part_b(numbers, n);
    }

    free(numbers);

    return EXIT_SUCCESS;
}