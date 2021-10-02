/* Challenge 01: Cipher */

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Constants */

const char      *KEY = "UNIX";
const size_t LETTERS = 26;

/* Functions */

void decrypt(char *text) {
    for (int i = 0; i < strlen(text); i++) {
    	int c = text[i] - 'A';
    	int k = KEY[i % strlen(KEY)] - 'A';
    	int t = (LETTERS + c - k) % LETTERS;

    	text[i] = 'A' + t;
    }
}

/* Main Execution */

int main(int argc, char *argv[]) {
    char username[BUFSIZ];
    char password[BUFSIZ];

    /* Read Input */
    scanf("Username: %s\n", username);
    scanf("Password: %s\n", password);

    /* Decrypt Inputs */
    decrypt(username);
    decrypt(password);

    /* Output Results */
    printf("Username: %s\n", username);
    printf("Password: %s\n", password);

    return EXIT_SUCCESS;
}
