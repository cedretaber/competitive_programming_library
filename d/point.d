
///
enum EPS = 1e-10;

///
double add(double a, double b) {
    if (abs(a + b) < EPS * (abs(a) + abs(b))) return 0;
    return a + b;
}

///
struct P {
    double x, y;

    this(double x, double y) {
        this.x = x;
        this.y = y;
    }

    P opOpAssign(string op)(P p) {
        static if (op == "+") {
            this.x = add(this.x, p.x);
            this.y = add(this.y, p.y);
            return this;
        } else static if (op == "-") {
            this.x = add(this.x, -p.x);
            this.y = add(this.y, -p.y);
            return this;
        } else static assert(0, "Operator '"~op~"' not implemented");
    }

    P opBinary(string op)(P p) {
        P q = this;
        return q.opOpAssign!op(p);
    }

    P opOpAssign(string op)(double d) {
        static if (op == "*") {
            this.x = this.x * d;
            this.y = this.y * d;
            return this;
        } else static if (op == "/") {
            this.x = this.x / d;
            this.y = this.y / d;
            return this;
        } else static assert(0, "Operator '"~op~"' not implemented");
    }

    P opBinary(string op)(double d) {
        P q = this;
        return q.opOpAssign!op(d);
    }

    double norm() {
        return sqrt(add(x^^2, y^^2));
    }

    // dot product
    double dot(P p) {
        return add(x * p.x, y * p.y);
    }

    // cross product
    double det(P p) {
        return add(x * p.y, -y * p.x);
    }

    double dist(P p) {
        return sqrt((x - p.x)^^2 + (y - p.y)^^2);
    }

    P middle(P p) {
        return P((x + p.x)/2, (y + p.y)/2);
    }

    P rotate(double th) {
        return P(add(x * cos(th), -y * sin(th)), add(x * sin(th), y * cos(th)));
    }

    P rotate(P p, double th) {
        auto q = P(x - p.x, y - p.y).rotate(th);
        return P(q.x + p.x, q.y + p.y);
    }
}

// 線分p1-p2上に点qがあるか判定
bool on_seg(P p1, P p2, P q) {
    return (p1 - q).det(p2 - q) == 0 && (p1 - q).dot(p2 - q) <= 0;
}

// 直線p1-p2と直線q1-q2の交点
P intersection(P p1, P p2, P q1, P q2) {
    return p1 + (p2 - p1) * ((q2 - q1).det(q1 - p1) / (q2 - q1).det(p2 - p1));
}

// 2直線の直交判定
bool is_orthogonal(P a1, P a2, P b1, P b2) {
    return (a1 - a2).dot(b1 - b2) == 0;
}
// 2直線の平行判定
bool is_parallel(P a1, P a2, P b1, P b2) {
    return (a1 - a2).det(b1 - b2) == 0;
}

// 円と円との交点
P[] circle_intersection(P p1, double r1, P p2, double r2) {
    if (add(p1.dist(p2), -add(r1, r2)) == 0) return [p1.middle(p2)];
    auto p = P(p2.x - p1.x, p2.y - p1.y);
    auto th = atan2(p.y, p.x);
    auto len = p1.dist(p2) * r1 / add(r1, r2);
    auto h = sqrt(add(r1^^2, -len^^2));
    auto q1 = P(len, h).rotate(th);
    auto q2 = P(len, -h).rotate(th);
    return [P(q1.x + p1.x, q1.y + p1.y), P(q2.x + p1.x, q2.y + p1.y)];
}

///
struct Circle {
    P p;
    double r;

    this(P p, double r) {
        this.p = p;
        this.r = r;
    }

    bool is_include(P p) {
        return this.p.dist(p) <= this.r;
    }
}

///
struct Triangle {
    P a, b, c;

    this(P a, P b, P c) {
        this.a = a;
        this.b = b;
        this.c = c;
    }

    Circle enclosing_circle() {
        auto A = (b-c).dot(b-c);
        auto B = (c-a).dot(c-a);
        auto C = (a-b).dot(a-b);

        auto T = A*(B+C-A);
        auto U = B*(C+A-B);
        auto W = C*(A+B-C);

        auto p = (a*T + b*U + c*W)/(T + U + W);

        return Circle(p, sqrt((a.x - p.x)^^2 + (a.y - p.y)^^2));
    }

    Circle circumcenter() {
        auto y = (
            (c.x - a.x) * (a.x^^2 + a.y^^2 - b.x^^2 - b.y^^2) - (b.x - a.x) * (a.x^^2 + a.y^^2 - c.x^^2 - c.y^^2)) /
            (2 * (c.x - a.x) * (a.y - b.y) - 2 * (b.x - a.x) * (a.y - c.y));
        auto x = b.x - a.x != 0
            ? (2 * (a.y - b.y) * y - a.x^^2 - a.y^^2 + b.x^^2 + b.y^^2) / (2 * (b.x - a.x))
            : (2 * (a.y - c.y) * y - a.x^^2 - a.y^^2 + c.x^^2 + c.y^^2) / (2 * (c.x - a.x));

        auto p = P(x, y);
        return Circle(p, p.dist(a));
    }
}
