#include <stdio.h>
#include <string.h>
#include <stdint.h>

int main() {
    uint32_t arr1[] = {1, 3, 2, 5};
    uint32_t arr2[] = {1, 3, 100, 1244, 2};

    printf("%d\n", arr2 - arr1);

}