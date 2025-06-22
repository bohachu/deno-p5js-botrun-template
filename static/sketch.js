let particles = [];
let textPoints = [];
let font;
let phase = 0;

function preload() {
  // Use default font
}

function setup() {
  createCanvas(windowWidth, windowHeight);
  colorMode(HSB, 360, 100, 100, 100);
  
  // Create text points
  textSize(48);
  textAlign(CENTER, CENTER);
  
  // Sample the text to get points
  let bounds = font ? font.textBounds('💗波狄龍', 0, 0, 48) : {w: 300, h: 60};
  let x = width / 2 - bounds.w / 2;
  let y = height / 2 - 60;
  
  // Create particles for animation
  for (let i = 0; i < 150; i++) {
    particles.push(new Particle());
  }
}

function draw() {
  // Dynamic gradient background
  for (let i = 0; i <= height; i++) {
    let inter = map(i, 0, height, 0, 1);
    let c = lerpColor(
      color((frameCount * 0.5) % 360, 80, 20),
      color((frameCount * 0.5 + 180) % 360, 80, 10),
      inter
    );
    stroke(c);
    line(0, i, width, i);
  }
  
  // Update and display particles
  for (let particle of particles) {
    particle.update();
    particle.display();
  }
  
  // Draw main text with glow effect
  push();
  drawingContext.shadowBlur = 30;
  drawingContext.shadowColor = 'rgba(255, 105, 180, 0.8)';
  
  // Animated text
  textSize(60 + sin(frameCount * 0.05) * 10);
  fill(330, 80, 100);
  stroke(0, 0, 100);
  strokeWeight(3);
  text('💗波狄龍', width / 2, height / 2 - 60);
  
  // Subtitle
  textSize(32 + sin(frameCount * 0.05 + PI) * 5);
  fill(200, 80, 100);
  stroke(0, 0, 100);
  strokeWeight(2);
  text('Boosted by Botrun.ai', width / 2, height / 2 + 20);
  pop();
  
  // Floating elements
  phase += 0.03;
  for (let i = 0; i < 5; i++) {
    let x = width / 2 + cos(phase + i * PI / 2.5) * 200;
    let y = height / 2 + sin(phase + i * PI / 2.5) * 100;
    push();
    translate(x, y);
    rotate(frameCount * 0.02 + i);
    noFill();
    stroke((frameCount + i * 50) % 360, 80, 100);
    strokeWeight(2);
    star(0, 0, 20, 40, 5);
    pop();
  }
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
}

class Particle {
  constructor() {
    this.x = random(width);
    this.y = random(height);
    this.size = random(2, 8);
    this.speedX = random(-1, 1);
    this.speedY = random(-2, -0.5);
    this.hue = random(300, 360);
  }
  
  update() {
    this.x += this.speedX;
    this.y += this.speedY;
    
    if (this.y < -10) {
      this.y = height + 10;
      this.x = random(width);
    }
    if (this.x < -10) this.x = width + 10;
    if (this.x > width + 10) this.x = -10;
  }
  
  display() {
    noStroke();
    fill(this.hue, 80, 100, 50);
    ellipse(this.x, this.y, this.size);
  }
}

function star(x, y, radius1, radius2, npoints) {
  let angle = TWO_PI / npoints;
  let halfAngle = angle / 2.0;
  beginShape();
  for (let a = 0; a < TWO_PI; a += angle) {
    let sx = x + cos(a) * radius2;
    let sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a + halfAngle) * radius1;
    sy = y + sin(a + halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}