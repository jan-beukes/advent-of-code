package main

import "core:strings"
import "core:fmt"
import "core:crypto/legacy/md5"

INPUT: string : "ckczppom"

is_valid_p1 :: proc(hash: []u8) -> bool {
    for i in 0..<5 {
        nib := hash[i/2] & (0xf0 >> (4 * u8(i % 2)))
        if (nib != 0x0) {
            return false
        }
    }
    return true
}

is_valid_p2 :: proc(hash: []u8) -> bool {
    for i in 0..<3 {
        if (hash[i] != 0x0) {
            return false
        }
    }
    return true
}

main :: proc() {
    ctx: md5.Context

    buf: [255]u8
    copy(buf[:], INPUT)
    number := 0
    result: string
    // This is a pretty shitty brute force lol
    for {
        md5.init(&ctx)
        hash: [md5.DIGEST_SIZE]u8
        key := fmt.bprintf(buf[:], "%s%d", INPUT, number)
        md5.update(&ctx, buf[:len(key)])
        md5.final(&ctx, hash[:])

        if is_valid_p2(hash[:]) {
            result = key
            break
        }

        number += 1
    }

    fmt.printfln("Solution: %s", result)
}
