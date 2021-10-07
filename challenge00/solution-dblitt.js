// Solution to Challenge 00 Javascript (Node.js)
// Copyright (c) 2021 Daniel Blittschau

// Run with `echo '1 1 3 6 1 1 5 2' | node solution-dblitt.js`

const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

const programInput = [];

rl.on('line', input => {
  programInput.push(input);
  if (programInput.length >= 1) {
    const board = [];
    const boardInput = programInput[0].split(' ');
    for (let i = 0; i < boardInput.length; i++) {
      board.push({
        'number': Number(boardInput[i]),
        'used': false
      });
    }
    let haveHitLastDrink = false;
    let drinkCounter = 0;
    for (let i = 0; i < board.length; i++) {
      // find the largest boi (unused) on the board
      let largestUnusedIndex = 0;
      for (let j = 0; j < board.length; j++) {
        if (board[j].number > board[largestUnusedIndex].number || board[largestUnusedIndex].used) {
          largestUnusedIndex = j;
        }
      }
      // move this large boi to the spot we are on
      array_move(board, largestUnusedIndex, i);
      // mark it as used
      board[i].used = true;
      // jump to the farthest drink we can go to
      i += (board[i].number - 1);
      // unless... we are hitting the last drink and haven't before
      if (i >= board.length && !haveHitLastDrink) {
        i = board.length - 2;
        haveHitLastDrink = true;
      }
      drinkCounter++;
    }
    // console.log('Tux must drink at least ' + drinkCounter + ' time' + ((drinkCounter == 1) ? '' : 's') + '.');
    console.log('Part A: ' + drinkCounter);
    let boardDisplay = '';
    for (let i = 0; i < board.length; i++) {
      boardDisplay += String(board[i].number);
      if (i < board.length) {
        boardDisplay += ' ';
      }
    }
    // console.log('He will arrange the board to ' + boardDisplay);
    console.log('Part B: ' + boardDisplay);
  }
});

// https://stackoverflow.com/questions/5306680/move-an-array-element-from-one-array-position-to-another
function array_move(arr, old_index, new_index) {
  if (new_index >= arr.length) {
      var k = new_index - arr.length + 1;
      while (k--) {
          arr.push(undefined);
      }
  }
  arr.splice(new_index, 0, arr.splice(old_index, 1)[0]);
};