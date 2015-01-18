# Ejabberd-Packet-Interceptor
Ejabberd module that intercepts and changes messages

This module takes a Ejabberd message packet, changes the message body and sends it.

The module hooks the packet_filter and checks per packet if there is a message body.
If there is a message body, it base64 encodes it, and passes it over to a python script. 
This script does something cool with the body (parses it), and returns the new body.
The module replaces the old body with the new and sends the packet.

This module is inspirated by (and uses the inject_body function from):
https://github.com/webiest/mod_otr/

Why use Python as body parser? 
First of all my Erlang sucks. 
Also Erlang itself sucks, it is easier to write complex parsers with Python.
