#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

typedef enum {
    ENABLE,
    DISABLE,
    TOGGLE,
} Action;

typedef struct {
    uint32_t x;
    uint32_t y;
} Point;

#define GRID_SIZE 1000
bool grid[GRID_SIZE*GRID_SIZE];

#define SET_GRID(x, y, val)  grid[y*GRID_SIZE + x] = (val)
#define GET_GRID(x, y)      (grid[y*GRID_SIZE + x])

void set_range(Action action, Point start, Point end)
{
    for (uint32_t y = start.y; y <= end.y; y++) {
        for (uint32_t x = start.x; x <= end.x; x++) {
            switch (action) {
                case ENABLE:  SET_GRID(x, y, true); break;
                case DISABLE: SET_GRID(x, y, false); break;
                case TOGGLE:  SET_GRID(x, y, !GET_GRID(x, y)); break;
            }
        }
    }
}

int get_enabled_count()
{
    int count = 0;
    for (int y = 0; y < GRID_SIZE; y++) {
        for (int x = 0; x < GRID_SIZE; x++) {
            count += GET_GRID(x, y);
        }
    }
    return count;
}

bool starts_with(char *s1, char *s2)
{
    return strncmp(s1, s2, strlen(s2)) == 0;
}

int main()
{
    char buf[1024];
    char *line = NULL;
    while ((line = fgets(buf, 1024, stdin))) {
        char action_buf[64];
        Point start, end;
        Action action;

        int res = sscanf(line, "%[^0-9]%u,%u through %u,%u", action_buf,
                &start.x, &start.y, &end.x, &end.y);
        if (res < 5) break;
        if (starts_with(action_buf, "turn on")) {
            action = ENABLE;
        } else if (starts_with(action_buf, "turn off")) {
            action = DISABLE;
        } else {
            action = TOGGLE;
        }
        set_range(action, start, end);
    }
    int count = get_enabled_count();

    printf("Part 1: %d\n", count);

    return 0;
}
