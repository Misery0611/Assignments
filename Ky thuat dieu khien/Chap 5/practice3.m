% Using connect and summing junctions
g1 = tf(1, [1 7]);
g1.u = 'u1';
g1.y = 'y1';

g2 = tf(1, [1 2 3]);
g2.u = 'u234';
g2.y = 'y2';

g3 = tf(1, [1 4]);
g3.u = 'u234';
g3.y = 'y3';

g4 = tf(1, [1 0]);
g4.u = 'u234';
g4.y = 'y4';

g5 = tf(5, [1 7]);
g5.u = 'u57';
g5.y = 'y5';

g6 = tf(1, [1 5 10]);
g6.u = 'c';
g6.y = 'y6';

g7 = tf(3, [1 2]);
g7.u = 'u57';
g7.y = 'c';

g8 = tf(1, [1 6]);
g8.u = 'c';
g8.y = 'y8';

Sum1 = sumblk('u1 = r - y2 - y5');
Sum2 = sumblk('u234 = y1 + y8');
Sum3 = sumblk('u57 = y3 + y4 - y6');
gFinal = connect(g1, g2, g3, g4, g5, g6, g7, g8, Sum1, Sum2, Sum3, 'r', 'c');
tf(gFinal)

% Use connect and append
g9 = tf(1, 1);	% add unit gain transducer at input to specify the first summing
blksys = append(g1, g2, g3, g4, g5, g6, g7, g8, g9);
connections = [1 -2 -5  9;	% U1 = R - (Y2 + Y5)
			   2  1  8  0;	% U2 = Y1 + Y8
			   3  1  8  0;	% U3 = Y1 + Y8
			   4  1  8  0;	% U4 = Y1 + Y8
			   5  3  4 -6;	% U5 = Y3 + Y4 - Y6
			   6  7  0  0;	% U6 = Y7
			   7  3  4 -6;	% U7 = Y3 + Y4 - Y6
			   8  7  0  0];	% U8 = Y7
inputs 	= 9;				% The only input of the system is input of the transducer
outputs = 7;				% The only output of the system is the output of the block G7
gTotal = connect(blksys, connections, inputs, outputs);
tf(gTotal)