// RELIGION MASTER

(
// server settings;
s=Server.local;
//s.options.device = "ASIO : US-16x08 ASIO";
//s.options.device = "MME : Altoparlanti (Dispositivo High";
//s.options.device = "Windows DirectSound : Altoparlanti (io|2)";
s.options.device = "ASIO : MOTU Audio ASIO";

// Set here the total number of indipendent speakers
~nspeakers = 8;
~spk_offset = 2;

~drone_amp = 1.0;

s.options.numOutputBusChannels_(~nspeakers+~spk_offset); // we will have a speaker for each religion (8)
s.options.numInputBusChannels_(2);
//s.meter;
//s.plotTree;

/*
s.options.memSize = 8192;//s.options.memSize*64;
s.options.blockSize = 64; // increase block size (default is 64)
s.options.sampleRate = 48000;// increase sampling rate (if your hardware supports it)
*/


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
				Synth(\outputStage, [\in, ~array_bus_out[item], \out, (item+~spk_offset)], target:~grp_out);
			);
	});

	Synth(\drone, [\out, ~array_bus_out, \freq, 32, \mix, 0.1,  \detune, 0.5, \amp, ~drone_amp * 0.7], target:~grp_syn);
	Synth(\drone, [\out, ~array_bus_out, \freq, 64, \mix, 0.3,  \detune, 1,   \amp, ~drone_amp * 0.25], target:~grp_syn);
	Synth(\drone, [\out, ~array_bus_out, \freq, 96, \mix, 0.5,  \detune, 1.1, \amp, ~drone_amp * 0.25*0.9], target:~grp_syn);
	Synth(\drone, [\out, ~array_bus_out, \freq, 128,\mix, 0.7,  \detune, 1.2, \amp, ~drone_amp * 0.25*0.7], target:~grp_syn);
	Synth(\drone, [\out, ~array_bus_out, \freq, 192,\mix, 0.9,  \detune, 1.4, \amp, ~drone_amp * 0.25*0.5], target:~grp_syn);
	Synth(\drone, [\out, ~array_bus_out, \freq, 256,\mix, 0.99, \detune, 1.6, \amp, ~drone_amp * 0.25*0.2], target:~grp_syn);
	Synth(\drone, [\out, ~array_bus_out, \freq, 320,\mix, 0.99, \detune, 2,   \amp, ~drone_amp * 0.25*0.3], target:~grp_syn);

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
