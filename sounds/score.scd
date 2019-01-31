// RELIGION SCORE

// tabla score
var path;

~samples_tabla_lowflick = ~samples_tabla_lowflick ? [];
~samples_tabla_hiflick  = ~samples_tabla_hiflick ? [];
~samples_tabla_dead     = ~samples_tabla_dead ? [];
~samples_tabla_hihit    = ~samples_tabla_hihit ? [];
~samples_tabla_lower    = ~samples_tabla_lower ? [];

path = PathName.new( thisProcess.nowExecutingPath );
path.postln;
path = PathName(path.pathOnly+/+"samples/tabla");

//"DEBUG 1".postln;
//path.postln;

~dic_tabla = ();

path.entries.do({
	| subfolder |
	//subfolder.folderName.postln;

	if(subfolder.isFolder) {
		var array = [];
		"is folder".postln;
		subfolder.entries.do({
			|file|
			if( (file.isFile).and(file.extension=="wav")) {
				// it is a wav file!
				array = array.add( Buffer.read(s, file.fullPath) );
			};
		});

		("folder '"+subfolder.folderName+"' contains "+array.size+"soundfiles!").postln;
		~dic_tabla.put(subfolder.folderName.asSymbol, array);
	};
});

//"DEBUG 2".postln;
//~dic_tabla.postln;

~output_tabla = (6+~spk_offset); // should be 6

// we can create a Pbind for each family of samples
~score_tabla_hihit = Pbind(
	\instrument, \tabla,
	\buf, Pindex( ~dic_tabla[ \hihit ], Prand((0..(~dic_tabla[ \hihit ].size-1)), 1), 1),
	\dur, 0.182, //Pwhite(0.125, 1, 1)
	\out, ~output_tabla
);

~score_tabla_dead = Pbind(
	\instrument, \tabla,
	\buf, Pindex( ~dic_tabla[ \dead ], Prand((0..(~dic_tabla[ \dead ].size-1)), 1), 1),
	\dur, 0.035, //Pwhite(0.125, 1, 1)
	\out, ~output_tabla
);

~score_tabla_lower = Pbind(
	\instrument, \tabla,
	\buf, Pindex( ~dic_tabla[ \lower ], Prand((0..(~dic_tabla[ \lower ].size-1)), 1), 1),
	\dur, 0.35, //Pwhite(0.125, 1, 1)
	\out, ~output_tabla
);

~score_tabla_hiflick = Pbind(
	\instrument, \tabla,
	\buf, Pindex( ~dic_tabla[ \hi_flick ], Prand((0..(~dic_tabla[ \hi_flick ].size-1)), 1), 1),
	\dur, 0.400, //Pwhite(0.125, 1, 1)
	\out, ~output_tabla
);

~score_tabla_lowflick = Pbind(
	\instrument, \tabla,
	\buf, Pindex( ~dic_tabla[ \low_flick ], Prand((0..(~dic_tabla[ \low_flick ].size-1)), 1), 1),
	\dur, 0.151, //Pwhite(0.125, 1, 1)
	\out, ~output_tabla
);


~score_tabla = Pseq([
	Pif(Pfunc({ 0.7.coin }), ~score_tabla_hiflick),
	Pif(Pfunc({ 0.9.coin }), ~score_tabla_lower),
	Pif(Pfunc({ 0.6.coin }), ~score_tabla_hihit),
	Pif(Pfunc({ 0.8.coin }), ~score_tabla_lowflock),
	Pif(Pfunc({ 0.6.coin }), ~score_tabla_dead),
], Prand([1,2],1) ).asEventStreamPlayer;



// score firefly
~score_firefly = Pfinval(2.rrand(4),
	Pbind(
		\instrument, \firefly,
		\group, ~grp_syn,
		\multiplier, Prand( [4, 8], inf),
		\freq, Prand([ 384, 320 ], inf) * Pkey(\multiplier),
		\dur, Pwhite(0.5,1,inf),
		\amp, 0.0625,
		\out, Pindex(~array_bus_out, Prand((0..7), inf) )
)).asEventStreamPlayer;

~task_firefly = Task({
	inf.do({
		~score_firefly.reset;
		~score_firefly.play(quant:0);
		5.rrand(15).wait;
	});
});

// not used anymore
~func_clicked_firefly = {
	| idx |
	idx.postln;

	Pbind(
		\instrument, \firefly,
		\multiplier, Prand( [2, 4, 8], inf),
		\freq, Prand([ 384, 320 ], inf) * Pkey(\multiplier),
		\dur, Pwhite(0.125,0.25, 3),
		\out, idx
	).play(quant:0);
};

// glokenspiel score "Vieni Vieni"
// 82 BPM means that a crochet note last 0.731 seconds
~notesA    = [60, 60, 60, 60, 60, 65, 65, 65, 65, 65, 65, 65, 63, 63, 63, 63, 65, 63, 62, 62];
~durationA = [1,1,0.5,1,0.5, 0.5,0.5,0.5,0.5,0.5,1,0.5,0.66,0.66,0.66,0.66,0.66,0.66,1,3];

~notesB    = [60, 60, 60, 60, 60, 65, 65, 65, 65, 65, 65, 65, 63, 63, 63, 63, 65, 63, 62, 62, 60, 59, 60];
~durationB = [1,1,0.5,1,0.5, 0.5,0.5,0.5,0.5,0.5,1,0.5,0.66,0.66,0.66,0.66,0.66,0.66,2,0.66,0.66,0.66,4];

~notesB1   = [63, 63, 63, 63, 65, 63, 62, 62, 60, 59, 60];
~durationB1 = [0.66,0.66,0.66,0.66,0.66,0.66,2,0.66,0.66,0.66,4]*0.85;

