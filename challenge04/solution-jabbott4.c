#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <stdbool.h>

#define TILE '.'
#define WIRE 'w'
#define JAIL 'j'
#define EXIT 'x'

// Comment the line below to show debug output.
#define NDEBUG
#ifndef NDEBUG
#define DEBUG(X, ...) \
    fprintf(stderr, "[%ld] (DEBUG) " X "\n", time(NULL), ##__VA_ARGS__)
#else
#define DEBUG(X, ...)
#endif // NDEBUG

#define MIN(X, Y) (((X) < (Y)) ? (X) : (Y))

#define REVIX(Y, X, I, N) ( \
    {                       \
        Y = (I) / (N);      \
        X = (I) % (N);      \
    })

#define INDEX(Y, X, N) ((Y) * (N) + (X))
#define CHOMP(S) (                      \
    {                                   \
        size_t n = (S) ? strlen(S) : 0; \
        if (n)                          \
        {                               \
            S[n - 1] = '\0';            \
        }                               \
        S;                              \
    })

typedef struct
{
    int x;
    int y;
} Point;

typedef struct
{
    char **rows;
    Point dims;
    Point jail;
    Point exit;
} Maze;

// Read into structure from stream.
void maze_read(Maze *maze, FILE *stream)
{
    char line[BUFSIZ];
    bool found_jail = false;
    bool found_exit = false;

    while (!feof(stream) && fgets(line, sizeof(line), stream) && CHOMP(line))
    {
        ++maze->dims.y;
        maze->rows = realloc(maze->rows, maze->dims.y * sizeof(char *));
        assert(maze->rows);

        // Append string on back of expanding array.
        char *copy = strdup(line);
        assert(copy);
        maze->rows[maze->dims.y - 1] = copy;

        // Ensure strings are of consistent, equal length.
        int x = strlen(line);
        assert(maze->dims.x ? (maze->dims.x == x) : 1);
        maze->dims.x = x;

        // See if we found the jail.
        char *found = strchr(line, JAIL);
        if (found)
        {
            found_jail = true;
            maze->jail.y = maze->dims.y - 1;
            maze->jail.x = found - line;
        }

        // See if we found the exit.
        found = strchr(line, EXIT);
        if (found)
        {
            found_exit = true;
            maze->exit.y = maze->dims.y - 1;
            maze->exit.x = found - line;
        }
    }

    assert(maze->dims.y);
    assert(maze->dims.x);

    assert(found_jail);
    assert(found_exit);

    DEBUG("Maze dimensions are (%d, %d)", maze->dims.y, maze->dims.x);
    DEBUG("Jail is @ (%d, %d)", maze->jail.y, maze->jail.x);
    DEBUG("Exit is @ (%d, %d)", maze->exit.y, maze->exit.x);
}

/**
 * \param distance Current minimum distance to reach all nodes
 * \param visited What nodes have already been visited
 * \param m Number of rows
 * \param n Number of columns
 * \return Index of non-visited minimum distance; otherwise, -1
 */
int next_index(int *distance, bool *visited, int m, int n)
{
    int min = 0x7fffffff;
    int index = -1;

    for (int i = 0; i < (m * n); ++i)
    {
        if (!visited[i] && (distance[i] <= min))
        {
            min = distance[i];
            index = i;
        }
    }

    return index;
}

/**
 * \return -1 if exit can't be reached; otherwise, number of required tiles.
 */
