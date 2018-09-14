(
s = Server.local;
//s.options.device = "ASIO : US-16x08 ASIO";
s.options.device = "ASIO : MOTU Audio ASIO";

// Set here the total number of indipendent speakers
// solve the fact that a number greater than 4 can cause the error:
// JackDriver: exception in real time: alloc failed, increase server's memory allocation (e.g. via ServerOptions)
~nspeaker = 10;

// increase the memory used for audio
//s.options.memSize = s.options.memSize * 100;
s.options.numOutputBusChannels_(~nspeaker);
s.options.numInputBusChannels_(2);
)

{Out.ar(2, WhiteNoise.ar()!8)}.play;
{Out.ar(2+0, SinOsc.ar(500, mul:1))}.play;
{Out.ar(2+5, SinOsc.ar(500, mul:1))}.play;



s.meter;

(
SynthDef(\test, {
	|out=0, amp=0.5, freq=440|
	var sig = SinOsc.ar(freq);
	sig = sig * amp;
	Out.ar(1+out, sig);
}).add;
)

(
x = Synth(\test, [\out, 0, \freq, 1500, \amp, 1.0]);
//x.set(\amp, 0.8);
)

(
w = Window.new.front;

a = NumberBox(w, Rect(20, 20, 150, 20));
b = Slider(w, Rect(20, 60, 150, 20))
    .action_({
	a.value_(b.value);
	x.set(\amp, b.value);
});

c = NumberBox(w, Rect(20, 100, 150, 20));
d = Slider(w, Rect(20, 140, 150, 20))
    .action_({
	c.value_(d.value.linexp(0.0, 1.0, 20, 20000));
	x.set(\freq, d.value.linexp(0.0, 1.0, 20, 20000) );
});

e = NumberBox(w, Rect(20, 180, 150, 20));
f = Slider(w, Rect(20, 220, 150, 20))
    .action_({
	e.value_(f.value*8);
	x.set(\out, f.value*8 );
});
//a.action.value;
)