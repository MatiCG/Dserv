module src.mathHelper;

class MathHelper
{
    int add(int a, int b)
    {
        return (a+b);
    }

    int sub(int a, int b)
    {
        return (a-b);
    }

    int mult(int a, int b)
    {
        return (a*b);
    }

    unittest
    {
        MathHelper mh = new MathHelper;
        assert(mh.add(2, 2) == 4);
        assert(mh.add(2, 0) == 2);
        assert(mh.add(2, 10) == 12);
    }

    unittest
    {
        MathHelper mh = new MathHelper;
        assert(mh.sub(2, 2) == 0);
        assert(mh.sub(2, 0) == 2);
        assert(mh.sub(2, 10) == -8);
    }

    unittest
    {
        MathHelper mh = new MathHelper;
        assert(mh.mult(2, 2) == 4);
        assert(mh.mult(2, 0) == 0);
        assert(mh.mult(2, 10) == 20);
    }
}