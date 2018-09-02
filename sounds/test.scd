(

s.options.device = "MME : Altoparlanti (Dispositivo High";

s.waitForBoot({

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


	~sc = NetAddr("localhost", 15300);

	~osc_func = OSCFunc({
		|msg, time|
		[time, msg].postln;
		//x = Synth(\default);
		x = Synth(\Attack, [\bufnum,~sample_sick]);
	}, '/good/news', recvPort:15300);


	~path_samples = PathName.new( "C:/Users/nicola/Documents/repos/la_religione_music/sounds/" );
	~path_sick_samples = PathName(~path_samples.pathOnly+/+"samples/windchimes/windchime.wav");
	~sample_sick = Buffer.read(s, ~path_sick_samples.fullPath);

});
)

// TEST STUFF /////////////////////////////////////////////////////
/*
~sc.sendMsg('/good/news', 1);

x = Synth(\Attack, [\bufnum,~sample_sick]);
s.meter;
x.free;
*/



