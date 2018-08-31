// TEST AREA

(
s.meter;
s.plotTree;
s.freqscope;
)

~ctrl.sendMsg("/sc/sound", 1);
~ctrl.sendMsg("/sc/sound", 0);
~ctrl.sendMsg("/sc/clicked", 0);
~ctrl.sendMsg("/sc/released", 1);

(
// click all
8.do {
	|item|
	~ctrl.sendMsg("/method/clicked", item);
}
)

(
// release all
8.do {
	|item|
	~ctrl.sendMsg("/method/released", item);
}
)

(
~array_out.do {
	|item|
	item.set(\amp, 1.0);
};
)

(
~array_out.do {
	|item|
	item.set(\freq, 1.0);
	item.set(\q, 10);
	item.set(\dB, (-3) );
};
)

