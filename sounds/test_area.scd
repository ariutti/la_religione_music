// TEST AREA

(
s.meter;
s.plotTree;
s.freqscope;
)

~ctrl.sendMsg("/method/sound", 1);
~ctrl.sendMsg("/method/sound", 0);
~ctrl.sendMsg("/method/clicked", 0);
~ctrl.sendMsg("/method/released", 1);

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



