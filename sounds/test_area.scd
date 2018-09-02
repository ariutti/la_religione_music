// TEST AREA

(
s.meter;
s.plotTree;
s.freqscope;
)

~ctrl.sendMsg("/sc/sound", 1);
~ctrl.sendMsg("/sc/sound", 0);
~ctrl.sendMsg("/sc/clicked", 7);
~ctrl.sendMsg("/sc/released", 1);

(
// click all
~nspeakers.do {
	|item|
	~ctrl.sendMsg("/sc/clicked", item);
}
)

(
// release all
~nspeakers.do {
	|item|
	~ctrl.sendMsg("/sc/released", item);
}
)

(
~array_outputStages.do {
	|item|
	item.set(\amp, 1.0);
};
)

(
~array_outputStages.do {
	|item|
	item.set(\freq, 1.0);
	item.set(\q, 10);
	item.set(\dB, (-3) );
};
)
