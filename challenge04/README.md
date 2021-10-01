# Challenge 04: Maze

Because he was able to figure out the **maximum concurrency** possible in
[Challenge 03](../challenge03), [Tux] applied just enough computing resources
to build the `jailbreak` program and its dependencies in parallel.

Reflecting on the process, [Tux] comes to the conclusion that building all
those packages wasn't too difficult, but it was tedious and [Tux] remembers why
he gave up running [Gentoo].

With the program compiled, [Tux] runs `jailbreak` on the computing console
and... He is free!!!

Except, as soon as he exits the [jail], he realizes he is in a deep and dark
tunnel.  Peering out into the void, he realizes the tunnel is part of a big and
complicated **maze** protected by a [WireGuard].

Fortunately for [Tux], the [WireGuard] appears to be elsewhere and there
happens to be a map of the maze on the floor.  Before [entering the void],
[Tux] decides to analyze the map an chart out the **shortest path** through the
tunnels.

The map [Tux] found is full of symbols that are arranged like this:

    j.....w
    w.w.w.w
    w.www.w
    ww....w
    w.w.www
    w.....x
    
[Tux] would need to find the **shortest path** from the [jail] (denoted by `j`)
to the exit (denoted by `x`).  The `.` marks tiles [Tux] can cross, while `w`
marks what [Tux] believes to be walls and thus impassable.

- **Part A**: Assuming `w` denotes a wall, what is the least number of tiles
  [Tux] must cross to exit the maze (including the starting and end tiles)?
  
    In the sample above, [Tux] would require `16` tiles as shown below:
    
        j*****w
        w.w.w*w
        w.www*w
        ww.***w
        w.w*www
        w..***x
        
- **Part B**: As [Tux] looks into the darkness of the tunnel, he realizes that
  the `w` on the map are not walls, but wires!  He can pass those tiles but it
  will take him twice as long since he has to use his trusty wire cutters to
  get through them.  Assuming `w` denotes a wire, what is the least number of
  tiles [Tux] must cross to exit the maze (including the starting and end
  tiles)?
  
    In the sample above, [Tux] would require `13` tiles as shown below:
    
        j*....w
        w*w.w.w
        w*www.w
        w*....w
        w*w.www
        w*****x
    
## Input

You will be given the full [Maze] with the symbols described above:
    
    ..w...w....................w.....w....w.........w..ww.w..www......w...w.........
    w..................w............w.w..w....w.......w.....ww...w.......w.......www
    ....w..w...w..w.....................w...w....ww.....ww..w..ww.....w.w.w..w.w....
    ...........w..w...................w.w....w...ww..w..w.........w..w.....w.w....ww
    ..w.......w........ww..w............w.........w.w.w.........w..w........w......x
    ...w.......www..w..w.....................w..w.w....w.........w...ww......ww..www
    .w......w..w..w......wwwww......w..........w..w............w....ww....w....w....
    ...w..w...w....w.............ww..w.www........w.ww....w......ww......w.....ww...
    .....w.....w....www......w..w..w.w......w..w.w............w..........w..w.......
    .ww....w....w..w..w...........w......w.ww.......w.....w....w....w.w...w.....w.ww
    w.w..ww..w.......w...ww........w..w.w.w...........ww.w...ww....w..w....w.ww.w...
    j.w.......w..........w..w..w.w..ww........w..w.....w.....w...w.......w....w.....
    ...............w......w.w........w...............ww.w....w.....w...w......w.....
    ...........ww..............w..w..........w........w.w...w.w..w.w.w..............
    .....w..w..w.......w..........w.w.w.......w.........w....w....w..w..............
    ......w....w..w..w.....w...ww....ww..w..w.w......w.w.ww..w.w.........w.www...w..
    w.........w..ww......w.............www.ww.......ww...w......w....w...w...w......
    w........w.w.w.........w..........w..w...........w..........w.........w...w.....
    ...w..w.w..w.ww...w.......................w................w.w..w.w..w...w....w.
    ......w...ww...w...w...w....w.....w.w.w....w...ww.w......w....w.........w.....w.
    .....w.w.....ww......ww..w.....w.w.w....w...w..........w...............w..w...w.
    w....w.........w.w.w.....w..........w.w..w..ww.....w..w.......w...w....ww...wwww
    w..w.....ww.wwwww..ww....ww.w.....w......ww......w.....ww....www..w....w........
    ........w..w.w..w...w.w.......................w..w.w..........www...w....w....ww

## Output

After loading the [Maze], output the following information:

    Part A: ??
    Part B: ??
    
The first line should be least number of tiles [Tux] must cross to go from the
`jail` to the **exit**, assuming `w` denotes a **wall**.

The second line should be least number of tiles [Tux] must cross to go from the
`jail` to the **exit**, assuming `w` denotes a **wire**.

[Tux]: https://en.wikipedia.org/wiki/Tux_(mascot)
[jail]: https://en.wikipedia.org/wiki/FreeBSD_jail
[Beastie]: https://en.wikipedia.org/wiki/BSD_Daemon
[hacktoberfest]: https://hacktoberfest.digitalocean.com/
[BSD]: https://en.wikipedia.org/wiki/Berkeley_Software_Distribution
[Maze]: input.txt
[Gentoo]: https://www.gentoo.org/
[WireGuard]: https://www.wireguard.com/
[entering the void]: https://voidlinux.org/
