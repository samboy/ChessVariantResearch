// Public domain 2022 by Sam Trenholme
#include <stdint.h>
#include <stdio.h>

void showPiece(int_fast32_t piece) {
	int a;
	for(a=0;a<25;a++) {
		if(piece & 1) {
			printf("O ");
		} else {
			printf("- ");
		}
		if(a % 5 == 4) {
			puts("");
		}
		if(a == 11) {
			printf("X ");
			a++;
		}
		piece >>= 1;
	}
}

int main() {
	int_fast32_t a;
	int_fast32_t count = 0;
	for(a = 0 ; a <= 0xffffff ; a++) {
		// Make sure the piece can hit any square on the board
		// There are seven limitations
		if((a | 0xaaa555) != 0xaaa555 && // Bishop colorbound 
		   (a | 0xf83c1f) != 0xf83c1f && // Every other row bound
		   (a | 0xad66b5) != 0xad66b5 && // Every other file bound
		   (a | 0x3fff) != 0x3fff && // No backwards move
		   (a | 0xfffc00) != 0xfffc00 && // No forwards move
		   (a | 0xe7339c) != 0xe7339c && // No left move
		   (a | 0x39cce7) != 0x39cce7) { // No right move
		   	count++;
			showPiece(a); puts("");
		}
	}
	showPiece(0x54422a); // Knight
	printf("%d non-colorbound pieces\n",count);
}