int part_a(Maze *maze)
{
    int m = maze->dims.y;
    int n = maze->dims.x;

    int *distance = malloc(m * n * sizeof(int));
    bool *visited = malloc(m * n * sizeof(bool));

    for (int i = 0; i < (m * n); ++i)
    {
        distance[i] = 0x0fffffff; // A large integer
        visited[i] = false;
    }

    distance[INDEX(maze->jail.y, maze->jail.x, n)] = 1;

    for (int count = 0; count < (m * n); ++count)
    {
        int index = next_index(distance, visited, m, n);
        visited[index] = true;

        int y, x;
        REVIX(y, x, index, n);
        int new = distance[INDEX(y, x, n)] + 1;

        // Left
        if ((x > 0) && (maze->rows[y][x - 1] != WIRE))
            distance[INDEX(y, x - 1, n)] = MIN(distance[INDEX(y, x - 1, n)], new);

        // Right
        if ((x < n - 1) && (maze->rows[y][x + 1] != WIRE))
            distance[INDEX(y, x + 1, n)] = MIN(distance[INDEX(y, x + 1, n)], new);

        // Up
        if ((y > 0) && (maze->rows[y - 1][x] != WIRE))
            distance[INDEX(y - 1, x, n)] = MIN(distance[INDEX(y - 1, x, n)], new);

        // Down
        if ((y < m - 1) && (maze->rows[y + 1][x] != WIRE))
            distance[INDEX(y + 1, x, n)] = MIN(distance[INDEX(y + 1, x, n)], new);
    }

    int result = distance[INDEX(maze->exit.y, maze->exit.x, n)];

    free(distance);
    free(visited);

    return (result == 0x0fffffff) ? -1 : result;
}

/**
 * \return -1 if exit can't be reached; otherwise, number of required tiles.
 */
int part_b(const Maze *maze)
{
    int m = maze->dims.y;
    int n = maze->dims.x;

    int *distance = malloc(m * n * sizeof(int));
    bool *visited = malloc(m * n * sizeof(bool));

    for (int i = 0; i < (m * n); ++i)
    {
        distance[i] = 0x0fffffff; // A large integer
        visited[i] = false;
    }

    distance[INDEX(maze->jail.y, maze->jail.x, n)] = 1;

    // Refactoring could be done here; why repeat almost all of Part A?
    for (int count = 0; count < (m * n); ++count)
    {
        int index = next_index(distance, visited, m, n);
        visited[index] = true;

        int y, x;
        REVIX(y, x, index, n);

        // Left
        if (x > 0)
        {
            int base = distance[INDEX(y, x, n)];
            int cost = (maze->rows[y][x - 1] == WIRE) ? 2 : 1;
            distance[INDEX(y, x - 1, n)] = MIN(distance[INDEX(y, x - 1, n)], base + cost);
        }

        // Right
        if (x < n - 1)
        {
            int base = distance[INDEX(y, x, n)];
            int cost = (maze->rows[y][x + 1] == WIRE) ? 2 : 1;
            distance[INDEX(y, x + 1, n)] = MIN(distance[INDEX(y, x + 1, n)], base + cost);
        }

        // Up
        if (y > 0)
        {
            int base = distance[INDEX(y, x, n)];
            int cost = (maze->rows[y - 1][x] == WIRE) ? 2 : 1;
            distance[INDEX(y - 1, x, n)] = MIN(distance[INDEX(y - 1, x, n)], base + cost);
        }

        // Down
        if (y < m - 1)
        {
            int base = distance[INDEX(y, x, n)];
            int cost = (maze->rows[y + 1][x] == WIRE) ? 2 : 1;
            distance[INDEX(y + 1, x, n)] = MIN(distance[INDEX(y + 1, x, n)], base + cost);
        }
    }

    int result = distance[INDEX(maze->exit.y, maze->exit.x, n)];

    free(distance);
    free(visited);

    return (result == 0x0fffffff) ? -1 : result;
}

// Deletes internal strings.
void maze_cleanup(Maze *maze)
{
    for (int i = 0; i < maze->dims.y; ++i)
        free(maze->rows[i]);
    free(maze->rows);
}

int main(int argc, char **argv)
{
    Maze maze = {0};
    maze_read(&maze, stdin);

    int a = part_a(&maze);
    int b = part_b(&maze);

    printf("Part A: %d\n", a);
    printf("Part B: %d\n", b);

    maze_cleanup(&maze);
    return EXIT_SUCCESS;
}