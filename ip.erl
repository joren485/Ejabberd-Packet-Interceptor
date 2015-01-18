-module(ip).

-export([start/2, 
	 stop/1,
	 ofp/1]).

-include("ejabberd.hrl").

start(Host, _Opts) ->
	%% Start hooks.
	ejabberd_hooks:add(filter_packet, global, ?MODULE, ofp, 0),
	ok.

ofp({From, To, XML}) ->
	%% on filter_packet, replace the body of the message with a new one.
	case xml:get_subtag_cdata(XML, "body") of
		
		"" ->
			Newmessage = XML;

		Body -> 
			%% Encode body with b64, and pass it on to the python script
			BodyB64 = base64:encode_to_string(Body),
			POutB64 = os:cmd("python /etc/ejabberd/intercept.py " ++ BodyB64),

			%% Decode the message, and retrieve the new body.
			POut = base64:decode_to_string(POutB64),
				
			%% Inject new body into message		
			Newmessage = lists:nth(1, inject_body([XML], POut))
		
		end,

		%% return the new message.
		{From, To, Newmessage}.

stop(Host) ->
	ejabberd_hooks:delete(filter_packet, global, ?MODULE, opf, 0),
	ok.

%% The inject body code from mod_otr.
inject_body( [ {xmlelement , Name , Attrs, Els} | Tail ] , New ) ->
	[ { xmlelement, Name, Attrs,
		case Name of
			"body" ->
				[{xmlcdata, New}];
			_ ->
				inject_body( Els , New )
		end } | inject_body( Tail , New ) ] ;

inject_body( [ E | Tail ] , New ) ->
	[ E | inject_body( Tail , New ) ];

inject_body( [] , _ ) -> [].
