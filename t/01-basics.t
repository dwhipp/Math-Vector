use v6;
use Math::Vector;
use Test;

plan *;

my $v1 = Math::Vector.new(1, 2, 3);
my Math::Vector $v2 = Math::Vector.new(3, 4, 0);
my @v3 = (-1, 0, 2);
my Math::Vector $v3 = Math::Vector.new(@v3);
my Math::Vector $origin3d = Math::Vector.new(0, 0, 0);
my Math::Vector $v5 = Math::Vector.new(1,2,3,4,5);
my Math::Vector $v6 = Math::Vector.new(0,0,1,0,0);
my Math::Vector $v7 = Math::Vector.new(1,0,0,0,0,0,0);
my Math::Vector $v8 = Math::Vector.new(0,1,0,0,0,0,0);
my Math::Vector $v9 = Math::Vector.new(1..7);
my Math::Vector $v10 = Math::Vector.new(10,20,1,10,20,10,30);
my Math::Vector $vcrazy = Math::Vector.new(Math::Vector.new(1, 2, 3), Math::Vector.new(-1, 0, -1));

my @vectors = ($v1, $v2, $v3, $origin3d, $v5, $v6, $v7, $v8, $v9, $v10);

isa_ok($v1, Math::Vector, "Variable is of type Math::Vector");
isa_ok($v2, Math::Vector, "Variable is of type Math::Vector");
isa_ok($v3, Math::Vector, "Variable is of type Math::Vector");
isa_ok($v5, Math::Vector, "Variable is of type Math::Vector");
isa_ok($v7, Math::Vector, "Variable is of type Math::Vector");
isa_ok($vcrazy, Math::Vector, "Variable is of type Math::Vector");

is(~$v1, "(1, 2, 3)", "Stringify works");
is(~$v3, "(-1, 0, 2)", "Stringify works");
is(~$origin3d, "(0, 0, 0)", "Stringify works");
is(~$v5, "(1, 2, 3, 4, 5)", "Stringify works");
is(~$vcrazy, "((1, 2, 3), (-1, 0, -1))", "Stringify works");

is(~eval($v1.perl), ~$v1, ".perl works");
is(~eval($v9.perl), ~$v9, ".perl works");
is(~eval($vcrazy.perl), ~$vcrazy, ".perl works");

is($v1.Dim, 3, "Dim works for 3D Math::Vector");
is($v5.Dim, 5, "Dim works for 5D Math::Vector");
is($v7.Dim, 7, "Dim works for 7D Math::Vector");

is_approx($v7 ⋅ $v8, 0, "Perpendicular Math::Vectors have 0 dot product");


#basic math tests
is(~($v1 + $v2), "(4, 6, 3)", "Basic sum works");
is(~($v7 + $v9), "(2, 2, 3, 4, 5, 6, 7)", "Basic sum works, 7D");
is($v1 + $v2, $v2 + $v1, "Addition is commutative");
is(($v1 + $v2) + $v3, $v1 + ($v2 + $v3), "Addition is associative");
is($v1 + $origin3d, $v1, "Addition with origin leaves original");

# {
#     my Math::Vector $a = $v1;
#     $a += $v2;
#     is(~($v1 + $v2), ~$a, "+= works");
# }
# is(~($v1 + $v2), "(4, 6, 3)", "Basic sum works");

is(~($v1 - $v2), "(-2, -2, 3)", "Basic subtraction works");
is($v1 - $v2, -($v2 - $v1), "Subtraction is anticommutative");
is($v1 - $origin3d, $v1, "Subtracting the origin leaves original");
is(-$origin3d, $origin3d, "Negating the origin leaves the origin");
is(~(-$v2), "(-3, -4, 0)", "Negating works");
# {
#     my Math::Vector $a = $v1;
#     $a -= $v2;
#     is(~($v1 - $v2), ~$a, "+= works");
# }

#lengths
is($origin3d.Length, 0, "Origin has 0 length");
is($v6.Length, 1, "Simple length calculation");
is($v8.Length, 1, "Simple length calculation");

for @vectors -> $v
{
    # is_approx($v.Length ** 2, ⎡$v ⎤ * ⎡$v ⎤, "v.Length squared equals ⎡v ⎤ squared");
    is_approx($v.Length ** 2, $v dot $v, "v.Length squared equals v ⋅ v");
    # is_approx(abs($v) ** 2, $v ⋅ $v, "abs(v) squared equals v ⋅ v");
}

for @vectors -> $v
{
    my Math::Vector $vn = $v * 4.5;
    is_approx($vn.Length, $v.Length * 4.5, "Scalar by Math::Vector multiply gets proper length");
    is_approx_vector($vn.Unitize, $v.Unitize, "Scalar by Math::Vector multiply gets proper direction");
    is_approx_vector($vn, 4.5 * $v, "Scalar by Math::Vector multiply is commutative");
}

for @vectors -> $v
{
    my Math::Vector $vn = $v / 4.5;
    is_approx($vn.Length, $v.Length / 4.5, "Math::Vector by Scalar divide gets proper length");
    is_approx_vector($vn.Unitize, $v.Unitize, "Math::Vector by Scalar divide gets proper direction");
    is_approx_vector($vn, $v * (1.0 / 4.5), "Math::Vector by Scalar divide is equal to multiplication by reciprocal");
}

