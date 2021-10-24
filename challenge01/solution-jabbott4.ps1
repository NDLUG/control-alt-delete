# Read username and password and remove prefixes.
$EncryptedUsername = Read-Host
$EncryptedPassword = Read-Host
$EncryptedUsername = $EncryptedUsername -replace "Username: "
$EncryptedPassword = $EncryptedPassword -replace "Password: "

Function Decrypt-Vigenere($Key, $Encrypted) {
	# Modify encrypted array in-place.
	$Encrypted = $Encrypted.toCharArray()
	for ($i = 0; $i -lt $Encrypted.Length; $i++)
	{
		$EncryptedIndex = $Encrypted[$i] - [byte][char]'A'
		$KeyIndex       = $Key[$i % $Key.Length] - [byte][char]'A'
		$DecryptedIndex = (26 + $EncryptedIndex - $KeyIndex) % 26
		$Encrypted[$i]  = ([byte][char]'A' + $DecryptedIndex)
	}
	# Convert to a string.
	$Encrypted -join ""
}

$DecryptedUsername = Decrypt-Vigenere "UNIX" $EncryptedUsername
$DecryptedPassword = Decrypt-Vigenere "UNIX" $EncryptedPassword

Write-Output ("Username: {0}" -f $DecryptedUsername)
Write-Output ("Password: {0}" -f $DecryptedPassword)
