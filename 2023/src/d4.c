#include <stdio.h>
#include <string.h>
#include <stdlib.h>


#define MAX_LINES 256
#define LINE_LEN 256

int contains(int a, int *arr, int count) {
    for (int i = 0; i < count; i++) {
        if (arr[i] == a) return 1;
    }

    return 0;
}

int get_line_result(char *line, int line_num) {
    int nums[LINE_LEN/2];
    int winning[LINE_LEN/2];

    char *cursor = strchr(line, ':') + 1;
    int num_count = 0;
    while (*cursor != '|') {
        int n = strtol(cursor, &cursor, 10);
        while(*cursor == ' ') cursor++;
        
        nums[num_count++] = n;
    }
    cursor++;

    int win_count = 0;
    while (cursor < line + strlen(line)) {
        int n = strtol(cursor, &cursor, 10);

        while(*cursor == ' ') cursor++; 

        winning[win_count++] = n;
    }

    int result = 0;
    for (int i = 0; i < num_count; i++) {
        if (contains(nums[i], winning, win_count)) {
            result += 1;
        }
    }

    return result;

}

int main() {
    FILE *input = fopen("input4.txt", "r");
    
    char *lines[MAX_LINES];
    int count = 0;
    
    char buffer[LINE_LEN];
    while (count < MAX_LINES && fgets(buffer, LINE_LEN, input) != NULL) {
        buffer[strlen(buffer) - 1] = '\0';
        lines[count++] = strdup(buffer);
        //printf("%s\n", lines[count]);
    }
    int *coppies = calloc(count, sizeof(int));

    for (int line = 0; line < count; line++) {
        int copy_count = get_line_result(lines[line], line);
        for (int j = 1; j <= copy_count; j++) {
            coppies[line + j] += coppies[line] + 1;

        }
        
    }

    int total = 0;
    for (int i = 0; i < count; i++) {
        total += coppies[i] + 1;
    }

    printf("\nResult: %d\n", total);

    return 0;
}
