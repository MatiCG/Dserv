module dserv.server;

import std.stdio : writeln, writefln;
import std.socket : InternetAddress, Socket, SocketException, SocketSet, TcpSocket;
import std.conv : ConvException, ConvOverflowException, to;
import std.exception : assertThrown;
import std.algorithm.mutation : remove;

class Server
{
	ushort port;
	string addr;
	TcpSocket listener;
	SocketSet socketSet;
	enum MAX_CONNECTIONS = 30;
	Socket[] reads;
	bool running;

	this(ushort _port, string _addr)
	{
		this.port = _port;
		this.addr = _addr;
		this.listener = new TcpSocket();
		assert(this.listener.isAlive);
		this.listener.blocking = false;
		this.listener.bind(new InternetAddress(addr, this.port));
		this.listener.listen(5);
		this.socketSet = new SocketSet(MAX_CONNECTIONS + 1);
		this.running = true;
	}

	void read()
	{
		this.socketSet.add(this.listener);
		foreach (sock; this.reads)
			this.socketSet.add(sock);
		Socket.select(this.socketSet, null, null);

		for (size_t i = 0; i < this.reads.length; i++) {
			if (this.socketSet.isSet(this.reads[i])) {
				char[1024] buf;
                auto datLength = this.reads[i].receive(buf[]);

                if (datLength == Socket.ERROR)
                    writeln("Connection error.");
				else if (datLength != 0)
				//Place worker here
					continue;
				else {
					try {
						writefln("Connection from %s closed", this.reads[i].remoteAddress().toString());
					} catch (SocketException)
						writeln("Connection closed");
				}
				this.reads[i].close();
				this.reads = remove(reads, i);
				i--;
			}
		}

	}

	void connection()
	{
		if (this.socketSet.isSet(this.listener)) {
			Socket sn = null;
			scope (failure) {
				writefln("Error accepting incoming connection");
				
				if (sn)
					sn.close();
			}
			sn = listener.accept();
			assert(sn.isAlive);
            assert(listener.isAlive);

			if (this.reads.length < MAX_CONNECTIONS)
            {
                writefln("Connection from %s established.", sn.remoteAddress().toString());
				//concatenation reads + sn
                reads ~= sn;
            } else {
				writefln("Rejected connection from %s; too many connections.", sn.remoteAddress().toString());
                sn.close();
                assert(!sn.isAlive);
                assert(listener.isAlive);
			}
		}
	}

	void run()
	{
		writefln("Server is running and listening on %s port %d", this.addr, this.port);

		while (this.running == true) {
			this.read();
			this.connection();
			this.socketSet.reset();
		}
	}

	unittest
	{
		auto serv = new Server(6060, "0.0.0.0");
		assert(serv.listener.isAlive);
	}
}