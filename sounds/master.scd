// RELIGION MASTER

(
// server settings;
s=Server.local;
//s.options.device = "ASIO : US-16x08 ASIO";

// Set here the total number of indipendent speakers
~nspeakers = 8;

s.options.numOutputBusChannels_(~nspeakers); // we will have a speaker for each religion (8)
s.options.numInputBusChannels_(2);
//s.meter;
//s.plotTree;

s.waitForBoot({

	"\n".postln;

	// Synth definitions:
	"synths.scd".loadRelative;
	"Synths loaded!".postln;
	s.sync;

	// Routing:
	// create the groups
	~grp_out = Group.new();
	~grp_syn = Group.new(~grp_out, \addBefore);

	// create the arrays
	~array_bus_out = ~array_bus_out ? [];
	~array_outputStages = ~array_outputStages ? [];

	// Populate the arrays:
	// - create busses;
	// - create output stages;
	~nspeakers.do(
		{
			|item|
			//("Item "+item).postln;
			~array_bus_out = ~array_bus_out.add(
				Bus.audio(s, 1);
			);

			~array_outputStages = ~array_outputStages.add(
				Synth(\outputStage, [\in, ~array_bus_out[item], \out, item], target:~grp_out);
			);
	});

	Synth(\drone, [\out, ~array_bus_out, \freq, 32, \mix, 0.1,  \detune, 0.5, \amp, 0.7], target:~grp_syn);
	Synth(\drone, [\out, ~array_bus_out, \freq, 64, \mix, 0.3,  \detune, 1,   \amp, 0.25], target:~grp_syn);
	Synth(\drone, [\out, ~array_bus_out, \freq, 96, \mix, 0.5,  \detune, 1.1, \amp, 0.25*0.9], target:~grp_syn);
	Synth(\drone, [\out, ~array_bus_out, \freq, 128,\mix, 0.7,  \detune, 1.2, \amp, 0.25*0.7], target:~grp_syn);
	Synth(\drone, [\out, ~array_bus_out, \freq, 192,\mix, 0.9,  \detune, 1.4, \amp, 0.25*0.5], target:~grp_syn);
	Synth(\drone, [\out, ~array_bus_out, \freq, 256,\mix, 0.99, \detune, 1.6, \amp, 0.25*0.2], target:~grp_syn);
	Synth(\drone, [\out, ~array_bus_out, \freq, 320,\mix, 0.99, \detune, 2,   \amp, 0.25*0.3], target:~grp_syn);

	s.sync;


	// score definitions:
	"score.scd".loadRelative;
	"Score loaded!".postln;
	s.sync;

	// OSC methods:
	"osc.scd".loadRelative;
	"OSC loaded!".postln;
	s.sync;

});
)


/*
// TEST STUFF /////////////////////////////////////////////////////////////////////

Server;
s.serverRunning;
s.makeGui;

s.plotTree;
s.meter;
s.freeAll;
s.queryAllNodes;

~busArray[0];
~synthArray[7];
~outArray[4];

~bus  = Bus.audio(s, 1);
~fade = Synth(\outputStage, [\in, ~bus, \out, 0]);
~sine = Synth(\sine, [\out, ~bus], ~fade, \addBefore);
~fade.set(\in, ~bus);
~sine.set(\out, ~bus);
~fade.set(\gate_fade, 0);
~fade.set(\lowLevel, 0.25);
*/