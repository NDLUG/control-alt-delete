name=input()
passwd=input()
KEY='UNIX'


name=(name.split())[1]
passwd=(passwd.split())[1]
dname=''
dpasswd=''

for i in range(len(name)):
	dname+=chr(((ord(name[i])-65-ord(KEY[i%len(KEY)])-65+26)%26)+65)

for i in range(len(passwd)):
	dpasswd+=chr(((ord(passwd[i])-65-ord(KEY[i%len(KEY)])-65+26)%26)+65)


print(f'Username: {dname}')
print(f'Password: {dpasswd}')
