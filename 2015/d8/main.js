const fs = require('fs');

function partOne(input) {
    let totalCodeSize = 0;
    let totalMemSize = 0;
    for (let line of input.split('\n')) {
        let memLength = 0;
        let mem = "";
        for (let i = 0; i < line.length; ++i) {
            ++memLength;
            if (line[i] === '\\') {
                switch (line[i + 1]) {
                    case '"':
                    case '\\':
                        ++i;
                        break;
                    case 'x':
                        i += 3;
                        break;
                }
            }
        }
        memLength -= 2;

        totalCodeSize += line.length;
        totalMemSize += memLength;
    }
    return totalCodeSize - totalMemSize;
}

function partTwo(input) {
    let totalStringSize = 0;
    let totalEncodedSize = 0;
    for (let line of input.split('\n')) {
        let encodedLength = line.length + 2;
        encodedLength += line.split('\\').length - 1;
        encodedLength += line.split('"').length - 1;

        totalStringSize += line.length;
        totalEncodedSize += encodedLength;
    }
    return totalEncodedSize - totalStringSize;
}

const input = fs.readFileSync('input.txt', 'utf8').trim();
console.log(`part one: ${partOne(input)}`);
console.log(`part two: ${partTwo(input)}`);
