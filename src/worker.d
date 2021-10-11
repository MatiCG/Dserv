module dserv.worker;

import core.thread.osthread : Thread;
import std.stdio : writeln, writefln;
import std.array : split;
import std.algorithm.mutation : remove;
import dserv.mathHelper;
import std.conv : to;
import std.socket : Socket;

class Worker : Thread
{
    string request;
    Socket client;

    this(char[1024] datLength, Socket _client)
    {
        //Http parser package does not build on my pc rn so this will have to do in the meantime
        for (size_t i = 0; datLength[i] != '\n' && datLength[i] != '\0'; i++)
            request ~= datLength[i];
        this.client = _client;
        writeln(datLength);
        super(&run);
    }

private:
    void run()
    {
        auto r = this.request.split(' ');
        //TODO replace return with an error code sent to client
        if (r.length != 3 || r[0] != "GET")
            return;
        auto service = r[1].split("/");
        service = remove(service, 0);
        callService(service);
    }

    void callService(string[] service)
    {
        MathHelper mh = new MathHelper;
        int a = to!int(service[1]);
        int b = to!int(service[2]);
        int r;

        writeln(service);

        switch(service[0]) {
        case "add":
            r = mh.add(a, b);
            break;
        case "sub":
            r = mh.sub(a, b);
            break;
        case "mult":
            r = mh.mult(a, b);
            break;
        default:
            //TODO send error message
            return;
        }
        sendResponse(to!string(r));
    }

    void sendResponse(string response)
    {
        //TODO HTTP response
        this.client.send(response);
        writeln(response);
    }
}