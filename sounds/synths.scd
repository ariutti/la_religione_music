// RELIGION SYNTHS

// All synths are tuned to a "RA Music scale".
// 8Hz is the fundamental tone;
// 256Hz is a reference frequency.




// create the synth definitions

/*
SynthDef(\outputStage, {
	|
	in=0, out=0, level=0, lagTime=5, amp=1.0 //gate_fade=1, lowLevel = 0.01, highLevel=1.0, inTime=5, outTime=0.5|
	freq = 1500, q=1, db=(-3)
	|
	var sig;
	sig = In.ar( in );
	sig = MidEQ.ar(sig, freq, q.reciprocal, db);
	//fade = EnvGen.ar(Env.new([lowLevel, highLevel, lowLevel],[inTime, outTime],releaseNode:1), gate_fade);
	sig = sig * VarLag.kr( level, lagTime ) * amp; // use amp if you want to have an overall volume controll
	Out.ar(out, sig);
}).add;
*/

SynthDef(\outputStage, {
	|in=0, out=0, amp=1.0,
	level=0, lagTime=5
	// MidEq arguments
	//freq = 1500, q=1, db=(-3)
	mid_freq1 = 1500, mid_q1=1, mid_db1 =0,
	mid_freq2 = 3000, mid_q2=1, mid_db2 =0,
	mid_freq3 = 6000, mid_q3=1, mid_db3 =0,
	// filters arguments
	lpf_freq = 15000,
	hpf_freq = 60
	|
	var sig;
	sig = In.ar( in );
	sig = MidEQ.ar(sig, mid_freq1, mid_q1.reciprocal, mid_db1);
	sig = MidEQ.ar(sig, mid_freq2, mid_q2.reciprocal, mid_db2);
	sig = MidEQ.ar(sig, mid_freq3, mid_q3.reciprocal, mid_db3);
	sig = LPF.ar(sig, lpf_freq);
	sig = HPF.ar(sig, hpf_freq);
	sig = sig * VarLag.kr( level, lagTime ) * amp;
	Out.ar(out, sig);
}).add;




// define tibetan voices synths
SynthDef(\drone, {
	|freq=64, amp=0.125, drywet=0.5, detune=1, reso_f=1, out=0|
	var sig, w, reso;
	// reso = LFNoise1.kr( reso_f ).exprange(0.05, 0.5);
	// make it less resonant
	reso = LFNoise1.kr( reso_f ).exprange(0.1, 0.5);

	freq = freq + LFNoise1.kr( Rand(3, 7) ).range(-1*detune, detune);
	//freq.poll;
	w = LFNoise1.kr(0.3).range(0.1, 0.9);
	sig = VarSaw.ar(freq, width:w);

	sig = BLowPass.ar(sig, freq * LFNoise1.kr( Rand(0.1, 0.5) ).range(1, 8), reso);

	//sig = FreeVerb.ar(sig, drywet);
	//sig = sig + CombN.ar(sig, 1.8, drywet, 1.5);

	sig = sig * LFNoise1.kr( Rand(0.1, 0.5) ).range(0.1, 1.0) * amp * 0.5;

	// stereo pan
	//Out.ar(0, Pan2.ar(sig,LFNoise1.kr( Rand(0.05, 0.2) )) );
	// multichannel pan
	//Out.ar(out, PanAz.ar( s.options.numOutputBusChannels, sig, LFNoise1.kr( Rand(0.05, 0.2) ), width:4.0) );
	// better to have drone moving alla around the 360
	// in order not to have some silent speaker for a long time.
	Out.ar(out, PanAz.ar( s.options.numOutputBusChannels, sig, LFSaw.kr( Rand(0.05, 0.2) ), width:4.0) );
}).add;



SynthDef(\firefly, {
	|freq=256, amp=0.5, out=0|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.01, 3), doneAction:2);
	sig = SinOsc.ar(freq) * env * amp;
	Out.ar(out, sig);
}).add;


// the tabla player synth
SynthDef(\tabla, {
	| amp=1, buf=0, rate=1.0, out=0 |
	var sig, env;
	sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf)*rate, doneAction:2);
	//sig = FreeVerb.ar(sig, 0.05, 2);
	sig = sig * amp * 3;
	Out.ar(out, Mix.ar(sig) );
}).add;



// bell (glokenspiel and tibetan bell)
SynthDef(\bell, {
	|
	fs=1, t60=1, pitchy=1, amp=0.25, out=0
	|
	var sig, exciter;
	//exciter = Impulse.ar(0);
	exciter = WhiteNoise.ar() * EnvGen.ar(Env.perc(0.001, 0.05), gate:1) * 0.25;
	sig = Klank.ar(
		`[
			[1, 2, 2.803, 3.871, 5.074, 7.81, 10.948, 14.421],   // freqs
			[1, 0.044, 0.891, 0.0891, 0.794, 0.1, 0.281, 0.079], // amplitudes
			[1, 0.205, 1, 0.196, 0.339, 0.047, 0.058, 0.047]*t60 // ring times
		],
		exciter,
		freqscale:fs*pitchy);
	//sig = sig + CombN.ar(sig, 1, 0.1, 0.7);
	sig = FreeVerb.ar(sig, 0.4,0.5,0.6) * amp;
	DetectSilence.ar(sig, 0.001, 0.5, doneAction:2);
	Out.ar(out, sig);
}).add;


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
