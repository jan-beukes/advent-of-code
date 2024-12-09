#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

bool is_safe(int *line, size_t count, int skip_index) {
    bool desc = false, desc_set = false;

    int start = skip_index == 0 ? 2 : 1;
    int first = line[start - 1];
    int prev = first;

    for (int i = start; i < count; i++) {
        if (i == skip_index) continue;
        int val = line[i];

        if (!desc_set) {
            desc = val < first;
            desc_set = true;
        }
        if ((desc && val > prev)|| (!desc && val < prev)) {
            return false;
        }
        int diff = desc ? prev - val : val - prev;
        if (!(1 <= diff && diff <= 3)) return false;
    
        prev = val;
    }

    return true;
}

size_t parse_nums(char *line, int *buff) {
    char *curr = line;
    size_t count = 0;

    do {
        int value = (int)strtol(curr, &curr, 10);
        buff[count++] = value;
    } while (*curr != '\0');

    return count;
    
}

int main() {
FILE *file = fopen("input.txt", "r");

    fseek(file, 0, SEEK_END);
    long size = ftell(file);
    fseek(file, 0, SEEK_SET);
    char contents[size];
    fread(contents, 1, size, file);
    fclose(file);

    char *state = contents;
    char *line;
    int safe_count = 0;
    while ((line = strtok_r(state, "\n", &state)) != NULL) {
        bool safe = false;
        int buff[128];
        size_t count = parse_nums(line, buff);

        if (is_safe(buff, count, -1)) safe = true;
        else {
            for (int i = 0; i < count; i++) {
                if (is_safe(buff, count, i)){
                    safe = true;
                    break;
            }
            }
        }

        if (safe) {
            safe_count++;
            printf("safe\n");
        } else printf("unsafe\n");
    }

    printf("result: %d\n", safe_count);
    return 0;
}
