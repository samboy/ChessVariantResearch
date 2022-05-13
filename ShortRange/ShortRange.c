// Public domain 2022 by Sam Trenholme
#include <stdint.h>
#include <stdio.h>

// Count the number of squares a piece can move to (count the number
// of 1 bits in a number)
int countMoves(int_fast32_t piece, int max) {
	int count = 0;
	while(piece != 0) {
		if(piece & 1) {
			count++;
		}
		piece >>= 1;
	}
	if(count > max) {
		count = max;
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
	int_fast32_t moves[32];
	int_fast64_t grandTotal = 0;
	for(a = 0 ; a < 32 ; a++) {
		moves[a] = 0;
	}
	for(a = 0 ; a <= 0xffffff ; a++) {
		if((a & 0x10140) == 0x10140 || // Y
		   (a & 0x4400a) == 0x4400a || // Crab
		   (a & 0x11880) == 0x11880 // Wazir
		   ) {
		   	count++;
			moves[countMoves(a,30)]++;
			//showPiece(a); puts("");
		}
	}
	//showPiece(0x54422a); // Knight
	printf("%d known non-colorbound pieces\n",count);
	for(a = 0; a <= 28; a++) {
		grandTotal += (1 << a) * moves[a];
		if(moves[a] > 0) {
			printf("%6d pieces with %d moves\n",moves[a],a);
		}
	}
	printf("With riders, %d possible non-colorbound pieces\n",grandTotal);
}
