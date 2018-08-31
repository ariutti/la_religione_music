// RELIGION OSC

~ctrl = NetAddr("127.0.0.1", 15300);




// clicked function
~osc_clicked = OSCFunc({
	| msg, time, addr, recvPort |
	postln("Clicked (index" + msg[1] + ").");
	if( msg[1].asInt>=0 && msg[1].asInt<8,
		{
			//"true condition".postln;

			// fade out on the "i" output stage
			~array_out[ msg[1].asInt ].set(\level, 0.05, \lagTime, 0.5);

			// call a function to play more than one firefly
			// at the selected speaker position
			//~func_clicked_firefly.value( msg[1] );

			// call the function to play the
			// corresponding religion sound
			~parseReligion.value( msg[1].asInt );
		},
		{
			//"condizione falsa".postln;
			"Invalid index".postln;
		}
	);
}, "/sc/clicked", recvPort:15300);



// released function
~osc_released = OSCFunc({
	| msg, time, addr, recvPort |
	postln("Relesaed (index" + msg[1] + ").");
	if( msg[1].asInt>=0 && msg[1].asInt<8,
		{
			//"condizione vera".postln;
			~array_out[ msg[1].asInt ].set(\level, 1.0, \lagTime, 5);
		},
		{
			//"condizione falsa".postln;
			"Invalid index".postln;
		}
	);
}, "/sc/released", recvPort:15300);



~osc_sound = OSCFunc({
	| msg, time, addr, recvPort |
	postln("func 'sound' " ++ msg[1].asInt );

	if( msg[1].asInt==1, {
		~array_out.do{
			|item|
			//item.postln;
			item.set(\level, 1.0, \lagTime, 5);
		};
		~task_firefly.start;
	},
	{
		~array_out.do{
			|item|
			//item.postln;
			item.set(\level, 0.0, \lagTime, 3);
		};
		~task_firefly.stop;
	});
}, "/sc/sound", recvPort:15300);


// a function to be called when you want to kill the server
// just before exiting the application
~osc_killserver = OSCFunc({
	| msg, time, addr, recvPort |
	postln("func 'killserver' " ++ msg[1].asInt );

	if( msg[1].asInt == 1,
	{
		"Now server is quitting".postln;
		s.freeAll();
		s.quit();
	});
}, "/sc/killserver", recvPort:15300);
