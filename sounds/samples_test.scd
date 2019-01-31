// RELIGION SCORE

(
// server settings;
s=Server.local;
//s.options.device = "ASIO : US-16x08 ASIO";
//s.options.device = "MME : Altoparlanti (Dispositivo High";
//s.options.device = "Windows DirectSound : Altoparlanti (io|2)";
s.options.device = "ASIO : MOTU Audio ASIO";

// Set here the total number of indipendent speakers
~nspeakers = 8;

s.options.numOutputBusChannels_(~nspeakers+2); // we will have a speaker for each religion (8)
s.options.numInputBusChannels_(2);
//s.meter;
//s.plotTree;
)

(
// SICK (single sample)
~path_samples = PathName.new( thisProcess.nowExecutingPath );
~path_sick_samples = PathName(~path_samples.pathOnly++"samples/windchimes/windchime.wav");
~path_sick_samples.postln;
~sample_sick = Buffer.read(s, ~path_sick_samples.fullPath);
Synth(\Attack,[	\bufnum, ~samples_sick,\rls, 7,\amp, 1.0,\out, (2)]);
)



// Synth for launch buffer play
SynthDef(\Attack, {
	|
	out=0, bufnum=0, amp=1.0
	atk=0.01, rls=5, c=(-1)
	|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rls, curve:c), doneAction:2);
	sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) );
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;


