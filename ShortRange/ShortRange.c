// Public domain 2022 by Sam Trenholme
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

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
		moveTo(board,square+18,square); // se then se
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
	int square, movesMade = 0, reachable = 0, done = 0;
	// Board is left to right, top to bottom. board[0] is a8;
	// board[36] is e4; and board[63] is h1
	for(square = 0; square < 64; square++) {
		board[square] = -1; // Not visited yet
	}
	board[36] = 0; // Start moves from e4
	for(movesMade = 0; movesMade < 36; movesMade++) {
		done = 1;
		for(square = 0; square < 64; square++) {
			if(board[square] == -1) {
				done = 0;
			}
			if(board[square] == movesMade) {
				movePieceOnBoard(piece, board, square);
			}
		}
		if(done == 1) {
			break;
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

// Let’s expand this to allow some riders.  To make it simpler, each
// piece, in the eight compass directions (N, NE, E, SE, S, SW, W, and NW)
// can be one of: 
// 1) No move
// 2) Can move one square in the direction, like a king (or pawn)
// 3) Can leap two squares in the direction, like an old Alfil
// 4) Can move one square or leap two squares in the direction
// 5) Can “ride” like a Rook/Bishop/Queen in the direction 
// There are, for the eight compass directions, 5^8 possible pieces
// (That number is 390,625).  If we also allow the piece to have any
// combination of the eight possible Knight leaps, we have precisely
// 100,000,000 possible pieces.
// So now, how many of those 100,000,000 are colorbound?
// To find out, we convert those 100,000,000 pieces in to its short-range
// form, so the riders are seen as one square leapers, then we can see if 
// the piece is colorbound
int32_t semiRiderToShortRange(int32_t index) {
	int32_t s = 0; // Short range version
	// NE
	int32_t l = index % 5;
	// 0: No Move 1: Leap1 2: Leap2 3: Leap1 & Leap2 4: Rider (Leap1)
	if(l == 2 || l == 3) {
		s |= 0x10; // NE-NE
        }
	if(l == 1 || l == 2 || l == 4) {
		s |= 0x100; // NE
	}
	// E
	index = index / 5;
	l = index % 5;
	if(l == 2 || l == 3) {
		s |= 0x2000; // E-E
        }
	if(l == 1 || l == 2 || l == 4) {
		s |= 0x1000; // E
	}
	// SE
	index = index / 5;
	l = index % 5;
	if(l == 2 || l == 3) {
		s |= 0x800000; // SE-SE
        }
	if(l == 1 || l == 2 || l == 4) {
		s |= 0x20000;  // SE
	}
	// S
	index = index / 5;
	l = index % 5;
	if(l == 2 || l == 3) {
		s |= 0x200000; // S-S
        }
	if(l == 1 || l == 2 || l == 4) {
		s |= 0x10000;  // S
	}
	// SW
	index = index / 5;
	l = index % 5;
	if(l == 2 || l == 3) {
		s |= 0x80000; // SW-SW
        }
	if(l == 1 || l == 2 || l == 4) {
		s |= 0x8000;  // SW
	}
	// W
	index = index / 5;
	l = index % 5;
	if(l == 2 || l == 3) {
		s |= 0x400; // W-W
        }
	if(l == 1 || l == 2 || l == 4) {
		s |= 0x800;  // W
	}
	// NW
	index = index / 5;
	l = index % 5;
	if(l == 2 || l == 3) {
		s |= 0x01; // NW-NW
        }
	if(l == 1 || l == 2 || l == 4) {
		s |= 0x40;  // NW
	}
	// N
	index = index / 5;
	l = index % 5;
	if(l == 2 || l == 3) {
		s |= 0x04; // N-N
        }
	if(l == 1 || l == 2 || l == 4) {
		s |= 0x80;  // N
	}
	// Knight moves
	index = index / 5;
	l = index;
	if(l >= 256) { return -1; } // ERROR
	if(l & 0x1) { s |= 0x02; } // N-NW
	if(l & 0x2) { s |= 0x08; } // N-NE
	if(l & 0x4) { s |= 0x20; } // W-NW
	if(l & 0x8) { s |= 0x200; } // E-NE
	if(l & 0x10) { s |= 0x4000; } // W-SW
	if(l & 0x20) { s |= 0x40000; } // E-SE
	if(l & 0x40) { s |= 0x100000; } // S-SW
	if(l & 0x80) { s |= 0x400000; } // S-SE
	return s;
}

int countShortRange(int argc, char **argv) {
	int_fast32_t a;
	int_fast32_t count = 0, bishopLikeCount = 0;
	int_fast32_t moves[32];
	int_fast64_t grandTotal = 0;
	// Numeric first argument: Show the moves for the numeric
	// piece in question
	// e.g. `./ShortRange 5521962` will show the knight moves, then
	// show many squares from e4 it takes to reach a given square
	if(argc == 2 && *(argv[1]) >= '1' && *(argv[1]) <= '9') {
		int lookAt = atoi(argv[1]);
		showPiece(lookAt);
		puts("");
		countReachable8x8(lookAt,1);
		return 0;
	}
	for(a = 0 ; a < 32 ; a++) {
		moves[a] = 0;
	}
	for(a = 0 ; a <= 0xffffff ; a++) {
		if(a % 100000 == 0) {
			printf("Calculating, %d of %d done\n",a,0xffffff);
			fflush(stdout);
		}
		if(countReachable8x8(a,0) == 64) {
		   	count++;
			moves[countMoves(a,30)]++;
		}
		if((a & 0x555aaa) == 0) { // Bishop-like colorbound
			if(countReachable8x8(a,0) == 32) {
				bishopLikeCount++;
			}
		}
	}
	//showPiece(0x54422a); // Knight
	//countReachable8x8(0x54422a,1); // Show knight moves
	//puts("");countReachable8x8(0x404201,1); // semi-pinwheel fairy piece
	//puts("");
	printf("All pieces here have all their leaps within 2 squares\n");
	printf("%d total non-colorbound pieces\n",count);
	printf("%d total bishop-like colorbound pieces\n",bishopLikeCount);
	for(a = 0; a <= 28; a++) {
		grandTotal += (1 << a) * moves[a];
		if(moves[a] > 0) {
			printf("%7d pieces with %d moves\n",moves[a],a);
			//printf("t += 2 ** %d * %d\n",a,moves[a]);
		}
	}
	// We need to correctly print 282,232,643,280 here
	printf("With riders, %U total possible non-colorbound pieces\n",
		grandTotal);
	return 0;
}

int countCompass(int argc, char **argv) {
	int_fast32_t a;
        int_fast32_t count = 0;
	for(a = 0 ; a <= 100000000 ; a++) {
		if(a % 1000000 == 0) {
			printf("Calculating, %d of %d done, %d found\n",a,
				100000000,count);
			fflush(stdout);
		}
		if(countReachable8x8(semiRiderToShortRange(a),0) == 64) {
		   	count++;
		}
	}
	printf("%d non-colorbound pieces\n",count);
}

int main(int argc, char **argv) {
	if(argc == 2 && *(argv[1]) == '-') {
		printf("Usage: ShortRange {piece|--help|Compass}\n");
		printf("Piece is a number, e.g. 5521962 for knight\n");
		printf("--help is this help\n");
		printf("Compass counts number of colorbound Compass pieces\n");
		return 0;
	}
	if(argc == 2 && *(argv[1]) == 'C') {
		return countCompass(argc,argv);
	}
	return countShortRange(argc, argv);
}