~output_cattolicesimo = (1+~spk_offset); // should be 1

~score_glokenspiel = Pbind(
	\instrument, \bell,
	//\fs,  (Pseq( ~notesA ++ ~notesB, inf ) + 3).midicps,
	\fs,  (Pseq( ~notesB1, inf ) + 3).midicps,
	//\dur, Pseq( ~durationA ++ ~durationB )*0.731*Pwhite(0.98, 1.1, inf),
	\dur, Pseq( ~durationB1 )*0.731*Pwhite(0.97, 1.3, inf),
	\t60, 4,
	\pitchy, 4,
	\amp, 0.125,
	\out, ~output_cattolicesimo
).asEventStreamPlayer;




// samples management

~path_samples = PathName.new( thisProcess.nowExecutingPath );

//"DEBUG 3".postln;
//~path_samples.postln;


// PROSPETTO SUONI (ogni religione è associata al proprio index definitivo)
// 0. Ebraismo - Arpa selezione randomica campioni.
// 1. Cattolicesimo   - Glockenspiel (procedurale/campionato)
// 2. Islam           - riproduzione audio file muezzin, già riverberato(campionato)
// 3. Protestantesimo - Organo selezione randomica campioni.
// 4. Sick            - riproduzione audio file Wind chimes (campionato)
// 5. Buddismo - campana (procedurale/campionato)
// 6. Induismo - Tabla partitura procedurale di campione.
// 7. Ateismo  - riproduzione audio file Gaber(campionato)


// CATTOLICESIMO (procedural)
//~path_cattolicesimo_samples

// BUDDISMO (procedural)
//~path_buddismo_samples

// INDUISMO (procedural)
//~path_induismo_samples

// SICK (single sample)
~path_sick_samples = PathName(~path_samples.pathOnly+/+"samples/windchimes/windchime.wav");
~sample_sick = Buffer.read(s, ~path_sick_samples.fullPath);

// ISLAM (single sample)
~path_islam_samples = PathName(~path_samples.pathOnly+/+"samples/muezzin/muezzin.wav");
~sample_islam = Buffer.read(s, ~path_islam_samples.fullPath);

// ATEISMO (single sample)
~path_ateismo_samples = PathName(~path_samples.pathOnly+/+"samples/gaber/mono/gaber1.wav");
~sample_ateismo = Buffer.read(s, ~path_ateismo_samples.fullPath);

// PROTESTANTESIMO (sample from and array of samples)
~path_protestantesimo_samples = PathName(~path_samples.pathOnly+/+"samples/organ/mono");
~samples_protestantesimo = ~samples_protestantesimo ? [];
~path_protestantesimo_samples.entries.do({
	| entry |
	//entry.postln;
	if(entry.isFile,
		{
			~samples_protestantesimo = ~samples_protestantesimo.add(Buffer.read(s, entry.fullPath));
	});
});
~samples_protestantesimo.size;

//"DEBUG 4".postln;
//~samples_protestantesimo.postln;

// EBRAISMO (sample from and array of samples)
~path_ebraismo_samples = PathName(~path_samples.pathOnly+/+"samples/harp/mono");
~samples_ebraismo = ~samples_ebraismo ? [];
~path_ebraismo_samples.entries.do({
	| entry |
	//entry.postln;
	if(entry.isFile,
		{
			~samples_ebraismo = ~samples_ebraismo.add(Buffer.read(s, entry.fullPath));
	});
});
~samples_ebraismo.size;

//"DEBUG 5".postln;
//~samples_ebraismo.postln;

~parseReligion = {
	|msg|
	"parse religion received the message ".post;
	msg.postln;
	switch(msg.floor,
		0, {
			"ebraismo".postln;
			Synth(\Attack,
				[
					\bufnum, ~samples_ebraismo.choose,
					\rls, 7,
					\amp, 2.0,
					\out, (msg+~spk_offset)
					//\out, 0
				]
			);

		},
		1, {
			"cattolicesimo".postln;
			// TODO: modify Pbind \out argument in this same file (see above)
			~score_glokenspiel.play(doReset:true, quant:0);
		},
		2, {
			"islam".postln;
			Synth(\Attack,
				[
					\bufnum, ~sample_islam,
					\rls, 6,
					\amp, 2.0,
					\out, (msg+~spk_offset)
					//\out, 0
				]
			);
		},
		3, {
			"protestantesimo".postln;
			Synth(\Attack,
				[
					//\bufnum, ~samples_protestantesimo.choose,
					\bufnum, ~samples_protestantesimo[1],
					\rls, 7,
					\amp, 5.0,
					\out, (msg+~spk_offset)
					//\out, 0
				]
			);
		},
		4, {
			"Sikh".postln;
			Synth(\Attack,
				[
					\bufnum, ~sample_sick,
					\amp, 1.0,
					\out, (msg+~spk_offset)
					//\out, 0

				]
			);
		},
		5, {
			"buddismo".postln;
			Synth(\bell,
				[
					\fs, 72.midicps,
					\t60, 8,
					\pitchy, 0.6,
					\amp, 0.25,
					\out, (msg+~spk_offset)
					//\out, 0
			]);
		},
		6, {
			"Induismo".postln;
			// TODO: modify Pbind \out argument in this same file (see above)
			~score_tabla.play(doReset:true, quant:0);
		},
		7, {
			"ateismo".postln;
			Synth(\Attack,
				[
					\bufnum, ~sample_ateismo,
					\rls, 6,
					\amp, 6,
					\out, (msg+~spk_offset)
					//\out, 0
				]
			);
		}
	)
};
