// Solution to Challenge 00 - Javascript (Node.js)
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
    // part A
    partABoard = programInput[0].split(' ').map(Number);
    // console.log(partABoard)
    let drinkCounter = 1;
    const drinkPossibilities = [];
    resolvePartialBoard(partABoard, 0, drinkPossibilities);
    let lowestAmount = drinkPossibilities[0];
    for (let i = 1; i < drinkPossibilities.length; i++) {
      if (drinkPossibilities[i] < lowestAmount) {
        lowestAmount = drinkPossibilities[i];
      }
    }
    console.log('Part A: ' + lowestAmount);

    // part B
    const board = [];
    const boardInput = programInput[0].split(' ');
    for (let i = 0; i < boardInput.length; i++) {
      board.push({
        'number': Number(boardInput[i]),
        'used': false
      });
    }
    let haveHitLastDrink = false;
    let drinkCounterB = 0;
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
      drinkCounterB++;
    }
    // console.log('Tux must drink at least ' + drinkCounterB + ' time' + ((drinkCounterB === 1) ? '' : 's') + '.');
    console.log('Part B: ' + drinkCounterB);
    let boardDisplay = '';
    for (let i = 0; i < board.length; i++) {
      boardDisplay += String(board[i].number);
      if (i < board.length) {
        boardDisplay += ' ';
      }
    }
    // console.log('He will arrange the board to ' + boardDisplay);
  }
});

function resolvePartialBoard(board, drinksSoFar, drinkPossibilities) {
  // board is an array of Numbers
  // drinksSoFar is the number of iterations so far
  // drinkPossibilities is an array that will have all possible values

  // base case??

  // console.log(board)
  if (board.length === 0)
  drinkPossibilities.push(drinksSoFar+1)
  // always start with the first thing
  for (let i = 1; i <= board[0]; i++) {
    // i starts at 1 because board values cannot be <1
    resolvePartialBoard(board.slice(i, board.length), drinksSoFar+1, drinkPossibilities);
  }
}

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