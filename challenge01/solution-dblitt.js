// Solution to Challenge 01 - Javascript (Node.js)
// Copyright (c) 2021 Daniel Blittschau

// Run with `cat input.txt | node solution-dblitt.js`

const readline = require('readline');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false
});

const programInput = [];

rl.on('line', input => {
    programInput.push(input);
    if (programInput.length === 2) {
        main();
    }
})

let main = () => {
    const key = 'UNIX';
    let encryptedUsername = programInput[0].substring(10);
    let encryptedPassword = programInput[1].substring(10);
    console.log('Username: ' + decrypt(encryptedUsername, key));
    console.log('Password: ' + decrypt(encryptedPassword, key));
};

const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

let decrypt = (message, key) => {
    let plaintext = '';
    let keyIndex = 0;
    for (let i = 0; i < message.length; i++) {
        plaintext += alphabet[ (alphabet.indexOf(message[i]) - alphabet.indexOf(key[keyIndex]) + 26) % 26 ];
        keyIndex++;
        if (keyIndex == key.length) {
            keyIndex = 0;
        }
    }
    return plaintext;
};
