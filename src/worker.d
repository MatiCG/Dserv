module dserv.worker;

import core.thread.osthread : Thread;
import std.stdio : writeln, writefln;

class Worker : Thread
{
    this(char[1024] datLength)
    {
        writeln(datLength);
        super(&run);
    }

private:
    void run()
    {
    }    
}