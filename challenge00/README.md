# Challenge 00: Drinks (Prequel)

To celebrate [Hacktoberfest], [Tux] decided to go to the pub with his friend
[Beastie].  Because [Tux] is a bit of a light-weight, [Beastie] likes to bully
the penguin by making [Tux] play the following drinking game:

Suppose there is a series of drinks arranged on a board as follows:

    1 3 7 4 2
    
Each number corresponds to a drink and indicates the maximum relative number of
spots on the board from which you can choose your next drink.  For instance,
beginning at the first drink `1`, you can only choose the next drink, `3`.
From `3`, however, you can choose either `7`, `4`, or `2` (that is, `1`, `2`,
or `3` spaces away).

The idea behind the game is to challenge the player to start with the first
drink and go across the board following the rules above until they reach the
last drink.  The player must drink all the beverages in all the spots they
choose (including the first and last).

Given that [Tux] is a bit of a light-weight, he is interested in determining
the minimum number of drinks he would have to imbibe to get across the whole
board.

- **Part A**: What is the minimum number of drinks [Tux] must have to cross the
  board?
  
    In the sample above, the minimum number of drinks is `3`: [Tux] would first
    drink `1`, then `3`, and finally `2`.
  
- **Part B**: As a concession to [Tux], [Beastie] allows [Tux] to rearrange the
  drinks on the board.  What is the minimum number of drinks [Tux] must have to
  cross the board if he can rearrange the drinks?
  
    In the sample above, [Tux] can rearrange the drinks as follows:
    
        7 1 3 4 2
        
    In this arrangement, [Tux] only needs to take `2` drinks: first the `7` and
    then the `2`.

## Input

You will be given the drinks in the following format:

    1 1 3 6 1 1 5 2

## Output

You should output the solutions to the two questions above in the following
format:

    Part A: ??
    Part B: ??
    
The first line should output the minimum number of drinks [Tux] must have to
cross the board with the input as given.  The second line should output the
minimum number of drinks [Tux] must have to cross the board if he can rearrange
the inputs to minimize the total number of drinks.

[Tux]: https://en.wikipedia.org/wiki/Tux_(mascot)
[jail]: https://en.wikipedia.org/wiki/FreeBSD_jail
[Beastie]: https://en.wikipedia.org/wiki/BSD_Daemon
[hacktoberfest]: https://hacktoberfest.digitalocean.com/
