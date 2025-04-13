all:
	nasm -f elf main.asm -o main.o
	gcc -m32 -c http_request.c -o http_request.o -lcurl
	gcc -m32 main.o http_request.o -o chatbot -lcurl

clean:
	rm -f *.o chatbot
