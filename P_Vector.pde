class Vector {

  float x;
  float y;
  float z;

  Vector(PVector v) {
    this.x = v.x;
    this.y = v.y;
    this.z = v.z;
  }

  Vector(float ang) {
    PVector v = PVector.fromAngle(radians(ang));
    this.x = v.x;
    this.y = v.y;
    this.z = v.z;
  }

  Vector(float x, float y) {
    this.x = x;
    this.y = y;
  }

  Vector(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  String toString() {
    PVector v = new PVector(x, y, z);
    return v.toString();
  }

  Vector copy() {
    return new Vector(this.x, this.y, this.z);
  }
  PVector toPV() {
    return new PVector(this.x, this.y, this.z);
  }

  Vector add(float x, float y, float z) {
    this.x += x;
    this.y += y;
    this.z += z;
    return this;
  }
  Vector add(float x, float y) {
    return add(x, y, 0);
  }
  Vector add(Vector v) {
    return add(v.x, v.y, v.z);
  }

  Vector sub(float x, float y, float z) {
    this.x -= x;
    this.y -= y;
    this.z -= z;
    return this;
  }
  Vector sub(float x, float y) {
    return sub(x, y, 0);
  }
  Vector sub(Vector v) {
    return sub(v.x, v.y, v.z);
  }

  Vector mult(float f) {
    this.x *= f;
    this.y *= f;
    this.z *= f;
    return this;
  }

  Vector div(float f) {
    return mult(1f/f);
  }

  float mag() {
    return sqrt(magSq());
  }

  float magSq() {
    return sq(x)+sq(y)+sq(z);
  }

  Vector limit(float f) {
    if (mag()>f) {
      setMag(f);
    }
    return this;
  }

  Vector set(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
    return this;
  }

  Vector set(float x, float y) {
    return set(x, y, 0);
  }

  //ANGLES
  float headingH() {
    return degrees(atan2(this.z, this.x));
  }

  float headingV() {
    float hor = new Vector(this.x, this.z).mag();
    return degrees(atan2(hor, this.y)); //Might be wrong direction
  }

  float heading() {
    return headingV();
  }

  Vector rotateX(float ang) {
    ang = radians(ang);
    float y = this.y, z = this.z;
    this.y = y*cos(ang) - z*sin(ang);
    this.z = y*sin(ang) + z*cos(ang);
    return this;
  }

  Vector rotateY(float ang) {
    ang = radians(ang);
    float x = this.x, z = this.z;
    this.x = z*sin(ang) + x*cos(ang);
    this.z = z*cos(ang) - x*sin(ang);
    return this;
  }

  Vector rotateZ(float ang) {
    ang = radians(ang);
    float x = this.x, y = this.y;
    this.x = x*cos(ang) - y*sin(ang);
    this.y = x*sin(ang) + y*cos(ang);
    return this;
  }

  Vector normalise() {
    float m = mag();
    if (m != 0f && m != 1f) {
      div(m);
    }
    return this;
  }

  Vector setMag(float m) {
    normalise();
    mult(m);
    return this;
  }

  Vector lerp(Vector v, float amt) {
    this.x = PApplet.lerp(this.x, v.x, amt);
    this.y = PApplet.lerp(this.y, v.y, amt);
    this.z = PApplet.lerp(this.z, v.z, amt);
    return this;
  }
}
