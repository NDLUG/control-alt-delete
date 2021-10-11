// decrypt cipher given key using Vigenere cipher
// https://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher
package main

import (
	"fmt"
	"bufio"
	"os"
	"strings"
)

var KEY = []rune{'U', 'N', 'I', 'X'}

// Build table of all possible Caesar ciphers
func build_vigenere_table() map[int]map[int]int {
	m := make(map[int]map[int]int)
	for i := 0; i < 26; i++ {
		value := 0
		m2 := make(map[int]int)
		for j := i; j <  i + 26 ; j ++{
			m2[j % 26 + 65] = value + 65
			value += 1
		}
		m[i + 65] = m2
	}

	return m
}


func decrypt_vigenere(username string, table map[int]map[int]int) {
	// row in Vigenere table come from key, column from plaintext
	// M_i = (C_i - K_i%m) % l   --> m length key, l length alpha
	key_ind := 0
	rune_u := []rune(username)
	decrypted_runes := make([]rune, len(username))
	for i, c := range rune_u {
		// ex: given ciphertext U, keytext U, --> A
		//     given ciphertext Q, keytext N, table[Q][N] = D
		value := table[int(KEY[key_ind % 4])][int(c)]
		key_ind += 1
		decrypted_runes[i] = rune(value)
	}

	fmt.Println(string(decrypted_runes))
}


func main() {
	// Read Username and Password from stdin
	reader := bufio.NewReader(os.Stdin)
	_username, err := reader.ReadString('\n')
	if err != nil {
		fmt.Println("Error reading username line.", err)
	}
	_username = strings.TrimSuffix(_username, "\n")
	_password, err := reader.ReadString('\n')
	if err != nil {
		fmt.Println("Error reading password line.", err)
	}
	_password = strings.TrimSuffix(_password, "\n")

	username := strings.Split(_username, " ")[1]
	password := strings.Split(_password, " ")[1]

	// Build table and decrypt.
	m := build_vigenere_table()
	fmt.Printf("Username: ")
	decrypt_vigenere(username, m)
	fmt.Printf("Password: ")
	decrypt_vigenere(password, m)
}