#dot product tests
is_approx($v7 dot $v8, 0, "Perpendicular Math::Vectors have 0 dot product");

for ($v1, $v2, $v3) X ($v1, $v2, $v3) -> $x, $y
{
    is_approx($x ⋅ $y, $y ⋅ $x, "x ⋅ y = y ⋅ x");
    is_approx($x ⋅ ($y + $v3), ($x ⋅ $y) + ($x ⋅ $v3), "x ⋅ (y + v3) = x ⋅ y + x ⋅ v3");
}

for ($v5, $v6) X ($v5, $v6) -> $x, $y
{
    is_approx($x ⋅ $y, $y ⋅ $x, "x ⋅ y = y ⋅ x");
    is_approx($x ⋅ ($y + $v6), ($x ⋅ $y) + ($x ⋅ $v6), "x ⋅ (y + v6) = x ⋅ y + x ⋅ v3");
}

dies_ok( { $v5 ⋅ $v7 }, "You can't do dot products of different dimensions");
dies_ok( { $v7 dot $v5 }, "You can't do dot products of different dimensions");

# {
#     my $a = $v1;
#     $a ⋅= $v2;
#     is_approx($v1 ⋅ $v2, $a, "⋅= works");
# }

# {
#     my Math::Vector $a = $v1;
#     dies_ok( { $a ⋅= $v2; }, "You can't do dot= on a Math::Vector variable");
# }

#cross product tests
is(~($v1 × $v2), "(-12, 9, -2)", "Basic cross product works");

for ($v1, $v2, $v3) X ($v1, $v2, $v3) -> $x, $y
{
    my $cross = $x × $y;
    is_approx($cross ⋅ $x, 0, "(x × y) ⋅ x = 0");
    is_approx($cross ⋅ $y, 0, "(x × y) ⋅ y = 0");
    is_approx_vector($cross, -($y × $x), "x × y = -y × x");
    is_approx($cross.Length ** 2, $x.Length ** 2 * $y.Length ** 2 - ($x ⋅ $y) ** 2, 
              "|x × y|^2 = |x|^2 * |y|^2 - (x ⋅ y)^2");
}

for ($v7, $v8, $v9, $v10) X ($v7, $v8, $v9, $v10) -> $x, $y
{
    my $cross = $x × $y;
    is_approx($cross ⋅ $x, 0, "(x × y) ⋅ x = 0");
    is_approx($cross ⋅ $y, 0, "(x × y) ⋅ y = 0");
    is_approx_vector($cross, -($y × $x), "x × y = -y × x");
    is_approx($cross.Length ** 2, $x.Length ** 2 * $y.Length ** 2 - ($x ⋅ $y) ** 2, 
              "|x × y|^2 = |x|^2 * |y|^2 - (x ⋅ y)^2");
}

lives_ok { $v7 cross $v8, "7D cross product works writing out cross"}
dies_ok( { $v1 × $v7 }, "You can't do cross products of different dimensions");
dies_ok( { $v5 × $v6 }, "You can't do 5D cross products");
dies_ok( { $v1 cross $v7 }, "You can't do cross products of different dimensions");
dies_ok( { $v5 cross $v6 }, "You can't do 5D cross products");

# {
#     my $a = $v1;
#     $a ×= $v2;
#     is_approx($v1 × $v2, $a, "×= works");
# }

# Math::UnitVector tests
# {
#     my Math::UnitVector $a = Math::Vector.new(1, 0, 0);
#     isa_ok($a, Math::Vector, "Variable is of type Math::Vector");
# }

# {
#     my Math::UnitVector $a = Math::UnitVector.new(1, 0, 0);
#     my $b = $a;
#     $b += $v2;
#     is_approx($a + $v2, $b, "+= works on Math::UnitVector");
# }
# {
#     my Math::UnitVector $a = Math::Vector.new(1, 0, 0);
#     dies_ok( { $a += $v2; }, "Catch if += violates the Math::UnitVector constraint");
# }

# test prefix plus
# isa_ok(+$v1, Math::Vector, "Prefix + works on the Math::Vector class");
dies_ok( { $v1.Num; }, "Make sure .Num does not work on 3D Math::Vector");

# test extensions
class Math::VectorWithLength is Math::Vector
{
    has $.length;
    
    multi method new (*@x) 
    {
        self.bless(*, coordinates => @x, length => sqrt [+] (@x »*« @x));
    }
    
    multi method new (@x) 
    {
        self.bless(*, coordinates => @x, length => sqrt [+] (@x »*« @x));
    }
    
    submethod Length
    {
        $.length;
    }
}

my Math::VectorWithLength $vl = Math::VectorWithLength.new($v7.coordinates);
isa_ok($vl, Math::VectorWithLength, "Variable is of type Math::VectorWithLength");
my $vlc = eval($vl.perl);
isa_ok($vlc, Math::VectorWithLength, "eval'd perl'd variable is of type Math::VectorWithLength");

my $complex_vector = Math::Vector.new(0, 3+4i);
is($complex_vector.abs, 5, "length of vector with complex vector is real");

done;
