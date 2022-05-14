// Public domain 2022 by Sam Trenholme
#include <stdint.h>
#include <stdio.h>

// Move a piece once
void moveTo(int_fast8_t *board, int moveTo, int square) {
	if(board[moveTo] < 0) {
		board[moveTo] = board[square] + 1;
	}
}

// Given an 8x8 board, and piece to move, and a square on
// said board, move the piece on the board
// Normally, I always use braces, but not with this code
void movePieceOnBoard(int_fast32_t piece, int_fast8_t *board, int square) {
	// Do nothing if a piece hasn’t moved to this square next
	if(board[square] < 0) 
		return;
	// Top row (north 2 squares)
	if((piece & 0x01) != 0 && square % 8 >= 2 && square > 15) 
		moveTo(board,square-18,square); // nw then nw	
	if((piece & 0x02) != 0 && square % 8 >= 1 && square > 15) 
		moveTo(board,square-17,square); // n then nw (Knight move)
	if((piece & 0x04) != 0 && square > 15) 
		moveTo(board,square-16,square); // n then n
	if((piece & 0x08) != 0 && square % 8 < 7 && square > 15) 
		moveTo(board,square-15,square); // n then ne (Knight move)
	if((piece & 0x10) != 0 && square % 8 < 6 && square > 15) 
		moveTo(board,square-14,square); // ne then ne
	// Second row (north 1 square)
	if((piece & 0x20) != 0 && square % 8 >= 2 && square > 7) 
		moveTo(board,square-10,square); // w then nw (Knight move)
	if((piece & 0x40) != 0 && square % 8 >= 1 && square > 7) 
		moveTo(board,square-9,square); // nw
	if((piece & 0x80) != 0 && square > 7) 
		moveTo(board,square-8,square); // n
	if((piece & 0x100) != 0 && square % 8 < 7 && square > 7) 
		moveTo(board,square-7,square); // ne
	if((piece & 0x200) != 0 && square % 8 < 6 && square > 7) 
		moveTo(board,square-6,square); // e then ne (Knight move)
	// Third row (left or right, no vertical move)
	if((piece & 0x400) != 0 && square % 8 >= 2) 
		moveTo(board,square-2,square); // w then w
	if((piece & 0x800) != 0 && square % 8 >= 1) 
		moveTo(board,square-1,square); // w
	if((piece & 0x1000) != 0 && square % 8 < 7) 
		moveTo(board,square+1,square); // e
	if((piece & 0x2000) != 0 && square % 8 < 6) 
		moveTo(board,square+2,square); // e then e
	// Fourth row (left to right, move south one square)
	if((piece & 0x4000) != 0 && square % 8 >= 2 && square < 56) 
		moveTo(board,square+6,square); // w then sw (Knight move)
	if((piece & 0x8000) != 0 && square % 8 >= 1 && square < 56) 
		moveTo(board,square+7,square); // sw
	if((piece & 0x10000) != 0 && square < 56) 
		moveTo(board,square+8,square); // s
	if((piece & 0x20000) != 0 && square % 8 < 7 && square < 56) 
		moveTo(board,square+9,square); // se 
	if((piece & 0x40000) != 0 && square % 8 < 6 && square < 56)
		moveTo(board,square+10,square); // e then se (Knight move)
	// Fifth row (left to right, move south two squares
	if((piece & 0x80000) != 0 && square % 8 >= 2 && square < 48) 
		moveTo(board,square+14,square); // sw then sw
	if((piece & 0x100000) != 0 && square % 8 >= 1 && square < 48)
		moveTo(board,square+15,square); // s then sw (Knight move)
	if((piece & 0x200000) != 0 && square < 48) 
		moveTo(board,square+16,square); // s then s
	if((piece & 0x400000) != 0 && square % 8 < 7 && square < 48) 
		moveTo(board,square+17,square); // s then se (Knight move)
	if((piece & 0x800000) != 0 && square % 8 < 6 && square < 48)
		moveTo(board,square+18,square);
}

// This determines if a given piece is colorbound on an 8x8 square.
// It does this by placing the piece on e4, then moving the piece
// around until it no longer can move to an unvisited square.
// If all of the squares are covered, the piece is not colorbound
// Input: the piece, in the form described in ShortRange.txt (24-bit int)
//        Whether to show the piece’s moves on standard output
// Output: The number of squares this piece covers (1-64)
int countReachable8x8(int_fast32_t piece, int showBoard) {
	int_fast8_t board[64];
	int square, movesMade = 0, reachable = 0;
	// Board is left to right, top to bottom. board[0] is a8;
	// board[36] is e4; and board[63] is h1
	for(square = 0; square < 64; square++) {
		board[square] = -1; // Not visited yet
	}
	board[36] = 0; // Start moves from e4
	for(movesMade = 0; movesMade < 36; movesMade++) {
		for(square = 0; square < 64; square++) {
			if(board[square] == movesMade) {
				movePieceOnBoard(piece, board, square);
			}
		}
	}
	for(square = 0; square < 64; square++) {
		if(showBoard == 1) {
			if(board[square] == -1) {
				printf("- ");
			} else if(board[square] < 10) {
				printf("%c ",'0' + board[square]);
			} else if(board[square] >= 10 && board[square] < 36) {
				printf("%c ",'A' + (board[square] - 10));
			} else {
				printf("? ");
			}
			if(square % 8 == 7) {
				puts("");
			}
		}
		if(board[square] >= 0) {
			reachable++;
		}
	}
	return reachable;
}

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
	countReachable8x8(0x54422a,1); // Show knight moves
	puts("");countReachable8x8(0x404201,1); // semi-pinwheel fairy piece
	puts("");
	printf("%d known non-colorbound pieces\n",count);
	for(a = 0; a <= 28; a++) {
		grandTotal += (1 << a) * moves[a];
		if(moves[a] > 0) {
			printf("%6d pieces with %d moves\n",moves[a],a);
		}
	}
	printf("With riders, %d possible non-colorbound pieces\n",grandTotal);
}
