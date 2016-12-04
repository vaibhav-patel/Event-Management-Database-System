ecpg consolApp.pgc
gcc -w -o finalApp -I/usr/include/postgresql/ -L/usr/lib/postgresql/9.6/lib -lpq consolApp.c -lecpg
while true
do
	./finalApp	
	echo "hit [CTRL+C] to stop!"
done
