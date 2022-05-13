// Public domain 2022 by Sam Trenholme
#include <stdint.h>
#include <stdio.h>

// Count the number of squares a piece can move to (count the number
// of 1 bits in a number)
int countMoves(int_fast32_t piece) {
	int count;
	while(piece != 0) {
		if(piece & 1) {
			count++;
		}
		piece >>= 1;
	}
	return count;
}

// Show on standard output the moves of the piece as an ASCII diagram
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
		   (a | 0x39cce7) != 0x39cce7 && // No right move
		   (a | 0x8cdff) != 0x8cdff && // No SE move
		   (a | 0xffb310) != 0xffb310 && // No NW move
		   (a | 0x8633df) != 0x8633df && // No SW move
		   (a | 0xfbcc61) != 0xfbcc61 && // No NE move
		   (a | 0x924249) != 0x924249 && // 3-way A
		   (a | 0x4c8132) != 0x4c8132    // 3-way B
		) {
		   	count++;
			showPiece(a); puts("");
		}
	}
	showPiece(0x54422a); // Knight
	printf("%d non-colorbound pieces\n",count);
}
