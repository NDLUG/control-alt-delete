# Challenge 01: Cipher

[Tux] wakes up... and realizes he is trapped in a [jail].  Shaking his head,
[Tux] acknowledges that it was a mistake to celebrate [Hacktoberfest] with
[Beastie].  Partying with the daemon was usually a good time, but ever since
[Systemd] refused [Beastie], the daemon has been rather jealous of [Tux] and
was prone to lashing out at him.  

It seems like [Beastie] has finally gotten revenge on [Tux] by trapping him in
one of the daemon's infamous [jails].  Sighing, [Tux] cracks his fingers,
stretches, and gets to work on escaping his container.

His first step to escaping the [jail] is to get access to the old computing
console left in his container.  Fortunately for [Tux], [Beastie] is a bit old
school and prone to forgetting things, so the daemon wrote down the account
username and password on a sticky note next to the console:

    Username: UQUFH
    Password: CNUDLBWQ

Of course, [Beastie] didn't record the information in plaintext (he is old, but
no fool).  Instead the daemon encrypted the account information with a
[Vigenere Cipher] to obscure the real values from casuals (like the consultants
who try to convince him to switch to Windows).  

Being a true [hacker], [Tux] scoffs at this [security through obscurity] and
goes about decrypting the account information in order to get access to the
computing console.  

Before proceeding, however, [Tux] remembers that a [Vigenere Cipher] needs a
**key** for proper decryption and one is not written on the sticky note.  After
a brief moment of panic, however, [Tux] releases the key can only be one thing:

    UNIX
    
- **Part A**: What is the account name?
- **Part B**: What is the account password?

## Input

You will be given the encrypted information from the sticky note:

    Username: UQUFH
    Password: CNUDLBWQ

## Output

You should output the decrypted information in the following format:

    Username: ~decrypted~
    Password: ~decrypted~
    
**Note**: This is an old console, so all the letters in the username and
password are expected to be *capitalized*.

[Tux]: https://en.wikipedia.org/wiki/Tux_(mascot)
[jail]: https://en.wikipedia.org/wiki/FreeBSD_jail
[Beastie]: https://en.wikipedia.org/wiki/BSD_Daemon
[hacktoberfest]: https://hacktoberfest.digitalocean.com/
[Vigenere Cipher]: https://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher
[hacker]: https://en.wikipedia.org/wiki/Hacker
[security through obscurity]: https://en.wikipedia.org/wiki/Security_through_obscurity
