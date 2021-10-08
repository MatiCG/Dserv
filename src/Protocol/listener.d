import std.stdio : writeln, writefln;
import std.socket : InternetAddress, Socket, SocketException, SocketSet, TcpSocket;
import std.conv : ConvException, ConvOverflowException, to;
import std.exception : assertThrown;

class Listener
{
    ushort port;
    string addr;
    TcpSocket listener;
    SocketSet socketSet;
    enum MAX_CONNECTIONS = 30;
    Socket[] reads;

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
        writefln("Server is running and listening on %s port %d", "0.0.0.0", this.port);
    }

    void run()
    {
        writefln("Server is running and listening on %d port %d", this.addr, this.port);

        while (true) {
            this.socketSet.add(this.listener);

        }
    }
}


void main()
{
    Listener list = new Listener(6060, "0.0.0.0");
}